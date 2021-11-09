/*---------------------------------------------------------------------------
 *
 *  Module Name: convolution
 *
 *  Description:
 *    A module for calculating 3*3 convolution
 *
 *    input signals:
 *      - clk
 *          clock signal (positive edge triggered)
 *      - reset
 *          asynchronous reset signal (low active)
 *      - enable
 *          enables the module
 *      - pixel_0 ~ pixel_9
 *          image pixel values (0 to 255)
 *      - kernel_0 ~ kernel_9
 *          kernel weight corresponding to the pixel bit
 *
 *    output signals:
 *      - data_rdy: signal that represents that the output is ready
 *      - data_out: output value of the convolution
 *
 *----------------------*/

module convolution (
    input clk,
    input reset,
    input enable,

    input [7:0] pixel_1,
    input [7:0] pixel_2,
    input [7:0] pixel_3,
    input [7:0] pixel_4,
    input [7:0] pixel_5,
    input [7:0] pixel_6,
    input [7:0] pixel_7,
    input [7:0] pixel_8,
    input [7:0] pixel_9,

    input [8:0] kernel_1,
    input [8:0] kernel_2,
    input [8:0] kernel_3,
    input [8:0] kernel_4,
    input [8:0] kernel_5,
    input [8:0] kernel_6,
    input [8:0] kernel_7,
    input [8:0] kernel_8,
    input [8:0] kernel_9,

    output       data_rdy,
    output [7:0] data_out
);

reg        [3:0] count;
reg signed [8:0] pixel_sel;
reg signed [8:0] kernel_sel;
reg signed [17:0] sum;

reg [7:0] out;
reg       rdy;

wire [17:0] mul;

assign data_out = out;
assign data_rdy = rdy;

multiplier mul_unit (
    .num1(pixel_sel),
    .num2(kernel_sel),
    .out(mul)
);

always @(posedge clk or negedge reset) begin
    if (reset == 1'b0) begin
        count <= 4'd0;
        sum <= 18'd0;
        out <= 8'd0;
        rdy <= 1'b0;
    end else if (enable == 1'b1) begin
        if (count == 4'd0) begin
            count <= count + 4'd1;
            rdy <= 1'b0;
        end else if (count < 4'd9) begin
            sum <= sum + mul;
            count <= count + 4'd1;
        end else if (count == 4'd9) begin
            sum <= sum + mul;
            sum <= sum / 18'd9;

            if (sum > 18'd255)
                sum <= 18'd255;
            
            out <= sum[7:0];
            rdy <= 1'b1;
            count <= 4'd0;
        end
    end
end

always @(count,
         pixel_1, pixel_2, pixel_3, pixel_4, pixel_5, pixel_6, pixel_7, pixel_8, pixel_9,
         kernel_1, kernel_2, kernel_3, kernel_4, kernel_5, kernel_6, kernel_7, kernel_8, kernel_9)
    begin
    case (count)
        4'd0 : begin
            pixel_sel = {1'b0, pixel_1};
            kernel_sel = kernel_1;
        end
        4'd1 : begin
            pixel_sel = {1'b0, pixel_2};
            kernel_sel = kernel_2;
        end
        4'd2 : begin
            pixel_sel = {1'b0, pixel_3};
            kernel_sel = kernel_3;
        end
        4'd3 : begin
            pixel_sel = {1'b0, pixel_4};
            kernel_sel = kernel_4;
        end
        4'd4 : begin
            pixel_sel = {1'b0, pixel_5};
            kernel_sel = kernel_5;
        end
        4'd5 : begin
            pixel_sel = {1'b0, pixel_6};
            kernel_sel = kernel_6;
        end
        4'd6 : begin
            pixel_sel = {1'b0, pixel_7};
            kernel_sel = kernel_7;
        end
        4'd7 : begin
            pixel_sel = {1'b0, pixel_8};
            kernel_sel = kernel_8;
        end
        4'd8 : begin
            pixel_sel = {1'b0, pixel_9};
            kernel_sel = kernel_9;
        end
        default: begin
            pixel_sel = {1'b0, pixel_1};
            kernel_sel = kernel_1;
        end
    endcase
end
    
endmodule


module multiplier (
    input  [8:0]  num1,
    input  [8:0]  num2,
    output [17:0] out
);

reg [17:0] res;

assign out = res;

always @(*) begin
    res = num1 * num2;
end
    
endmodule