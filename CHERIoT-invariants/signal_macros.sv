// SIGNAL MACROS FOR BINDING PROPERTIES TO RTL SIGNALS
// adjust to fit your design
// The current signal bindings are for the CHERIoT Ibex core

`ifndef SECRET_ADDR
`define SECRET_ADDR core_top.secret_address
`endif


//Capability registers
`ifndef REGFILE_I_CAP
`define REGFILE_I_CAP core_top.core1.genblk1.register_file_i.rf_cap_q[i]
`endif
`ifndef REGFILE_I_ADDR
`define REGFILE_I_ADDR core_top.core1.genblk1.register_file_i.rf_reg_q[i]
`endif

`ifndef WB_CAP
`define WB_CAP core_top.core1.u_ibex_core.wb_stage_i.g_writeback_stage.cheri_rf_wcap_q
`endif
`ifndef WB_ADDR
`define WB_ADDR core_top.core1.u_ibex_core.wb_stage_i.g_writeback_stage.cheri_rf_wdata_q
`endif

`ifndef FULLCAP_A_CAP
`define FULLCAP_A_CAP core_top.core1.u_ibex_core.g_cheri_ex.u_cheri_ex.rf_fullcap_a
`endif

`ifndef PCC_CAP
`define PCC_CAP core_top.core1.u_ibex_core.cs_registers_i.pcc_cap_q
`endif

`ifndef MEPC_CAP
`define MEPC_CAP core_top.core1.u_ibex_core.cs_registers_i.mepc_cap
`endif
`ifndef MEPC_ADDR
`define MEPC_ADDR core_top.core1.u_ibex_core.cs_registers_i.mepc_q
`endif

`ifndef DEPC_CAP
`define DEPC_CAP core_top.core1.u_ibex_core.cs_registers_i.depc_cap
`endif
`ifndef DEPC_ADDR
`define DEPC_ADDR core_top.core1.u_ibex_core.cs_registers_i.depc_q
`endif

`ifndef DSCRATCH0_CAP
`define DSCRATCH0_CAP core_top.core1.u_ibex_core.cs_registers_i.dscratch0_cap
`endif
`ifndef DSCRATCH0_ADDR
`define DSCRATCH0_ADDR core_top.core1.u_ibex_core.cs_registers_i.dscratch0_q
`endif

`ifndef DSCRATCH1_CAP
`define DSCRATCH1_CAP core_top.core1.u_ibex_core.cs_registers_i.dscratch1_cap
`endif
`ifndef DSCRATCH1_ADDR
`define DSCRATCH1_ADDR core_top.core1.u_ibex_core.cs_registers_i.dscratch1_q
`endif

`ifndef MTVEC_CAP
`define MTVEC_CAP core_top.core1.u_ibex_core.cs_registers_i.mtvec_cap
`endif
`ifndef MTVEC_ADDR
`define MTVEC_ADDR core_top.core1.u_ibex_core.cs_registers_i.mtvec_q
`endif

`ifndef MTDC_CAP
`define MTDC_CAP core_top.core1.u_ibex_core.cs_registers_i.gen_scr.mtdc_cap
`endif
`ifndef MTDC_ADDR
`define MTDC_ADDR core_top.core1.u_ibex_core.cs_registers_i.gen_scr.mtdc_data
`endif

`ifndef MSCRATCHC_CAP
`define MSCRATCHC_CAP core_top.core1.u_ibex_core.cs_registers_i.gen_scr.mscratchc_cap
`endif
`ifndef MSCRATCHC_ADDR
`define MSCRATCHC_ADDR core_top.core1.u_ibex_core.cs_registers_i.gen_scr.mscratchc_data
`endif

// Some additional signals used for the representability invariant
`ifndef PC_IF_O
`define PC_IF_O core_top.core1.u_ibex_core.if_stage_i.pc_if_o
`endif

`ifndef WB_ERR
`define WB_ERR core_top.core1.u_ibex_core.g_cheri_ex.u_cheri_ex.cheri_wb_err_q
`endif

`ifndef CTRL_FSM
`define CTRL_FSM core_top.core1.u_ibex_core.id_stage_i.controller_i.ctrl_fsm_cs
`endif

`ifndef BOUND_VIO
`define BOUND_VIO core_top.core1.u_ibex_core.if_stage_i.cheri_bound_vio
`endif

`ifndef IF_ERR
`define IF_ERR core_top.core1.u_ibex_core.if_stage_i.if_instr_err
`endif

`ifndef FETCH_ERR
`define FETCH_ERR core_top.core1.u_ibex_core.if_stage_i.instr_fetch_err_o
`endif

`ifndef FETCH_VALID
`define FETCH_VALID core_top.core1.u_ibex_core.if_stage_i.fetch_valid
`endif


// individual capability register fields
// only adjust if capability fields diverge from CHERIoT data types

