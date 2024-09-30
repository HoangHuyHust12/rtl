`include "../cpu_pipeline/cpu_pipeline.v"

module top_tracing import ibex_pkg::*; #(
  parameter bit          PMPEnable        = 1'b0,
  parameter int unsigned PMPGranularity   = 0,
  parameter int unsigned PMPNumRegions    = 4,
  parameter int unsigned MHPMCounterNum   = 0,
  parameter int unsigned MHPMCounterWidth = 40,
  parameter bit          RV32E            = 1'b0,
  parameter rv32m_e      RV32M            = RV32MFast,
  parameter rv32b_e      RV32B            = RV32BNone,
  parameter regfile_e    RegFile          = RegFileFF,
  parameter bit          BranchTargetALU  = 1'b0,
  parameter bit          WritebackStage   = 1'b0,
  parameter bit          ICache           = 1'b0,
  parameter bit          ICacheECC        = 1'b0,
  parameter bit          BranchPredictor  = 1'b0,
  parameter bit          DbgTriggerEn     = 1'b0,
  parameter int unsigned DbgHwBreakNum    = 1,
  parameter bit          SecureIbex       = 1'b0,
  parameter bit          ICacheScramble   = 1'b0,
  parameter lfsr_seed_t  RndCnstLfsrSeed  = RndCnstLfsrSeedDefault,
  parameter lfsr_perm_t  RndCnstLfsrPerm  = RndCnstLfsrPermDefault,
  parameter int unsigned DmHaltAddr       = 32'h1A110800,
  parameter int unsigned DmExceptionAddr  = 32'h1A110808
) (
input RESET,
input CLK,
input [31:0] INST_MEM_READDATA, 
input [31:0] DATA_MEM_READDATA,
output [31:0] DATA_MEM_WRITEDATA,
output [31:0] INST_MEM_ADDRESS,
output [31:0] DATA_MEM_ADDRESS,
output [3:0] READ_WRITE_EN
);
wire [31:0] rvfi_insn, rvfi_rs1_rdata, rvfi_rs2_rdata, rvfi_rs3_rdata, rvfi_rd_wdata, rvfi_pc_rdata, rvfi_pc_wdata, rvfi_mem_addr, rvfi_mem_rdata, rvfi_mem_wdata;
wire [4:0] rvfi_rs1_addr, rvfi_rs2_addr, rvfi_rs3_addr, rvfi_rd_addr;
wire [3:0] rvfi_mem_rmask, rvfi_mem_wmask;

cpu_pipeline #(
     .PMPEnable        ( PMPEnable        ),
    .PMPGranularity   ( PMPGranularity   ),
    .PMPNumRegions    ( PMPNumRegions    ),
    .MHPMCounterNum   ( MHPMCounterNum   ),
    .MHPMCounterWidth ( MHPMCounterWidth ),
    .RV32E            ( RV32E            ),
    .RV32M            ( RV32M            ),
    .RV32B            ( RV32B            ),
    .RegFile          ( RegFile          ),
    .BranchTargetALU  ( BranchTargetALU  ),
    .ICache           ( ICache           ),
    .ICacheECC        ( ICacheECC        ),
    .BranchPredictor  ( BranchPredictor  ),
    .DbgTriggerEn     ( DbgTriggerEn     ),
    .DbgHwBreakNum    ( DbgHwBreakNum    ),
    .WritebackStage   ( WritebackStage   ),
    .SecureIbex       ( SecureIbex       ),
    .ICacheScramble   ( ICacheScramble   ),
    .RndCnstLfsrSeed  ( RndCnstLfsrSeed  ),
    .RndCnstLfsrPerm  ( RndCnstLfsrPerm  ),
    .DmHaltAddr       ( DmHaltAddr       ),
    .DmExceptionAddr  ( DmExceptionAddr  )
) u_cpu_pipeline (
    .CLK(CLK),
    .RESET(RESET),
    .INST_MEM_READDATA(INST_MEM_READDATA),
    .DATA_MEM_READDATA(DATA_MEM_READDATA),
    .DATA_MEM_WRITEDATA(DATA_MEM_WRITEDATA),
    .INST_MEM_ADDRESS(INST_MEM_ADDRESS),
    .DATA_MEM_ADDRESS(DATA_MEM_ADDRESS),
    .READ_WRITE_EN(READ_WRITE_EN),
    .rvfi_valid,
    .rvfi_insn,
    .rvfi_rs1_addr,
    .rvfi_rs2_addr,
    .rvfi_rs3_addr,
    .rvfi_rs1_rdata,
    .rvfi_rs2_rdata,
    .rvfi_rs3_rdata,
    .rvfi_rd_addr,
    .rvfi_rd_wdata,
    .rvfi_pc_rdata,
    .rvfi_pc_wdata,
    .rvfi_mem_addr,
    .rvfi_mem_rmask,
    .rvfi_mem_wmask,
    .rvfi_mem_rdata,
    .rvfi_mem_wdata
  );

  tracer u_tracer (
    .clk_i(CLK),
    .rst_ni(RESET),

    .rvfi_valid,
    .rvfi_insn,
    .rvfi_rs1_addr,
    .rvfi_rs2_addr,
    .rvfi_rs3_addr,
    .rvfi_rs1_rdata,
    .rvfi_rs2_rdata,
    .rvfi_rs3_rdata,
    .rvfi_rd_addr,
    .rvfi_rd_wdata,
    .rvfi_pc_rdata,
    .rvfi_pc_wdata,
    .rvfi_mem_addr,
    .rvfi_mem_rmask,
    .rvfi_mem_wmask,
    .rvfi_mem_rdata,
    .rvfi_mem_wdata
  );

endmodule
