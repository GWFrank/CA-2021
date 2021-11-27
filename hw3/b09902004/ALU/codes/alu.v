module alu #(
    parameter DATA_WIDTH = 32,
    parameter INST_WIDTH = 4
)(
    input                   i_clk,
    input                   i_rst_n,
    input  [DATA_WIDTH-1:0] i_data_a,
    input  [DATA_WIDTH-1:0] i_data_b,
    input  [INST_WIDTH-1:0] i_inst,
    input                   i_valid,
    output [DATA_WIDTH-1:0] o_data,
    output                  o_overflow,
    output                  o_valid
);

    parameter INT32_MAX = 2147483647;
    parameter INT32_MIN = -2147483648;
    parameter UINT32_MAX = 32'hffffffff;

    // wires & registers
    wire signed [DATA_WIDTH-1:0] s_i_data_a, s_i_data_b;
    wire a_msb, b_msb, o_msb;
    reg [DATA_WIDTH-1:0] o_data_r, o_data_w;
    reg signed [2*DATA_WIDTH-1:0] s_mul_tmp;
    reg [2*DATA_WIDTH-1:0] mul_tmp;
    reg o_overflow_r, o_overflow_w;
    reg o_valid_r, o_valid_w;

    // continuous assignment
    assign s_i_data_a = i_data_a;
    assign s_i_data_b = i_data_b;
    assign a_msb = s_i_data_a[DATA_WIDTH-1];
    assign b_msb = s_i_data_b[DATA_WIDTH-1];
    assign o_msb = o_data_w[DATA_WIDTH-1];
    assign o_data = o_data_r;
    assign o_overflow = o_overflow_r;
    assign o_valid = o_valid_r;


    // combinational part
    always @(*) begin
        if (i_valid) begin
            case (i_inst)
                4'd0: begin // signed add
                    o_data_w = s_i_data_a + s_i_data_b;
                    o_overflow_w = (a_msb~^b_msb)&(a_msb^o_msb);
                    o_valid_w = 1;
                end
                4'd1: begin // signed sub
                    o_data_w = s_i_data_a - s_i_data_b;
                    o_overflow_w = (a_msb^b_msb)&(a_msb^o_msb);
                    o_valid_w = 1;
                end
                4'd2: begin // signed mul
                    s_mul_tmp = s_i_data_a * s_i_data_b;
                    o_data_w = s_i_data_a * s_i_data_b;
                    o_overflow_w = (s_mul_tmp>INT32_MAX || s_mul_tmp<INT32_MIN);
                    o_valid_w = 1;
                end
                4'd3: begin // signed max
                    if (s_i_data_a >= s_i_data_b) begin
                        o_data_w = s_i_data_a;
                        o_overflow_w = 0;
                        o_valid_w = 1;
                    end else begin
                        o_data_w = s_i_data_b;
                        o_overflow_w = 0;
                        o_valid_w = 1;
                    end
                end
                4'd4: begin // signed min
                    if (s_i_data_a <= s_i_data_b) begin
                        o_data_w = s_i_data_a;
                        o_overflow_w = 0;
                        o_valid_w = 1;
                    end else begin
                        o_data_w = s_i_data_b;
                        o_overflow_w = 0;
                        o_valid_w = 1;
                    end
                end
                4'd5: begin // unsigned add
                    {o_overflow_w, o_data_w} = i_data_a + i_data_b;
                    o_valid_w = 1;
                end
                4'd6: begin // unsigned sub
                    {o_overflow_w, o_data_w} = i_data_a - i_data_b;
                    o_valid_w = 1;
                end
                4'd7: begin // unsigned mul
                    mul_tmp = i_data_a * i_data_b;
                    o_data_w = i_data_a * i_data_b;
                    o_overflow_w = (mul_tmp>UINT32_MAX);
                    o_valid_w = 1;
                    o_valid_w = 1;
                end
                4'd8: begin // unsigned max
                    if (i_data_a >= i_data_b) begin
                        o_data_w = i_data_a;
                        o_overflow_w = 0;
                        o_valid_w = 1;
                    end else begin
                        o_data_w = i_data_b;
                        o_overflow_w = 0;
                        o_valid_w = 1;
                    end
                end
                4'd9: begin // unsigned min
                    if (i_data_a <= i_data_b) begin
                        o_data_w = i_data_a;
                        o_overflow_w = 0;
                        o_valid_w = 1;
                    end else begin
                        o_data_w = i_data_b;
                        o_overflow_w = 0;
                        o_valid_w = 1;
                    end
                end
                4'd10: begin // and
                    o_data_w = i_data_a & i_data_b;
                    o_overflow_w = 0;
                    o_valid_w = 1;
                end
                4'd11: begin // or
                    o_data_w = i_data_a | i_data_b;
                    o_overflow_w = 0;
                    o_valid_w = 1;
                end
                4'd12: begin // xor
                    o_data_w = i_data_a ^ i_data_b;
                    o_overflow_w = 0;
                    o_valid_w = 1;
                end
                4'd13: begin // bit flip
                    o_data_w = ~i_data_a;
                    o_overflow_w = 0;
                    o_valid_w = 1;
                end
                4'd14: begin // bit reverse
                    o_data_w = i_data_a;
                    o_data_w = ((o_data_w&32'hffff0000)>>16|(o_data_w&32'h0000ffff)<<16);
                    o_data_w = ((o_data_w&32'hff00ff00)>>8|(o_data_w&32'h00ff00ff)<<8);
                    o_data_w = ((o_data_w&32'hf0f0f0f0)>>4|(o_data_w&32'h0f0f0f0f)<<4);
                    o_data_w = ((o_data_w&32'hcccccccc)>>2|(o_data_w&32'h33333333)<<2);
                    o_data_w = ((o_data_w&32'haaaaaaaa)>>1|(o_data_w&32'h55555555)<<1);
                    o_overflow_w = 0;
                    o_valid_w = 1;
                end
                
                default: begin
                    o_data_w = 0;
                    o_overflow_w = 0;
                    o_valid_w = 1;
                end
            endcase
        end else begin
            o_data_w = 0;
            o_overflow_w = 0;
            o_valid_w = 0;
        end
        
    end


    // sequential part 
    always @(posedge i_clk or negedge i_rst_n ) begin
        if (~i_rst_n) begin
            o_data_r <= 0;
            o_overflow_r <= 0;
            o_valid_r <= 0;
        end else begin
            o_data_r <= o_data_w;
            // else o_data_r <= s_o_data_w;
            o_overflow_r <= o_overflow_w;
            o_valid_r <= o_valid_w;
        end
    end

    

endmodule