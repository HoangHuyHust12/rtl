module forwarding_unit(
    ADDR1, ADDR2, WB_ADDR, MEM_ADDR, EXE_ADDR, OP1SEL, OP2SEL, OPCODE,
    DATA1IDSEL, DATA2IDSEL, DATA1ALUSEL, DATA2ALUSEL, DATA1BJSEL, DATA2BJSEL, DATAMEMSEL
);

input [4:0] ADDR1, ADDR2, WB_ADDR, MEM_ADDR, EXE_ADDR;
input OP1SEL, OP2SEL;
input [6:0] OPCODE;
output DATA1IDSEL, DATA2IDSEL, DATAMEMSEL;
output [1:0] DATA1ALUSEL, DATA2ALUSEL, DATA1BJSEL, DATA2BJSEL;

//instruction have rs1 at ID stage
wire JALR, LOAD, STORE, I_TYPE, R_TYPE, INST_MASK;

and jalr (JALR, OPCODE[6], OPCODE[5], !OPCODE[4], !OPCODE[3], OPCODE[2], OPCODE[1], OPCODE[0]);
and load (LOAD, !OPCODE[6], !OPCODE[5], !OPCODE[4], !OPCODE[3], !OPCODE[2], OPCODE[1], OPCODE[0]);
and store (STORE, !OPCODE[6], OPCODE[5], !OPCODE[4], !OPCODE[3], !OPCODE[2], OPCODE[1], OPCODE[0]);
and i_type (I_TYPE, !OPCODE[6], !OPCODE[5], OPCODE[4], !OPCODE[3], !OPCODE[2], OPCODE[1], OPCODE[0]);
and r_type (R_TYPE, !OPCODE[6], OPCODE[5], OPCODE[4], !OPCODE[3], !OPCODE[2], OPCODE[1], OPCODE[0]);

assign INST_MASK = (JALR | LOAD | STORE | I_TYPE | R_TYPE);

// Generating DATA1_ALUSEL and DATA1_BJSEL
wire [4:0] WB_EXE_XNOR_DATA1, MEM_EXE_XNOR_DATA1;
wire WB_EXE_BJ_DATA1, MEM_EXE_BJ_DATA1, WB_EXE_ALU_DATA1, MEM_EXE_ALU_DATA1;

assign WB_EXE_XNOR_DATA1 = (MEM_ADDR ~^ ADDR1);
assign MEM_EXE_XNOR_DATA1 = (EXE_ADDR ~^ ADDR1);
assign WB_EXE_BJ_DATA1 = (WB_EXE_XNOR_DATA1[4] & WB_EXE_XNOR_DATA1[3] & WB_EXE_XNOR_DATA1[2] & WB_EXE_XNOR_DATA1[1] & WB_EXE_XNOR_DATA1[0]);
assign MEM_EXE_BJ_DATA1 = (MEM_EXE_XNOR_DATA1[4] & MEM_EXE_XNOR_DATA1[3] & MEM_EXE_XNOR_DATA1[2] & MEM_EXE_XNOR_DATA1[1] & MEM_EXE_XNOR_DATA1[0]);
assign WB_EXE_ALU_DATA1 = (WB_EXE_BJ_DATA1 & INST_MASK);
assign MEM_EXE_ALU_DATA1 = (MEM_EXE_BJ_DATA1 & INST_MASK);

assign DATA1ALUSEL[1] = (WB_EXE_ALU_DATA1 | MEM_EXE_ALU_DATA1);

assign DATA1ALUSEL[0] = ((OP1SEL & !WB_EXE_ALU_DATA1) | MEM_EXE_ALU_DATA1);

assign DATA1BJSEL[1] = (WB_EXE_BJ_DATA1 | MEM_EXE_BJ_DATA1);

assign DATA1BJSEL[0] = ((OP1SEL & !WB_EXE_BJ_DATA1) | MEM_EXE_BJ_DATA1);

// Generating DATA2_ALUSEL and DATA2_BJSEL
wire [4:0] WB_EXE_XNOR_DATA2, MEM_EXE_XNOR_DATA2;
wire WB_EXE_BJ_DATA2, MEM_EXE_BJ_DATA2, WB_EXE_ALU_DATA2, MEM_EXE_ALU_DATA2;

assign WB_EXE_XNOR_DATA2 = (MEM_ADDR ~^ ADDR2);
assign MEM_EXE_XNOR_DATA2 = (EXE_ADDR ~^ ADDR2);
assign WB_EXE_BJ_DATA2 = (WB_EXE_XNOR_DATA2[4] & WB_EXE_XNOR_DATA2[3] & WB_EXE_XNOR_DATA2[2] & WB_EXE_XNOR_DATA2[1] & WB_EXE_XNOR_DATA2[0]);
assign MEM_EXE_BJ_DATA2 = (MEM_EXE_XNOR_DATA2[4] & MEM_EXE_XNOR_DATA2[3] & MEM_EXE_XNOR_DATA2[2] & MEM_EXE_XNOR_DATA2[1] & MEM_EXE_XNOR_DATA2[0]);
assign WB_EXE_ALU_DATA2 = (WB_EXE_BJ_DATA2 & R_TYPE);
assign MEM_EXE_ALU_DATA2 = (MEM_EXE_BJ_DATA2 & R_TYPE);

assign DATA2ALUSEL[1] = (WB_EXE_ALU_DATA2 | MEM_EXE_ALU_DATA2);

assign DATA2ALUSEL[0] = ((OP2SEL & !WB_EXE_ALU_DATA2) | MEM_EXE_ALU_DATA2);

assign DATA2BJSEL[1] = (WB_EXE_BJ_DATA2 | MEM_EXE_BJ_DATA2);

assign DATA2BJSEL[0] = ((OP2SEL & !WB_EXE_BJ_DATA2) | MEM_EXE_BJ_DATA2);

// Generating DATA1_IDSEL and DATA2_IDSEL
wire [4:0] WB_ID_XNOR_DATA1, WB_ID_XNOR_DATA2;

assign WB_ID_XNOR_DATA1 = (WB_ADDR ~^ ADDR1);
assign WB_ID_XNOR_DATA2 = (WB_ADDR ~^ ADDR2);
assign DATA1IDSEL = (WB_ID_XNOR_DATA1[4] & WB_ID_XNOR_DATA1[3] & WB_ID_XNOR_DATA1[2] & WB_ID_XNOR_DATA1[1] & WB_ID_XNOR_DATA1[0]);
assign DATA2IDSEL = (WB_ID_XNOR_DATA2[4] & WB_ID_XNOR_DATA2[3] & WB_ID_XNOR_DATA2[2] & WB_ID_XNOR_DATA2[1] & WB_ID_XNOR_DATA2[0]);

// Generating DATAMEMSEL
assign DATAMEMSEL = MEM_EXE_BJ_DATA2;

endmodule