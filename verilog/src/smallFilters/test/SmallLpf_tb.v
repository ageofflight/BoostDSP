module SmallLpf_tb ();

reg clk;
reg rst;
reg en;
reg signed [7:0] dataIn;
wire signed [7:0] dataOut;

integer i, j;

initial begin
    clk = 1'b0;
    rst = 1'b1;
    en = 1'b1;
    dataIn = 'd0;
    #2 rst = 1'b0;
    for (i=1; i<100; i=i+1) begin
        for (j=0; j<2048; j=j+1) begin
            @(posedge clk) dataIn = $rtoi(127*$sin(i*j*3.14159/1024));
        end
    end
end

always #1 clk = ~clk;

SmallLpf #(
    .WIDTH(8),
    .FILT_BITS(5)
)
uut (
    .clk(clk),                       // System clock
    .rst(rst),                       // Reset, active high and synchronous
    .en(en),                        // Filter enable
    .dataIn(dataIn),  ///< [WIDTH-1:0] // Filter input
    .dataOut(dataOut)  ///< [WIDTH-1:0] // Filter output
);

endmodule