`ifndef REGFILE_I_VALID
`define REGFILE_I_VALID `REGFILE_I_CAP.valid
`endif
`ifndef REGFILE_I_EXP
`define REGFILE_I_EXP `REGFILE_I_CAP.exp
`endif
`ifndef REGFILE_I_TOP_COR
`define REGFILE_I_TOP_COR `REGFILE_I_CAP.top_cor
`endif
`ifndef REGFILE_I_BASE_COR
`define REGFILE_I_BASE_COR `REGFILE_I_CAP.base_cor
`endif
`ifndef REGFILE_I_TOP
`define REGFILE_I_TOP `REGFILE_I_CAP.top
`endif
`ifndef REGFILE_I_BASE
`define REGFILE_I_BASE `REGFILE_I_CAP.base
`endif
`ifndef REGFILE_I_CPERMS
`define REGFILE_I_CPERMS `REGFILE_I_CAP.cperms
`endif
`ifndef REGFILE_I_OTYPE
`define REGFILE_I_OTYPE `REGFILE_I_CAP.otype
`endif

`ifndef WB_VALID
`define WB_VALID `WB_CAP.valid
`endif
`ifndef WB_EXP
`define WB_EXP `WB_CAP.exp
`endif
`ifndef WB_TOP_COR
`define WB_TOP_COR `WB_CAP.top_cor
`endif
`ifndef WB_BASE_COR
`define WB_BASE_COR `WB_CAP.base_cor
`endif
`ifndef WB_TOP
`define WB_TOP `WB_CAP.top
`endif
`ifndef WB_BASE
`define WB_BASE `WB_CAP.base
`endif
`ifndef WB_CPERMS
`define WB_CPERMS `WB_CAP.cperms
`endif
`ifndef WB_OTYPE
`define WB_OTYPE `WB_CAP.otype
`endif

`ifndef MEPC_VALID
`define MEPC_VALID `MEPC_CAP.valid
`endif
`ifndef MEPC_EXP
`define MEPC_EXP `MEPC_CAP.exp
`endif
`ifndef MEPC_TOP_COR
`define MEPC_TOP_COR `MEPC_CAP.top_cor
`endif
`ifndef MEPC_BASE_COR
`define MEPC_BASE_COR `MEPC_CAP.base_cor
`endif
`ifndef MEPC_TOP
`define MEPC_TOP `MEPC_CAP.top
`endif
`ifndef MEPC_BASE
`define MEPC_BASE `MEPC_CAP.base
`endif
`ifndef MEPC_CPERMS
`define MEPC_CPERMS `MEPC_CAP.cperms
`endif
`ifndef MEPC_OTYPE
`define MEPC_OTYPE `MEPC_CAP.otype
`endif

`ifndef DEPC_VALID
`define DEPC_VALID `DEPC_CAP.valid
`endif
`ifndef DEPC_EXP
`define DEPC_EXP `DEPC_CAP.exp
`endif
`ifndef DEPC_TOP_COR
`define DEPC_TOP_COR `DEPC_CAP.top_cor
`endif
`ifndef DEPC_BASE_COR
`define DEPC_BASE_COR `DEPC_CAP.base_cor
`endif
`ifndef DEPC_TOP
`define DEPC_TOP `DEPC_CAP.top
`endif
`ifndef DEPC_BASE
`define DEPC_BASE `DEPC_CAP.base
`endif
`ifndef DEPC_CPERMS
`define DEPC_CPERMS `DEPC_CAP.cperms
`endif
`ifndef DEPC_OTYPE
`define DEPC_OTYPE `DEPC_CAP.otype
`endif

`ifndef DSCRATCH0_VALID
`define DSCRATCH0_VALID `DSCRATCH0_CAP.valid
`endif
`ifndef DSCRATCH0_EXP
`define DSCRATCH0_EXP `DSCRATCH0_CAP.exp
`endif
`ifndef DSCRATCH0_TOP_COR
`define DSCRATCH0_TOP_COR `DSCRATCH0_CAP.top_cor
`endif
`ifndef DSCRATCH0_BASE_COR
`define DSCRATCH0_BASE_COR `DSCRATCH0_CAP.base_cor
`endif
`ifndef DSCRATCH0_TOP
`define DSCRATCH0_TOP `DSCRATCH0_CAP.top
`endif
`ifndef DSCRATCH0_BASE
`define DSCRATCH0_BASE `DSCRATCH0_CAP.base
`endif
`ifndef DSCRATCH0_CPERMS
`define DSCRATCH0_CPERMS `DSCRATCH0_CAP.cperms
`endif
`ifndef DSCRATCH0_OTYPE
`define DSCRATCH0_OTYPE `DSCRATCH0_CAP.otype
`endif

