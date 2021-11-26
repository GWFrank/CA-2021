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

    reg [ADDR_W-1:0] pc;
    reg [3:0] cs, ns;
    reg [6:0] opcode_r, opcode_w;
    reg [4:0] rd_r, rd_w, rs1_r, rs1_w, rs2_r, rs2_w;
    reg [64:0] imm_r, imm_w;
    reg signed [64:0] imm_s_r, imm_s_w;
    reg [2:0] func3_r, func3_w;
    reg [6:0] func7_r, func7_w;
    reg [DATA_W-1:0] reg_file[31:0];

    integer i;

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
            4'd14: ns=0;
            default: ns=0;
        endcase
    end

    always @(*) begin
        // Fetch instruction
        if (cs == 0) begin
            o_i_valid_addr_w = 1;
            o_i_addr_w = pc;
        end else begin
            o_i_valid_addr_w = 0;
            o_i_addr_w = 0;
        end
    end

    always @(*) begin
        // Decode
        if (cs == 6 && i_i_valid_inst) begin
            opcode_w = i_i_inst[6:0];
            rd_w = i_i_inst[11:7];
            rs1_w = i_i_inst[19:15];
            rs2_w = i_i_inst[24-20];
            func3_w = i_i_inst[14:12];
            func7_w = i_i_inst[31:25];
            case (opcode)
                7'b0000011: begin
                    imm = {52'b0, i_i_inst[31:20]};
                    imm_s = 0;
                end
                7'b0100011: begin
                    imm = {52'b0, i_i_inst[31:25], i_i_inst[11:7]};
                    imm_s = 0;
                end
                7'b1100011: begin
                    imm = 0;
                    imm_s = {{52{i_i_inst[31]}}, i_i_inst[31], i_i_inst[7], i_i_inst[30:25], i_i_inst[11:8], 1'b0};
                end
                7'b0010011: begin
                    imm = {52'b0, i_i_inst[31:20]};
                    imm_s = 0;
                end
                7'b0110011: begin
                    imm = 0;
                    imm_s = 0;
                end
                default: begin
                    imm = 0;
                    imm_s = 0;
                end
            endcase
        end else begin
            opcode_w = opcode_r;
            rd_w = rd_r;
            rs1_w = rs1_r;
            rs2_w = rs2_r;
            func3_w = func3_r;
            func7_w = func7_r;
            imm_w = imm_r;
            imm_s_w = imm_s_r;
        end
        
    end

    // Memory
    instruction_memory #(
        .ADDR_W(ADDR_W),
        .INST_W(INST_W),
        .MAX_INST(MAX_INST)
    ) u_inst_mem (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_valid(o_i_valid_addr),
        .i_addr(o_i_addr),
        .o_valid(i_i_valid_inst),
        .o_inst(i_i_inst)
    );

    data_memory #(
        .ADDR_W(ADDR_W),
        .DATA_W(DATA_W)
    ) u_data_mem (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_data(o_d_data),
        .i_addr(o_d_addr),
        .i_MemRead(o_d_MemRead),
        .i_MemWrite(o_d_MemWrite),
        .o_valid(i_d_valid_data),
        .o_data(i_d_data)
    );

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
            for (i=0; i<32; i++) begin
                reg_file[i] <= 0;
            end
            
        end else begin
            o_i_valid_addr_r <= o_i_valid_addr_w;
            o_i_addr_r <= o_i_addr_w;
            o_d_data_r <= o_d_data_w;
            o_d_addr_r <= o_d_addr_w;
            o_d_MemRead_r <= o_d_MemRead_w;
            o_d_MemWrite_r <= o_d_MemWrite_w;
            o_finish_r <= o_finish_w;
        end
    end



endmodule
