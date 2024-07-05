`include "signal_macros.sv"

// This function is copied from cheri_pkg.sv; it is essentially the same mechanisms as used in the core
// for expanding compressed capability bounds in the registers and memory to full capability bounds.
// Note that top bounds use 33 bit while base bound only use 32 bit,
`ifndef CHERI_GET_BOUND
`define CHERI_GET_BOUND 
function automatic logic[32:0] get_bound(logic [8:0] top, logic [1:0] cor, logic [4:0] exp,logic [31:0] addr);
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


function automatic cheri_reg_protected (logic valid, logic [4:0] exp, logic [1:0] top_cor, logic [1:0] base_cor,
	                                    logic [8:0] top, logic [8:0] base, logic [5:0] cperms, logic [2:0] otype,
										logic [31:0] addr );
	logic [32:0] top_bound;
	logic [31:0] base_bound;

	logic secret_gt_top;
	logic secret_lt_base;
	logic secret_outside_bounds;
	logic top_le_root;
	logic cap_sealed;
	logic no_unseal_permission;
	logic valid_bit_low;

	top_bound  = get_bound(top, top_cor, exp, addr);
	base_bound = get_bound(base, base_cor, exp, addr)[31:0];

	valid_bit_low = valid == 1'b0;

	secret_gt_top  = `SECRET_ADDR > top_bound;
	secret_lt_base = `SECRET_ADDR < base_bound;
	secret_outside_bounds = secret_gt_top || secret_lt_base;

	top_le_root    = top_bound <= 33'h1_0000_0000;

	cap_sealed = otype != 3'd0; // cheri_pkg::OTYPE_UNSEALED;

	no_unseal_permission = !((cperms[4:3] == 2'b00) && (cperms[0] == 1'b1));

	return
		valid_bit_low  ||
		cap_sealed     ||
		secret_outside_bounds &&
		top_le_root    &&
		no_unseal_permission;

endfunction


function automatic mepc_protected();
	return
		cheri_reg_protected(
			`MEPC_VALID,
			`MEPC_EXP,
			`MEPC_TOP_COR,
			`MEPC_BASE_COR,
			`MEPC_TOP,
			`MEPC_BASE,
			`MEPC_CPERMS,
			`MEPC_OTYPE,
			`MEPC_ADDR
		);
endfunction


function automatic depc_protected();
	return
		cheri_reg_protected(
			`DEPC_VALID,
			`DEPC_EXP,
			`DEPC_TOP_COR,
			`DEPC_BASE_COR,
			`DEPC_TOP,
			`DEPC_BASE,
			`DEPC_CPERMS,
			`DEPC_OTYPE,
			`DEPC_ADDR
		);
endfunction


function automatic dscratch0_protected();
	return
		cheri_reg_protected(
			`DSCRATCH0_VALID,
			`DSCRATCH0_EXP,
			`DSCRATCH0_TOP_COR,
			`DSCRATCH0_BASE_COR,
			`DSCRATCH0_TOP,
			`DSCRATCH0_BASE,
			`DSCRATCH0_CPERMS,
			`DSCRATCH0_OTYPE,
			`DSCRATCH0_ADDR
		);
endfunction


function automatic dscratch1_protected();
	return
		cheri_reg_protected(
			`DSCRATCH1_VALID,
			`DSCRATCH1_EXP,
			`DSCRATCH1_TOP_COR,
			`DSCRATCH1_BASE_COR,
			`DSCRATCH1_TOP,
			`DSCRATCH1_BASE,
			`DSCRATCH1_CPERMS,
			`DSCRATCH1_OTYPE,
			`DSCRATCH1_ADDR
		);
endfunction


function automatic mtvec_protected();
	return
		cheri_reg_protected(
			`MTVEC_VALID,
			`MTVEC_EXP,
			`MTVEC_TOP_COR,
			`MTVEC_BASE_COR,
			`MTVEC_TOP,
			`MTVEC_BASE,
			`MTVEC_CPERMS,
			`MTVEC_OTYPE,
			`MTVEC_ADDR
		);	
endfunction


function automatic mtdc_protected();
	return
		cheri_reg_protected(
			`MTDC_VALID,
			`MTDC_EXP,
			`MTDC_TOP_COR,
			`MTDC_BASE_COR,
			`MTDC_TOP,
			`MTDC_BASE,
			`MTDC_CPERMS,
			`MTDC_OTYPE,
			`MTDC_ADDR
		);
endfunction


function automatic mscratchc_protected();
	return
		cheri_reg_protected(
			`MSCRATCHC_VALID,
			`MSCRATCHC_EXP,
			`MSCRATCHC_TOP_COR,
			`MSCRATCHC_BASE_COR,
			`MSCRATCHC_TOP,
			`MSCRATCHC_BASE,
			`MSCRATCHC_CPERMS,
			`MSCRATCHC_OTYPE,
			`MSCRATCHC_ADDR
		);
