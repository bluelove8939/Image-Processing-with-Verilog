`timescale 1ns/1ps


module convolution_test;

parameter  CLOCK_PS          = 10000;     // should be a multiple of 10
localparam clock_period      = CLOCK_PS/1000.0;
localparam half_clock_period = clock_period / 2;
localparam minimum_period    = clock_period / 10;

reg clk;
reg reset;
reg enable;

reg [7:0] pixel_1;
reg [7:0] pixel_2;
reg [7:0] pixel_3;
reg [7:0] pixel_4;
reg [7:0] pixel_5;
reg [7:0] pixel_6;
reg [7:0] pixel_7;
reg [7:0] pixel_8;
reg [7:0] pixel_9;

reg [8:0] kernel_1;
reg [8:0] kernel_2;
reg [8:0] kernel_3;
reg [8:0] kernel_4;
reg [8:0] kernel_5;
reg [8:0] kernel_6;
reg [8:0] kernel_7;
reg [8:0] kernel_8;
reg [8:0] kernel_9;

wire       rdy;
wire [7:0] out;

convolution conv_module (
    .clk(clk),
    .reset(reset),
    .enable(enable),

    .pixel_1(pixel_1), .pixel_2(pixel_2), .pixel_3(pixel_3),
    .pixel_4(pixel_4), .pixel_5(pixel_5), .pixel_6(pixel_6),
    .pixel_7(pixel_7), .pixel_8(pixel_8), .pixel_9(pixel_9),

    .kernel_1(kernel_1), .kernel_2(kernel_2), .kernel_3(kernel_3),
    .kernel_4(kernel_4), .kernel_5(kernel_5), .kernel_6(kernel_6),
    .kernel_7(kernel_7), .kernel_8(kernel_8), .kernel_9(kernel_9),

    .data_rdy(rdy),
    .data_out(out)
);

initial begin : CLOCK_GENERATOR
    clk = 1'b0;
    forever
        # half_clock_period clk = ~clk;
end

integer i_count;

initial begin
    reset = 1'b1;

    # minimum_period;
    reset = 0;        // activate reset of active low
    # (clock_period);
    @ (posedge clk);
    # (half_clock_period - 2 * minimum_period);

    reset = 1;
    enable = 1'b1;

    @ (posedge clk);


    // Test1: pixels and kernel weights are all zeros
    // initializing pixel values and kernel weights

    $display("Test1: pixels and kernel weights are all zeros");

    pixel_1 = 8'd0; pixel_2 = 8'd0; pixel_3 = 8'd0;
    pixel_4 = 8'd0; pixel_5 = 8'd0; pixel_6 = 8'd0;
    pixel_7 = 8'd0; pixel_8 = 8'd0; pixel_9 = 8'd0;

    kernel_1 = 9'd0; kernel_2 = 9'd0; kernel_3 = 9'd0;
    kernel_4 = 9'd0; kernel_5 = 9'd0; kernel_6 = 9'd0;
    kernel_7 = 9'd0; kernel_8 = 9'd0; kernel_9 = 9'd0;

    i_count = 0;

    while (i_count < 10) begin
        # clock_period;
        i_count = i_count + 1;
    end

    if (rdy == 1'b1)
        $display("i_count = %d -> process finished: out = %d", i_count, out);
    else
        $display("i_count = %d -> process not finished", i_count);


    // Test2: kernel is sharpen filter
    // initializing pixel values and kernel weights

    $display("Test2: kernel is sharpen filter");

    pixel_1 = 8'd1; pixel_2 = 8'd1; pixel_3 = 8'd1;
    pixel_4 = 8'd0; pixel_5 = 8'd1; pixel_6 = 8'd0;
    pixel_7 = 8'd1; pixel_8 = 8'd1; pixel_9 = 8'd0;

    kernel_1 = 0;  kernel_2 = -1; kernel_3 = 0;
    kernel_4 = -1; kernel_5 = 5;  kernel_6 = -1;
    kernel_7 = 0;  kernel_8 = -1; kernel_9 = 0;

    i_count = 0;

    while (i_count < 10) begin
        # clock_period;
        i_count = i_count + 1;
    end

    if (rdy == 1'b1)
        $display("i_count = %d -> process finished: out = %d", i_count, out);
    else
        $display("i_count = %d -> process not finished", i_count);


    // Test termination
    # clock_period;
    disable CLOCK_GENERATOR;
    $display("SIMULATION TERMINATED at %0t", $time);
    $stop(2);
end
    
endmodule