`ifndef DSCRATCH1_VALID
`define DSCRATCH1_VALID `DSCRATCH1_CAP.valid
`endif
`ifndef DSCRATCH1_EXP
`define DSCRATCH1_EXP `DSCRATCH1_CAP.exp
`endif
`ifndef DSCRATCH1_TOP_COR
`define DSCRATCH1_TOP_COR `DSCRATCH1_CAP.top_cor
`endif
`ifndef DSCRATCH1_BASE_COR
`define DSCRATCH1_BASE_COR `DSCRATCH1_CAP.base_cor
`endif
`ifndef DSCRATCH1_TOP
`define DSCRATCH1_TOP `DSCRATCH1_CAP.top
`endif
`ifndef DSCRATCH1_BASE
`define DSCRATCH1_BASE `DSCRATCH1_CAP.base
`endif
`ifndef DSCRATCH1_CPERMS
`define DSCRATCH1_CPERMS `DSCRATCH1_CAP.cperms
`endif
`ifndef DSCRATCH1_OTYPE
`define DSCRATCH1_OTYPE `DSCRATCH1_CAP.otype
`endif

`ifndef MTVEC_VALID
`define MTVEC_VALID `MTVEC_CAP.valid
`endif
`ifndef MTVEC_EXP
`define MTVEC_EXP `MTVEC_CAP.exp
`endif
`ifndef MTVEC_TOP_COR
`define MTVEC_TOP_COR `MTVEC_CAP.top_cor
`endif
`ifndef MTVEC_BASE_COR
`define MTVEC_BASE_COR `MTVEC_CAP.base_cor
`endif
`ifndef MTVEC_TOP
`define MTVEC_TOP `MTVEC_CAP.top
`endif
`ifndef MTVEC_BASE
`define MTVEC_BASE `MTVEC_CAP.base
`endif
`ifndef MTVEC_CPERMS
`define MTVEC_CPERMS `MTVEC_CAP.cperms
`endif
`ifndef MTVEC_OTYPE
`define MTVEC_OTYPE `MTVEC_CAP.otype
`endif

`ifndef MTDC_VALID
`define MTDC_VALID `MTDC_CAP.valid
`endif
`ifndef MTDC_EXP
`define MTDC_EXP `MTDC_CAP.exp
`endif
`ifndef MTDC_TOP_COR
`define MTDC_TOP_COR `MTDC_CAP.top_cor
`endif
`ifndef MTDC_BASE_COR
`define MTDC_BASE_COR `MTDC_CAP.base_cor
`endif
`ifndef MTDC_TOP
`define MTDC_TOP `MTDC_CAP.top
`endif
`ifndef MTDC_BASE
`define MTDC_BASE `MTDC_CAP.base
`endif
`ifndef MTDC_CPERMS
`define MTDC_CPERMS `MTDC_CAP.cperms
`endif
`ifndef MTDC_OTYPE
`define MTDC_OTYPE `MTDC_CAP.otype
`endif

`ifndef MSCRATCHC_VALID
`define MSCRATCHC_VALID `MSCRATCHC_CAP.valid
`endif
`ifndef MSCRATCHC_EXP
`define MSCRATCHC_EXP `MSCRATCHC_CAP.exp
`endif
`ifndef MSCRATCHC_TOP_COR
`define MSCRATCHC_TOP_COR `MSCRATCHC_CAP.top_cor
`endif
`ifndef MSCRATCHC_BASE_COR
`define MSCRATCHC_BASE_COR `MSCRATCHC_CAP.base_cor
`endif
`ifndef MSCRATCHC_TOP
`define MSCRATCHC_TOP `MSCRATCHC_CAP.top
`endif
`ifndef MSCRATCHC_BASE
`define MSCRATCHC_BASE `MSCRATCHC_CAP.base
`endif
`ifndef MSCRATCHC_CPERMS
`define MSCRATCHC_CPERMS `MSCRATCHC_CAP.cperms
`endif
`ifndef MSCRATCHC_OTYPE
`define MSCRATCHC_OTYPE `MSCRATCHC_CAP.otype
`endif

`ifndef PCC_VALID
`define PCC_VALID `PCC_CAP.valid
`endif
`ifndef PCC_EXP
`define PCC_EXP `PCC_CAP.exp
`endif
`ifndef PCC_TOP33
`define PCC_TOP33 `PCC_CAP.top33
`endif
`ifndef PCC_BASE32
`define PCC_BASE32 `PCC_CAP.base32
`endif
`ifndef PCC_CPERMS
`define PCC_CPERMS `PCC_CAP.cperms
`endif
`ifndef PCC_OTYPE
`define PCC_OTYPE `PCC_CAP.otype
`endif


`ifndef FULLCAP_A_TOP33
`define FULLCAP_A_TOP33 `FULLCAP_A_CAP.top33
`endif
`ifndef FULLCAP_A_BASE32
`define FULLCAP_A_BASE32 `FULLCAP_A_CAP.base32
`endif
`ifndef FULLCAP_A_OTYPE
`define FULLCAP_A_OTYPE `FULLCAP_A_CAP.otype
`endif
