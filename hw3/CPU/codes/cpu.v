module cpu #( // Do not modify interface
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input                   i_clk,
    input                   i_rst_n,
    input                   i_i_valid_inst, // from instruction memory
    input  [ INST_W-1 : 0 ] i_i_inst,       // from instruction memory
    input                   i_d_valid_data, // from data memory
    input  [ DATA_W-1 : 0 ] i_d_data,       // from data memory
    output                  o_i_valid_addr, // to instruction memory
    output [ ADDR_W-1 : 0 ] o_i_addr,       // to instruction memory
    output [ DATA_W-1 : 0 ] o_d_data,       // to data memory
    output [ ADDR_W-1 : 0 ] o_d_addr,       // to data memory
    output                  o_d_MemRead,    // to data memory
    output                  o_d_MemWrite,   // to data memory
    output                  o_finish
);

    // Wires & registers
    reg o_i_valid_addr_r, o_i_valid_addr_w;
    reg [ADDR_W-1:0] o_i_addr_r, o_i_addr_w;
    reg [DATA_W-1:0] o_d_data_r, o_d_data_w;
    reg [ADDR_W-1:0] o_d_addr_r, o_d_addr_w;
    reg o_d_MemRead_r, o_d_MemRead_w;
    reg o_d_MemWrite_r, o_d_MemWrite_w;
    reg o_finish_r, o_finish_w;

    reg [6:0] opcode_r, opcode_w;
    reg [4:0] rd_r, rd_w, rs1, rs2;
    reg [DATA_W-1:0] imm_r, imm_w;
    reg signed [DATA_W-1:0] imm_s_r, imm_s_w;
    reg [2:0] func3;
    reg [6:0] func7;
    
    reg [ADDR_W-1:0] pc_r, pc_w;
    reg [3:0] cs, ns;
    reg [DATA_W-1:0] alu_res_r, alu_res_w;
    reg take_br_r, take_br_w;
    reg [DATA_W-1:0] reg_file[31:0];

    integer i;
    parameter stage0 = 0;
    parameter stage1 = 7;
    parameter stage_pc = 15;

    // Continuous assignment
    assign o_i_valid_addr = o_i_valid_addr_r;
    assign o_i_addr = o_i_addr_r;
    assign o_d_data = o_d_data_r;
    assign o_d_addr = o_d_addr_r;
    assign o_d_MemRead = o_d_MemRead_r;
    assign o_d_MemWrite = o_d_MemWrite_r;
    assign o_finish = o_finish_r;

    // Combinational part
    always @(*) begin
        // next state logic
        case (cs)
            4'd0: ns=1;
            4'd1: ns=2;
            4'd2: ns=3;
            4'd3: ns=4;
            4'd4: ns=5;
            4'd5: ns=6;
            4'd6: ns=7;
            4'd7: ns=8;
            4'd8: ns=9;
            4'd9: ns=10;
            4'd10: ns=11;
            4'd11: ns=12;
            4'd12: ns=13;
            4'd13: ns=14;
            4'd14: ns=15;
            4'd15: ns=0;
            default: ns=0;
        endcase
    end

    always @(*) begin
        // Fetch instruction
        if (cs == stage0) begin
            o_i_valid_addr_w = 1;
            o_i_addr_w = pc_r;
        end else begin
            o_i_valid_addr_w = 0;
            o_i_addr_w = 0;
        end
    end

    always @(*) begin
        // Decode
        if (cs == stage1 && i_i_valid_inst) begin
            opcode_w = i_i_inst[6:0];
            rd_w = i_i_inst[11:7];
            rs1 = i_i_inst[19:15];
            rs2 = i_i_inst[24:20];
            func3 = i_i_inst[14:12];
            func7 = i_i_inst[31:25];
            case (opcode_w)
                7'b0000011: begin
                    imm_w = {52'b0, i_i_inst[31:20]};
                    imm_s_w = 0;
                end
                7'b0100011: begin
                    imm_w = {52'b0, i_i_inst[31:25], i_i_inst[11:7]};
                    imm_s_w = 0;
                end
                7'b1100011: begin
                    imm_w = 0;
                    imm_s_w = {{52{i_i_inst[31]}}, i_i_inst[31], i_i_inst[7], i_i_inst[30:25], i_i_inst[11:8], 1'b0};
                end
                7'b0010011: begin
                    imm_w = {52'b0, i_i_inst[31:20]};
                    imm_s_w = 0;
                end
                7'b0110011: begin
                    imm_w = 0;
                    imm_s_w = 0;
                end
                default: begin
                    imm_w = 0;
                    imm_s_w = 0;
                end
            endcase
            if (opcode_w == 7'b1111111) begin
                o_finish_w = 1;
            end else begin
                o_finish_w = 0;
            end
        end else begin
            opcode_w = opcode_r;
            rd_w = rd_r;
            imm_w = imm_r;
            imm_s_w = imm_s_r;
            o_finish_w = o_finish_r;
        end
    end

    always @(*) begin
        // ALU operations
        if (cs == stage1) begin
            case (opcode_w)
                7'b0010011: begin
                    case (func3)
                        3'b000: begin // addi
                            alu_res_w = reg_file[rs1]+imm_w;
                        end
                        3'b100: begin // xori
                            alu_res_w = reg_file[rs1]^imm_w;
                        end
                        3'b110: begin // ori
                            alu_res_w = reg_file[rs1]|imm_w;
                        end
                        3'b111: begin // andi
                            alu_res_w = reg_file[rs1]&imm_w;
                        end
                        3'b001: begin // slli
                            alu_res_w = reg_file[rs1]<<imm_w;
                        end
                        3'b101: begin // srli
                            alu_res_w = reg_file[rs1]>>imm_w;
                        end
                        default: begin
                            alu_res_w = 0;
                        end
                    endcase
                end
                7'b0110011: begin
                    case (func3)
                        3'b000: begin
                            if (func7 == 7'b0) begin // add
                                alu_res_w = reg_file[rs1]+reg_file[rs2];
                            end else begin // sub
                                alu_res_w = reg_file[rs1]-reg_file[rs2];
                            end
                        end
                        3'b100: begin // xor
                            alu_res_w = reg_file[rs1]^reg_file[rs2];
                        end
                        3'b110: begin // or
                            alu_res_w = reg_file[rs1]|reg_file[rs2];
                        end
                        3'b111: begin // and
                            alu_res_w = reg_file[rs1]&reg_file[rs2];
                        end
                        default: begin
                            alu_res_w = 0;
                        end
                    endcase
                end
                default: begin
                    alu_res_w = 0;
                end
            endcase
        end else begin
            alu_res_w = alu_res_r;
        end
    end

    always @(*) begin
        // Test branch
        if (cs == stage1) begin
            case (opcode_w)
                7'b1100011: begin
                    if (func3 == 3'b0) begin // beq
                        take_br_w = (reg_file[rs1]==reg_file[rs2]);
                    end else begin // bne
                        take_br_w = (reg_file[rs1]!=reg_file[rs2]);
                    end
                end
                default: begin
                    take_br_w = 0;
                end
            endcase
        end else begin
            take_br_w = take_br_r;
        end
    end

    always @(*) begin
        // Access data mem
        if (cs == stage1) begin
            case (opcode_w)
                7'b0000011: begin
                    o_d_MemRead_w = 1;
                    o_d_MemWrite_w = 0;
                    o_d_addr_w = reg_file[rs1]+imm_w;
                    o_d_data_w = 0;
                end
                7'b0100011: begin
                    o_d_MemRead_w = 0;
                    o_d_MemWrite_w = 1;
                    o_d_addr_w = reg_file[rs1]+imm_w;
                    o_d_data_w = reg_file[rs2];
                end
                default: begin
                    o_d_MemRead_w = 0;
                    o_d_MemWrite_w = 0;
                    o_d_addr_w = 0;
                    o_d_data_w = 0;
                end
            endcase
        end else begin
            o_d_MemRead_w = o_d_MemRead_r;
            o_d_MemWrite_w = o_d_MemWrite_r;
            o_d_addr_w = o_d_addr_r;
            o_d_data_w = o_d_data_r;
        end
    end

    always @(*) begin
        // Write to register
        if (cs == stage0) begin
            case (opcode_r)
                7'b0000011: begin
                    if (i_d_valid_data) begin
                        reg_file[rd_r] = i_d_data;
                    end
                end
                7'b0010011: begin
                    reg_file[rd_r] = alu_res_r;
                end
                7'b0110011: begin
                    reg_file[rd_r] = alu_res_r;
                end
                default: begin
                    reg_file[0] = 0;
                end
            endcase
        end else begin
            reg_file[0] = 0;
        end
    end

    always @(*) begin
        // Calc pc
        if (cs == stage_pc) begin
            if (opcode_r == 7'b1100011) begin
                if (take_br_r) begin
                    pc_w = pc_r+imm_s_r;
                end else begin
                    pc_w = pc_r+4;
                end
            end else begin
                pc_w = pc_r+4;
            end
        end else begin
            pc_w = pc_r;
        end
    end

    // Sequential part
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_i_valid_addr_r <= 0;
            o_i_addr_r <= 0;
            o_d_data_r <= 0;
            o_d_addr_r <= 0;
            o_d_MemRead_r <= 0;
            o_d_MemWrite_r <= 0;
            o_finish_r <= 0;
            
            opcode_r <= 0;
            rd_r <= 0;
            imm_r <= 0;
            imm_s_r <= 0;
            
            pc_r <= 0;
            cs <= 0;
            alu_res_r <= 0;
            for (i=0; i<32; i++) begin
                reg_file[i] <= 0;
            end
            take_br_r <= 0;
            
        end else begin
            o_i_valid_addr_r <= o_i_valid_addr_w;
            o_i_addr_r <= o_i_addr_w;
            o_d_data_r <= o_d_data_w;
            o_d_addr_r <= o_d_addr_w;
            o_d_MemRead_r <= o_d_MemRead_w;
            o_d_MemWrite_r <= o_d_MemWrite_w;
            o_finish_r <= o_finish_w;
            
            opcode_r <= opcode_w;
            rd_r <= rd_w;
            imm_r <= imm_w;
            imm_s_r <= imm_s_w;
            
            pc_r <= pc_w;
            cs <= ns;
            alu_res_r <= alu_res_w;
            take_br_r <= take_br_w;
        end
    end



endmodule
