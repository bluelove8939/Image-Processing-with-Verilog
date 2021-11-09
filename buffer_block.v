module buffer_block (
    input clk,
    input reset,
    input enable,

    input [7:0] data_in,
    input [12:0] image_width,
    input [10:0] image_height,

    output filling_buffer,
    output emptying_buffer,

    output [7:0] pixel_1,
    output [7:0] pixel_2,
    output [7:0] pixel_3,
    output [7:0] pixel_4,
    output [7:0] pixel_5,
    output [7:0] pixel_6,
    output [7:0] pixel_7,
    output [7:0] pixel_8,
    output [7:0] pixel_9
);

reg filling;
reg emptying;

reg [12:0] addr;
reg [12:0] cnt_cols;
reg [10:0] cnt_rows;

reg [7:0] bottom_sr [2:0];
reg [7:0] middle_sr [2:0];
reg [7:0] top_sr    [2:0];

wire [7:0] first_pb_in;
wire [7:0] first_pb_out;
wire [7:0] second_pb_in;
wire [7:0] second_pb_out;

assign filling_buffer = filling;
assign emptying_buffer = emptying;

assign pixel_1 = top_sr[2];
assign pixel_2 = top_sr[1];
assign pixel_3 = top_sr[0];
assign pixel_4 = middle_sr[2];
assign pixel_5 = middle_sr[1];
assign pixel_6 = middle_sr[0];
assign pixel_7 = bottom_sr[2];
assign pixel_8 = bottom_sr[1];
assign pixel_9 = bottom_sr[0];

block_ram first_pixel_buffer (
    .clk(clk),
    .reset(reset),
    .addr(addr),
    .d_in(bottom_sr[2]),
    .d_out(first_pb_out)
);

block_ram second_pixel_buffer (
    .clk(clk),
    .reset(reset),
    .addr(addr),
    .d_in(middle_sr[2]),
    .d_out(second_pb_out)
);

always @(posedge clk or negedge reset) begin
    if (reset == 1'b0) begin
        filling  <= 1'b1;
        emptying <= 1'b0;
        addr     <= 13'd0;
        cnt_cols <= 13'd0;
        cnt_rows <= 11'd1;
    end else if (enable == 1'b1) begin
        if (addr == image_width - 5) begin
            addr <= 13'd0;
        end else begin
            addr <= addr + 13'd1;
        end

        if (cnt_cols == image_width) begin
            cnt_cols <= 13'd1;
            cnt_rows <= cnt_rows + 11'd1;
        end else begin
            cnt_cols <= cnt_cols + 13'd1;
        end

        if (cnt_rows == 11'd3 && cnt_cols == 13'd3) begin
            filling <= 1'b0;
        end else if (cnt_rows > image_height) begin
            emptying <= 1'b1;
        end

        {bottom_sr[2], bottom_sr[1], bottom_sr[0]} <= {bottom_sr[1], bottom_sr[0], data_in};
        {middle_sr[2], middle_sr[1], middle_sr[0]} <= {middle_sr[1], middle_sr[0], first_pb_out};
        {top_sr[2], top_sr[1], top_sr[0]}          <= {top_sr[1], top_sr[0], second_pb_out};
    end
end
    
endmodule


module block_ram (
    input clk,
    input reset,
    input [12:0] addr,
    input [7:0] d_in,

    output [7:0] d_out
);

reg [7:0] out_reg;
reg [7:0] mem_block [2047:0];

assign d_out = out_reg;

integer i;

always @(posedge clk or negedge reset) begin
    if (reset == 1'b0) begin
        mem_block[0] <= 8'd0;
    end else begin
        out_reg <= mem_block[addr];
        mem_block[addr] <= d_in;
    end
end
    
endmodule