endfunction


function automatic scrs_protected();
	return
		mepc_protected()      &&
		depc_protected()      &&
		dscratch0_protected() &&
		dscratch1_protected() &&
		mtvec_protected()     &&
		mtdc_protected()      &&
		mscratchc_protected();
endfunction


function automatic regfile_protected();
	logic result = 1'b1;
	for (int i = 1; i<32; i++) begin
		result = result &&
		cheri_reg_protected(
			`REGFILE_I_VALID,
			`REGFILE_I_EXP,
			`REGFILE_I_TOP_COR,
			`REGFILE_I_BASE_COR,
			`REGFILE_I_TOP,
			`REGFILE_I_BASE,
			`REGFILE_I_CPERMS,
			`REGFILE_I_OTYPE,
			`REGFILE_I_ADDR
		);
	end
	return result;
endfunction


function automatic wb_protected();
	return
		cheri_reg_protected(
			`WB_VALID,
			`WB_EXP,
			`WB_TOP_COR,
			`WB_BASE_COR,
			`WB_TOP,
			`WB_BASE,
			`WB_CPERMS,
			`WB_OTYPE,
			`WB_ADDR
		);
endfunction


// The PCC has its own monotonicity function due to its different format.
// It overlaps somewhat with the representability invariant.
function automatic pcc_protected();
	logic secret_outside_bounds;
	logic valid_bit_low;
	logic cap_is_sealed;
	logic top_bound_smaller_root;
	logic top_gt_base;
	logic exp_const;
	logic top_exp_repr; // ensures that pcc exp does not shift out bound bits on conversion to full cap
	logic base_exp_repr; 
	logic no_unseal_permissions;

	exp_const = `PCC_EXP <= 24;

	valid_bit_low = `PCC_VALID == 1'b0;

	cap_is_sealed = `PCC_OTYPE != 3'd0;  // cheri_pkg::OTYPE_UNSEALED;

	secret_outside_bounds =	
		`PCC_TOP33  < `SECRET_ADDR ||
		`PCC_BASE32 > `SECRET_ADDR;

	top_bound_smaller_root = `PCC_TOP33 <= 33'h1_0000_0000;

	top_gt_base   = `PCC_TOP33 >= `PCC_BASE32;

	top_exp_repr  = ( (`PCC_TOP33 >> `PCC_EXP) << `PCC_EXP) == `PCC_TOP33;

	base_exp_repr = ( (`PCC_BASE32 >> `PCC_EXP) << `PCC_EXP) == `PCC_BASE32;

	no_unseal_permissions = !((`PCC_CPERMS[4:3] == 2'b00) && (`PCC_CPERMS[0] == 1'b1));

	return 
		valid_bit_low || 
		cap_is_sealed || 
		secret_outside_bounds  &&
		top_bound_smaller_root &&
		exp_const              &&
		top_gt_base            &&
		top_exp_repr           &&
		base_exp_repr          &&
		no_unseal_permissions;

endfunction


// This function is used to describe the case whhere monotonicity ends:
// the case of a compartment switch. This is reflected in the consequent
// of the implication that forms monotonicity step property.
// FULLCAP_A is an input operand of the cheri execution stage.
function automatic compartment_switch();
return (
	(
		$past(`FULLCAP_A_OTYPE) == 3'd1 ||  // cheri_pkg::OTYPE_SENTRY
		$past(`FULLCAP_A_OTYPE) == 3'd2 ||  // cheri_pkg::OTYPE_SENTRY_ID
		$past(`FULLCAP_A_OTYPE) == 3'd3     // cheri_pkg::OTYPE_SENTRY_IE
	) &&
		($past(`FULLCAP_A_TOP33)  == `PCC_TOP33) &&
		($past(`FULLCAP_A_BASE32) == `PCC_BASE32)
	);
endfunction


// The monotonicity invariant is not globally valid, but only during the
// execution of a task tasks. The individual functions above are directly
// assumed in the VeriCHERI properties at the beginning of the time window.
// For proving monotonicity, we provide an induction step property.
// The induction base is implicitely computed by reachability of the
// VeriCHERI one safety properties.

// property monotonicity_step;
// 	## 0 regfile_protected() &&
// 	     wb_protected()      &&
//	     scrc_protected()    &&
//	     pcc_protected();
// implies
// 	## 1 regfile_protected() &&
// 	     wb_protected()      &&
//	     scrc_protected()    &&
//	     pcc_protected() || compartment_switch();
// endproperty