`timescale 1ns/1ps


module buffer_block_test;

parameter  CLOCK_PS          = 10000;     // should be a multiple of 10
localparam clock_period      = CLOCK_PS/1000.0;
localparam half_clock_period = clock_period / 2;
localparam minimum_period    = clock_period / 10;

reg clk;
reg reset;
reg enable;

reg [7:0]  data_in;
reg [12:0] image_width;
reg [10:0] image_height;

wire filling_buffer;
wire emptying_buffer;

wire [7:0] pixel_1;
wire [7:0] pixel_2;
wire [7:0] pixel_3;
wire [7:0] pixel_4;
wire [7:0] pixel_5;
wire [7:0] pixel_6;
wire [7:0] pixel_7;
wire [7:0] pixel_8;
wire [7:0] pixel_9;

integer i_count;
integer pixel_value;
integer cnt_res;

buffer_block buffer_unit (
    .clk(clk),
    .reset(reset),
    .enable(enable),

    .data_in(data_in),
    .image_width(image_width),
    .image_height(image_height),

    .filling_buffer(filling_buffer),
    .emptying_buffer(emptying_buffer),

    .pixel_1(pixel_1), .pixel_2(pixel_2), .pixel_3(pixel_3),
    .pixel_4(pixel_4), .pixel_5(pixel_5), .pixel_6(pixel_6),
    .pixel_7(pixel_7), .pixel_8(pixel_8), .pixel_9(pixel_9)
);

initial begin : CLOCK_GENERATOR
    clk = 1'b0;
    forever
        # half_clock_period clk = ~clk;
end

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


    // Test: input image size: 10 * 4

    $display("Test: input image size: 10 * 4");

    image_width = 13'd10;
    image_height = 11'd6;
    pixel_value = 0;
    cnt_res = 0;

    while (pixel_value <= 80) begin
        if (filling_buffer == 1'b0 && emptying_buffer == 1'b0) begin
            $display("iteration: %4d", pixel_value);
            $display("%3d  %3d  %3d", pixel_1, pixel_2, pixel_3);
            $display("%3d  %3d  %3d", pixel_4, pixel_5, pixel_6);
            $display("%3d  %3d  %3d", pixel_7, pixel_8, pixel_9);
            cnt_res = cnt_res + 1;
        end

        # clock_period;
        pixel_value = pixel_value + 1;
        data_in = pixel_value;
    end

    $display("cnt = %d", cnt_res);


    // Test termination
    # clock_period;
    disable CLOCK_GENERATOR;
    $display("SIMULATION TERMINATED at %0t", $time);
    $stop(2);
end
    
endmodule


module block_ram_test;

parameter  CLOCK_PS          = 10000;     // should be a multiple of 10
localparam clock_period      = CLOCK_PS/1000.0;
localparam half_clock_period = clock_period / 2;
localparam minimum_period    = clock_period / 10;

reg clk;
reg reset;
reg [12:0] addr;
reg [7:0] d_in;

wire [7:0] d_out;

integer i_data;

block_ram ram_unit (
    .clk(clk),
    .reset(reset),
    .addr(addr),
    .d_in(d_in),
    .d_out(d_out)
);

initial begin : CLOCK_GENERATOR
    clk = 1'b0;
    forever
        # half_clock_period clk = ~clk;
end

initial begin
    reset = 1'b1;

    # minimum_period;
    reset = 0;        // activate reset of active low
    # (clock_period);
    @ (posedge clk);
    # (half_clock_period - 2 * minimum_period);

    reset = 1;


    // Test: input test

    $display("Test: input test");

    for (i_data = 0; i_data < 10; i_data = i_data+1) begin
        addr = i_data;
        d_in = i_data;
        # clock_period;
        $display("input data: %3d  output data: %3d", d_in, d_out);
    end

    // Test: output test

    $display("Test: input test");

    for (i_data = 10; i_data < 20; i_data = i_data+1) begin
        addr = i_data - 10;
        d_in = i_data;
        # clock_period;
        $display("input data: %3d  output data: %3d", d_in, d_out);
    end

    // Test termination
    # clock_period;
    disable CLOCK_GENERATOR;
    $display("SIMULATION TERMINATED at %0t", $time);
    $stop(2);
end
    
endmodule