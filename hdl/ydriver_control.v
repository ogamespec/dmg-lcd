module ydriver_control (  FR, S, CPL, s_int, n_fr_int, fr_int, fr_int_buffed, ck1, ck2, ck3, ck4);

	input wire FR;
	input wire S;
	input wire CPL;
	output wire s_int;
	output wire n_fr_int;
	output wire fr_int;
	output wire fr_int_buffed;
	output wire ck1;
	output wire ck2;
	output wire ck3;
	output wire ck4;

	// Wires

	wire w1;
	wire w2;
	wire s_internal;
	wire w4;
	wire w5;
	wire w6;
	wire fr_internal;
	wire cpl_internal;
	wire w9;
	wire w10;
	wire w11;
	wire w12;
	wire w13;
	wire w14;
	wire w15;
	wire w16;
	wire w17;
	wire w18;
	wire w19;
	wire w20;
	wire w21;
	wire w22;
	wire w23;
	wire w24;
	wire w25;
	wire cck;
	wire ck;
	wire w28;
	wire w29;
	wire w30;
	wire w31;
	wire w32;
	wire w33;
	wire w34;
	wire w35;
	wire w36;
	wire w37;
	wire w38;

	assign fr_internal = FR;
	assign w1 = S;
	assign cpl_internal = CPL;
	assign s_int = s_internal;
	assign n_fr_int = w6;
	assign fr_int = w5;
	assign fr_int_buffed = w9;
	assign ck1 = w10;
	assign ck2 = w11;
	assign ck3 = w19;
	assign ck4 = w21;

	// Instances

	ydriver_control_not g1 (.a(w1), .x(w2) );
	ydriver_control_not g2 (.a(w2), .x(s_internal) );
	ydriver_control_nand g3 (.b(s_internal), .a(cck), .x(w35) );
	ydriver_control_not g4 (.a(w5), .x(w6) );
	ydriver_control_not g5 (.a(w4), .x(w5) );
	ydriver_control_not g6 (.a(fr_internal), .x(w4) );
	ydriver_control_not g7 (.a(w4), .x(w9) );
	ydriver_control_nand g8 (.a(w38), .b(w35), .x(w34) );
	ydriver_control_not g9 (.a(w31), .x(w38) );
	ydriver_control_not g10 (.x(w16), .a(w17) );
	ydriver_control_super_not g11 (.a(w20), .x(w21) );
	ydriver_control_super_not g12 (.a(w18), .x(w19) );
	ydriver_control_super_not g13 (.a(w12), .x(w11) );
	ydriver_control_super_not g14 (.a(w13), .x(w10) );
	ydriver_control_buf g15 (.a(w14), .x(w13) );
	ydriver_control_buf g16 (.a(w15), .x(w12) );
	ydriver_control_nand g17 (.x(w14), .a(w15), .b(w17) );
	ydriver_control_nand g18 (.x(w15), .a(w14), .b(w16) );
	ydriver_control_buf g19 (.a(w22), .x(w18) );
	ydriver_control_buf g20 (.a(w28), .x(w20) );
	ydriver_control_nand g21 (.a(w24), .b(w23), .x(w22) );
	ydriver_control_nand g22 (.x(w24), .b(w23), .a(w22) );
	ydriver_control_not g23 (.a(w16), .x(w23) );
	ydriver_control_not g24 (.a(w36), .x(w37) );
	ydriver_control_nand g25 (.a(w35), .b(w33), .x(w32) );
	ydriver_control_not g26 (.a(cpl_internal), .x(w25) );
	ydriver_control_not g27 (.a(w25), .x(cck) );
	ydriver_control_not g28 (.a(cck), .x(ck) );
	ydriver_control_nand g29 (.x(w28), .b(w30), .a(w17) );
	ydriver_control_not g30 (.a(w17), .x(w29) );
	ydriver_control_nand g31 (.x(w30), .b(w29), .a(w28) );
	ydriver_control_mux g32 (.ck(ck), .cck(cck), .i1(w34), .i0(w32), .x(w31) );
	ydriver_control_mux_i0_inv g33 (.ck(ck), .cck(cck), .i1(w31), .i0(w32), .x(w33) );
	ydriver_control_mux_i0_i1_inv g34 (.ck(ck), .cck(cck), .x(w17), .i0(w16), .i1(w37) );
	ydriver_control_mux_i0_i1_inv g35 (.ck(ck), .cck(cck), .i0(w38), .i1(w37), .x(w36) );
endmodule // ydriver_control

// Module Definitions [It is possible to wrap here on your primitives]

module ydriver_control_not (  a, x);

	input wire a;
	output wire x;

	assign x = ~a;

endmodule // ydriver_control_not

module ydriver_control_nand (  b, a, x);

	input wire b;
	input wire a;
	output wire x;

	assign x = ~(a&b);

endmodule // ydriver_control_nand

module ydriver_control_super_not (  a, x);

	input wire a;
	output wire x;

	assign x = ~a;

endmodule // ydriver_control_super_not

module ydriver_control_buf (  a, x);

	input wire a;
	output wire x;

	assign x = a;

endmodule // ydriver_control_buf

module ydriver_control_mux (  ck, cck, i1, i0, x);

	input wire ck;
	input wire cck;
	input wire i1;
	input wire i0;
	output wire x;

	assign x = ck ? i1 : i0;

endmodule // ydriver_control_mux

module ydriver_control_mux_i0_inv (  ck, cck, i1, i0, x);

	input wire ck;
	input wire cck;
	input wire i1;
	input wire i0;
	output wire x;

	assign x = ck ? i1 : ~i0;

endmodule // ydriver_control_mux_i0_inv

module ydriver_control_mux_i0_i1_inv (  ck, cck, x, i0, i1);

	input wire ck;
	input wire cck;
	output wire x;
	input wire i0;
	input wire i1;

	assign x = ck ? ~i1 : ~i0;

endmodule // ydriver_control_mux_i0_i1_inv

