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

    reg pc;
    reg cs, ns;
    reg 

    // Continuous assignment
    assign o_i_valid_addr = o_i_valid_addr_r;
    assign o_i_addr = o_i_addr_r;
    assign o_d_data = o_d_data_r;
    assign o_d_addr = o_d_addr_r;
    assign o_d_MemRead = o_d_MemRead_r;
    assign o_d_MemWrite = o_d_MemWrite_r;
    assign o_finish = o_finish_r;

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

    // Combinational part

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
