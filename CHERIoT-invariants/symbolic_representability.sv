`include "signal_macros.sv"

// This function is copied from cheri_pkg.sv; it is essentially the same mechanisms as used in the core
// for expanding compressed capability bounds in the registers and memory to full capability bounds.
// Note that top bounds use 33 bit while base bound only use 32 bit,
`ifndef CHERI_GET_BOUND
`define CHERI_GET_BOUND
function automatic logic[32:0] get_bound(logic [8:0] top, logic [1:0]  cor, logic [4:0] exp, logic [31:0] addr);
	logic [32:0] t1, t2, mask, cor_val;
	if (cor[1])
		cor_val = {33{cor[1]}};
	else
		cor_val = {32'h0, (~cor[1]) & cor[0]};
	cor_val = (cor_val << exp) << 9;
	mask    = (33'h1_ffff_ffff << exp) << 9;
	t1 = ({1'b0, addr} & mask) + cor_val;
	t2 = {24'h0, top};
	t1 = t1 | (t2 << exp);
return t1;
endfunction
`endif


// This function is a collection of terms describing representability.
// Note that the final result (return value) is a sufficiently strong invariant
// for proving all VeriCHERI property, but may be looser than the representability
// intended for CHERIoT. The function is used for all locations containing capabilities
// except for the PCC.
function automatic symbolic_repr(logic valid, logic [4:0] exp, logic [1:0] top_cor, logic [1:0] base_cor,
								 logic [8:0] top, logic [8:0] base, logic [31:0] addr);

	logic base_cor_correct;
	logic top_cor_correct;
	logic exp_correct;
    logic representable_range_correct;
    logic [32:0]   tmp33;
    logic [32-9:0] tmp24, mask24;
	logic representable_range;
	logic top_bound_le_root;
	logic [8:0] a_mid;
    logic top_gt_base;

    top_gt_base = {1'b0, get_bound(base, base_cor, exp, addr)[31:0]} <= get_bound(top, top_cor, exp, addr);

	a_mid = 9'(addr >> exp);

	if (a_mid < base)
		base_cor_correct = base_cor == 2'b11;
	else
		base_cor_correct = base_cor == 2'b00;

	if (a_mid < base && top >= base)
		top_cor_correct  = top_cor == 2'b11;
	else if (a_mid >= base && top < base)
		top_cor_correct  = top_cor == 2'b01;
	else
		top_cor_correct  = top_cor == 2'b00;

	exp_correct = (exp == 24) || (exp < 15);

    // representability check taken from set_address from cheri_pkg;
    mask24  = {(33-9){1'b1}} << exp;        // mask24 = 0 if exp == 24
    tmp33   = {1'b0, addr} - {1'b0, get_bound(base, base_cor, exp, addr)[31:0]};  // extend to make sure we can see carry from MSB
    tmp24   = tmp33[32:9] & mask24;
    
    representable_range_correct = tmp24 == 0;

	top_bound_le_root = get_bound(top, top_cor, exp, addr) <= 33'h1_0000_0000;
			
	return
		!valid ||
		top_cor_correct &&
		base_cor_correct &&
		exp_correct &&
		representable_range_correct &&
		top_bound_le_root &&
		top_gt_base;// && addr_gte_base;
endfunction


// The PCC representability function differs from other capability locations in the system
// mostly due to its expanded format and special role in the IF stage.
function automatic pcc_repr();
	logic valid_bit_low;
	logic cap_is_sealed;
	logic top_bound_le_root;
	logic top_gt_base;
	logic exp_const;
	logic top_exp_repr;
	logic base_exp_repr; 
	logic pc_within_bounds;
	logic wb_error;
	logic ctrl_fsm_flush;
	logic if_bound_vio;
	logic instr_fetch_err;
	logic fetch_valid;

	exp_const = (`PCC_EXP == 24) || (`PCC_EXP < 15);

	valid_bit_low = `PCC_VALID == 1'b0;

	top_bound_le_root = `PCC_TOP33 <= 33'h1_0000_0000;

	top_gt_base   = `PCC_TOP33 >= `PCC_BASE32;

	top_exp_repr  = ( (`PCC_TOP33 >> `PCC_EXP) << `PCC_EXP) == `PCC_TOP33;

	base_exp_repr = ( (`PCC_BASE32 >> `PCC_EXP) << `PCC_EXP) == `PCC_BASE32;

	pc_within_bounds = (`PC_IF_O <= `PCC_TOP33) && (`PC_IF_O >= `PCC_BASE32);

	wb_error = `WB_ERR;

	ctrl_fsm_flush = `CTRL_FSM == 4'b0110;
	
	if_bound_vio = `BOUND_VIO || `IF_ERR;

	instr_fetch_err = `FETCH_ERR;

	fetch_valid = `FETCH_VALID; // pc_if_o changed but is not a valid fetch

	return
		valid_bit_low ||
		top_bound_le_root &&
		exp_const &&
		top_gt_base &&
		top_exp_repr &&
		base_exp_repr && 
		(
			wb_error ||
			ctrl_fsm_flush ||
			pc_within_bounds ||
			if_bound_vio ||
			instr_fetch_err ||
			!fetch_valid
		);
endfunction


function automatic regfile_repr();
	logic result = 1'b1;
	for (int i = 1; i<32; i++)
		result = result &&
				symbolic_repr(
					`REGFILE_I_VALID,
					`REGFILE_I_EXP,
					`REGFILE_I_TOP_COR,
					`REGFILE_I_BASE_COR,
					`REGFILE_I_TOP,
					`REGFILE_I_BASE,
					`REGFILE_I_ADDR
				);
	return result;
endfunction


function automatic wb_repr();
	return symbolic_repr(
		`WB_VALID,
		`WB_EXP,
		`WB_TOP_COR,
		`WB_BASE_COR,
		`WB_TOP,
		`WB_BASE,
		`WB_ADDR
	);
endfunction


function automatic mepc_repr();
	return symbolic_repr(
		`MEPC_VALID,
		`MEPC_EXP,
		`MEPC_TOP_COR,
		`MEPC_BASE_COR,
		`MEPC_TOP,
		`MEPC_BASE,
		`MEPC_ADDR
	);
endfunction


function automatic depc_repr();
	return symbolic_repr(
		`DEPC_VALID,
		`DEPC_EXP,
		`DEPC_TOP_COR,
		`DEPC_BASE_COR,
		`DEPC_TOP,
		`DEPC_BASE,
		`DEPC_ADDR
	);
endfunction


function automatic dscratch0_repr();
	return symbolic_repr(
		`DSCRATCH0_VALID,
		`DSCRATCH0_EXP,
		`DSCRATCH0_TOP_COR,
		`DSCRATCH0_BASE_COR,
		`DSCRATCH0_TOP,
		`DSCRATCH0_BASE,
		`DSCRATCH0_ADDR
	);
endfunction


function automatic dscratch1_repr();
	return symbolic_repr(
		`DSCRATCH1_VALID,
		`DSCRATCH1_EXP,
		`DSCRATCH1_TOP_COR,
		`DSCRATCH1_BASE_COR,
		`DSCRATCH1_TOP,
		`DSCRATCH1_BASE,
		`DSCRATCH1_ADDR
	);
endfunction


function automatic mtvec_repr();
	return symbolic_repr(
		`MTVEC_VALID,
		`MTVEC_EXP,
		`MTVEC_TOP_COR,
		`MTVEC_BASE_COR,
		`MTVEC_TOP,
		`MTVEC_BASE,
		`MTVEC_ADDR
	);
endfunction


function automatic mtdc_repr();
	return symbolic_repr(
		`MTDC_VALID,
		`MTDC_EXP,
		`MTDC_TOP_COR,
		`MTDC_BASE_COR,
		`MTDC_TOP,
		`MTDC_BASE,
		`MTDC_ADDR
	);
endfunction


function automatic mscratchc_repr();
	return symbolic_repr(
		`MSCRATCHC_VALID,
		`MSCRATCHC_EXP,
		`MSCRATCHC_TOP_COR,
		`MSCRATCHC_BASE_COR,
		`MSCRATCHC_TOP,
		`MSCRATCHC_BASE,
		`MSCRATCHC_ADDR
	);
endfunction

function automatic scrs_repr();
	return
		mepc_repr()      &&
		depc_repr()      &&
		dscratch0_repr() &&
		dscratch1_repr() &&
		mtvec_repr()     &&
		mtdc_repr()      &&
		mscratchc_repr();
endfunction


// The representability invariant consists of the conjunction of the
// individual functions above. It can be proven by induction using the
// the follwoing base and step properties.

// property representability;
// 	regfile_repr() &&
// 	wb_repr()      &&
// 	scrs_repr()    &&
// 	pcc_repr();
// endproperty

// property representability_base;
// 	## 0 reset
// implies
// 	## 1 regfile_repr() &&
// 	     wb_repr()      &&
//	     scrc_repr()    &&
//	     pcc_repr();
// endproperty

// property representability_step;
// 	## 0 regfile_repr() &&
// 	     wb_repr()      &&
//	     scrc_repr()    &&
//	     pcc_repr();
// implies
// 	## 1 regfile_repr() &&
// 	     wb_repr()      &&
//	     scrc_repr()    &&
//	     pcc_repr();
// endproperty
