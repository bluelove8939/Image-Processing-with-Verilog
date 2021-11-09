module filter_selector (
    input clk,
    input [1:0] filter_sel,

    output [8:0] kernel_1,
    output [8:0] kernel_2,
    output [8:0] kernel_3,
    output [8:0] kernel_4,
    output [8:0] kernel_5,
    output [8:0] kernel_6,
    output [8:0] kernel_7,
    output [8:0] kernel_8,
    output [8:0] kernel_9
);

reg [8:0] kernel_reg1;
reg [8:0] kernel_reg2;
reg [8:0] kernel_reg3;
reg [8:0] kernel_reg4;
reg [8:0] kernel_reg5;
reg [8:0] kernel_reg6;
reg [8:0] kernel_reg7;
reg [8:0] kernel_reg8;
reg [8:0] kernel_reg9;

assign kernel_1 = kernel_reg1;
assign kernel_2 = kernel_reg2;
assign kernel_3 = kernel_reg3;
assign kernel_4 = kernel_reg4;
assign kernel_5 = kernel_reg5;
assign kernel_6 = kernel_reg6;
assign kernel_7 = kernel_reg7;
assign kernel_8 = kernel_reg8;
assign kernel_9 = kernel_reg9;

always @(posedge clk) begin
    case (filter_sel)
        2'b00: 
        default:
    endcase
end
    
endmodule