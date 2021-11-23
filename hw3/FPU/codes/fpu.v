module fpu #(
    parameter DATA_WIDTH = 32,
    parameter INST_WIDTH = 1
)(
    input                   i_clk,
    input                   i_rst_n,
    input  [DATA_WIDTH-1:0] i_data_a,
    input  [DATA_WIDTH-1:0] i_data_b,
    input  [INST_WIDTH-1:0] i_inst,
    input                   i_valid,
    output [DATA_WIDTH-1:0] o_data,
    output                  o_valid
);

    // wires & regs
    reg [DATA_WIDTH-1:0] o_data_r, o_data_w;
    reg o_valid_r, o_valid_w;
    
    reg i_sign_a, i_sign_b;
    reg [7:0] i_exp_a, i_exp_b;
    // reg [23:0] i_frac_a, i_frac_b;
    reg [532:0] i_frac_a, i_frac_b; // 1 + 23(531~509) + 509(maximum possible shift) bits
    
    reg o_sign;
    reg [7:0] o_exp;
    // reg [23:0] o_frac;
    reg [532:0] o_frac;
    reg [47:0] o_frac_short;
    reg o_frac_of;

    reg round, sticky;
    integer i;

    // continuous assignment
    assign o_data = o_data_r;
    assign o_valid = o_valid_r;
    
    // combinational part
    always @(*) begin
        if (i_valid) begin
            i_sign_a = i_data_a[31];
            i_exp_a = i_data_a[30:23];
            i_frac_a = {1'b1, i_data_a[22:0], 509'b0};
            i_sign_b = i_data_b[31];
            i_exp_b = i_data_b[30:23];
            i_frac_b = {1'b1, i_data_b[22:0], 509'b0};
            case (i_inst)
                1'd0: begin
                    // 1. Shift frac with smaller exp
                    if (i_exp_a > i_exp_b) begin
                        i_frac_b = i_frac_b >> (i_exp_a-i_exp_b);
                        o_exp = i_exp_a;
                    end else if (i_exp_a < i_exp_b) begin
                        i_frac_a = i_frac_a >> (i_exp_b-i_exp_a);
                        o_exp = i_exp_b;
                    end else begin
                        o_exp = i_exp_a;
                    end
                    // 2. Add/sub frac
                    if (i_sign_a ~^ i_sign_b) begin // pos + pos or neg + neg
                        {o_frac_of, o_frac} = i_frac_a+i_frac_b;
                        o_sign = i_sign_a;
                    end else if ((~i_sign_a) && i_sign_b) begin // pos + neg
                        if (i_frac_a > i_frac_b) begin
                            {o_frac_of, o_frac} = i_frac_a-i_frac_b;
                            o_sign = 0;
                        end else begin
                            {o_frac_of, o_frac} = i_frac_b-i_frac_a;
                            o_sign = 1;
                        end
                    end else if (i_sign_a && (~i_sign_b)) begin // neg + pos
                        if (i_frac_a > i_frac_b) begin
                            {o_frac_of, o_frac} = i_frac_a-i_frac_b;
                            o_sign = 1;
                        end else begin
                            {o_frac_of, o_frac} = i_frac_b-i_frac_a;
                            o_sign = 0;
                        end
                    end
                    // 3. Normalize
                    if (o_frac_of) begin
                        o_frac = o_frac >> 1;
                        o_exp = o_exp + 1;
                    end else begin
                        while (~o_frac[532]) begin
                            o_frac = o_frac << 1;
                            o_exp = o_exp - 1;
                        end
                    end
                    // 4. Round & re-normalize
                    round = o_frac[508];
                    sticky = 0;
                    for (i=0; i<508; i++) begin
                        sticky = sticky | o_frac[i];
                    end
                    if ((~round) && ~(sticky)) begin // RS = 00
                        o_data_w = {o_sign, o_exp, o_frac[531:509]};
                        o_valid_w = 1;
                    end else if ((~round) && sticky) begin // RS = 01
                        o_data_w = {o_sign, o_exp, o_frac[531:509]};
                        o_valid_w = 1;
                    end else if (round && sticky) begin // RS = 11
                        {o_frac_of, o_frac} = {o_frac[531:509] + 23'b1, 509'b0};
                        if (o_frac_of) begin
                            o_frac = o_frac >> 1;
                            o_exp = o_exp + 1;
                            o_data_w = {o_sign, o_exp, o_frac[531:509]};
                            o_valid_w = 1;
                        end else begin
                            o_data_w = {o_sign, o_exp, o_frac[531:509]};
                            o_valid_w = 1;
                        end
                    end else begin // RS = 10
                        if (o_frac[509]) begin
                            o_data_w = {o_sign, o_exp, o_frac[531:509]};
                            o_valid_w = 1;
                        end else begin
                            {o_frac_of, o_frac} = {o_frac[531:509] + 23'b1, 509'b0};
                            if (o_frac_of) begin
                                o_frac = o_frac >> 1;
                                o_exp = o_exp + 1;
                                o_data_w = {o_sign, o_exp, o_frac[531:509]};
                                o_valid_w = 1;
                            end else begin
                                o_data_w = {o_sign, o_exp, o_frac[531:509]};
                                o_valid_w = 1;
                            end
                        end
                    end
                end
                1'd1: begin
                    o_data_w = 0;
                    o_valid_w = 1;
                    // 1. Add exp
                    o_exp = i_exp_a + i_exp_b - 8'd127; // biased exp
                    // 2. Mul frac
                    o_frac_short = i_frac_a[532:509] * i_frac_b[532:509];
                    // 3. Normalize
                    if (o_frac_short[47]) begin
                        o_frac_short = o_frac_short >> 1;
                        o_exp = o_exp + 1;
                    end else begin
                        while (~o_frac_short[46]) begin
                            o_frac_short = o_frac_short << 1;
                            o_exp = o_exp - 1;
                        end
                    end
                    // 4. Calc sign
                    o_sign = i_sign_a^i_sign_b;
                    // 5. Round
                    round = o_frac_short[22];
                    sticky = 0;
                    for (i=0; i<23; i++) begin
                        sticky = sticky | o_frac_short[i];
                    end
                    if ((~round) && ~(sticky)) begin // RS = 00
                        o_data_w = {o_sign, o_exp, o_frac_short[45:23]};
                        o_valid_w = 1;
                    end else if ((~round) && sticky) begin // RS = 01
                        o_data_w = {o_sign, o_exp, o_frac_short[45:23]};
                        o_valid_w = 1;
                    end else if (round && sticky) begin // RS = 11
                        o_frac_short = {o_frac_short[46:23] + 24'b1, 23'b0};
                        if (o_frac_short[47]) begin
                            o_frac = o_frac >> 1;
                            o_exp = o_exp + 1;
                            o_data_w = {o_sign, o_exp, o_frac_short[45:23]};
                            o_valid_w = 1;
                        end else begin
                            o_data_w = {o_sign, o_exp, o_frac_short[45:23]};
                            o_valid_w = 1;
                        end
                    end else begin // RS = 10
                        if (o_frac_short[23]) begin
                            o_data_w = {o_sign, o_exp, o_frac_short[45:23]};
                            o_valid_w = 1;
                        end else begin
                            o_frac_short = {o_frac_short[46:23] + 24'b1, 23'b0};
                            if (o_frac_short[47]) begin
                                o_frac = o_frac >> 1;
                                o_exp = o_exp + 1;
                                o_data_w = {o_sign, o_exp, o_frac_short[45:23]};
                                o_valid_w = 1;
                            end else begin
                                o_data_w = {o_sign, o_exp, o_frac_short[45:23]};
                                o_valid_w = 1;
                            end
                        end
                    end
                    
                end
                default: begin
                    o_data_w = 0;
                    o_valid_w = 1;
                end
            endcase
        end else begin
            o_data_w = 0;
            o_valid_w = 0;
        end
    end
    // sequential part 
    always @(posedge i_clk or negedge i_rst_n ) begin
        if (~i_rst_n) begin
            o_data_r <= 0;
            o_valid_r <= 0;
        end else begin
            o_data_r <= o_data_w;
            o_valid_r <= o_valid_w;
        end
    end
    

endmodule