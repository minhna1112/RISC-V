/*
 * Ask me anything: via repo/issue, or e-mail: vencifreeman16@sjtu.edu.cn.
 * Author: @VenciFreeman (GitHub), copyright 2019.
 * School: Shanghai Jiao Tong University.

 * Description:
 * This file controls the read and write about data_mem.

 * Details:
 * - Read 32 bit data from data_mem if instruction is lw;
 * - Write 32 bit data into data_mem if instruction is sw;
 * - Do no operation if there is other instruction.

 * History:
 * - 19/12/27: Create this pipeline file;
 * - 19/12/28: Fix some errors;
 * - 19/12/29: Finished!

 * Notes:
 *
 */

module MEM(

    input   wire        rst,
    input   wire        WriteReg_i,
    input   wire[4:0]   WriteDataAddr_i,
    input   wire[4:0]   ALUop_i,
    input   wire[31:0]  WriteData_i,
    input   wire[31:0]  MemAddr_i,
    input   wire[31:0]  Reg_i,
    input   wire[31:0]  MemData_i,
    output  wire        MemWE_o,
    output  reg         WriteReg_o,
    output  reg         MemCE_o,
    output  reg [4:0]   WriteDataAddr_o,
    output  reg [31:0]  WriteData_o,
    output  reg [31:0]  MemAddr_o,
    output  reg [31:0]  MemData_o

);

    reg mem_we;
    assign MemWE_o = mem_we;

/*
 * This always part controls the signal WriteDataAddr_o.
 */ 
always @ (*) begin
    if (rst)
        WriteDataAddr_o <= 5'b0;
    else
        WriteDataAddr_o <= WriteDataAddr_i;
end

/*
 * This always part controls the signal WriteReg_o.
 */ 
always @ (*) begin
    if (rst)
        WriteReg_o <= 1'b0;
    else
        WriteReg_o <= WriteReg_i;
end

/*
 * This always part controls the signal MemData_o.
 */ 
always @ (*) begin
    if (rst)
        MemData_o <= 32'b0;
    else if (ALUop_i == 5'b10101)  // sw
        MemData_o <= Reg_i;
end

/*
 * This always part controls the signal WriteData_o.
 */ 
always @ (*) begin
    if (rst)
        WriteData_o <= 32'b0;
    else begin
        WriteData_o <= WriteData_i;
        if (ALUop_i == 5'b10100)  // lw
            WriteData_o <= MemData_i;
    end
end

/*
 * This always part controls the signal MemAddr_o.
 */ 
always @ (*) begin
    if (rst)
        MemAddr_o <= 32'b0;
    else begin
        if (ALUop_i == 5'b10100)  // lw or sw
            MemAddr_o <= MemAddr_i;
        else if (ALUop_i == 5'b10101)
            MemAddr_o <= MemAddr_i;
        else
            MemAddr_o <= 32'b0;
    end
end

/*
 * This always part controls the signal MemCE_o.
 */ 
always @ (*) begin
    if (rst)
        MemCE_o <= 1'b0;
    else begin
        if (ALUop_i == 5'b10100)  // lw
            MemCE_o <= 1'b1;
        else if (ALUop_i == 5'b10101)  // sw
            MemCE_o <= 1'b1;
        else
            MemCE_o <= 1'b0;
    end
end

/*
 * This always part controls the signal mem_we.
 */ 
always @ (*) begin
    if (rst)
        mem_we <= 1'b0;
    else begin
        if (ALUop_i == 5'b10100)  // lw
            mem_we <= 1'b0;
        else if (ALUop_i == 5'b10101)  // sw
            mem_we <= 1'b1;
        else
            mem_we <= 1'b0;
    end
end

endmodule
