module ydriver_lane (  Driver_GND, Driver_VDD, Lane_out, fr_int_buffed, ck_for_nand, cck_for_mux, s, ck_for_mux, next_bit_out, this_bit_out);

	input wire Driver_GND;
	input wire Driver_VDD;
	output wire Lane_out;
	input wire fr_int_buffed;
	input wire ck_for_nand;
	input wire cck_for_mux;
	input wire s;
	input wire ck_for_mux;
	input wire next_bit_out;
	output wire this_bit_out;

	// Wires

	wire w1;
	wire w2;
	wire w3;
	wire w4;
	wire w5;
	wire w6;
	wire w7;
	wire w8;
	wire w9;
	wire w10;
	wire w11;
	wire w12;
	wire w13;
	wire w14;
	wire w15;
	wire w16;
	wire w17;

	assign w3 = Driver_GND;
	assign w4 = Driver_VDD;
	assign Lane_out = w1;
	assign w5 = fr_int_buffed;
	assign w11 = ck_for_nand;
	assign w14 = cck_for_mux;
	assign w16 = s;
	assign w15 = ck_for_mux;
	assign w12 = next_bit_out;
	assign this_bit_out = w13;

	// Instances

	ydriver_lane_biased_super_inv g1 (.a(w9), .x(w2), .avdd(w4), .agnd(w3) );
	ydriver_lane_weird_square g2 (.a(w2), .x(w1) );
	ydriver_lane_not g3 (.a(w7), .x(w8) );
	ydriver_lane_aoi g4 (.a0(w10), .a1(w5), .b(w6), .x(w7) );
	ydriver_lane_nor g5 (.a(w5), .b(w10), .x(w6) );
	ydriver_lane_level_shifter_inv g6 (.a(w7), .na(w8), .x(w9) );
	ydriver_lane_nand3 g7 (.x(w10), .a(w12), .b(w11), .c(w13) );
	ydriver_lane_not g8 (.a(w17), .x(w13) );
	ydriver_lane_mux_i0_i1_inv g9 (.cck(w14), .ck(w15), .i1(w16), .i0(w13), .x(w17) );
endmodule // ydriver_lane

// Module Definitions [It is possible to wrap here on your primitives]

module ydriver_lane_biased_super_inv (  a, x, avdd, agnd);

	input wire a;
	output wire x;
	input wire avdd;
	input wire agnd;

	assign x = ~a;

endmodule // ydriver_lane_biased_super_inv

module ydriver_lane_weird_square (  a, x);

	input wire a;
	output wire x;

	// fake, just pass through
	assign x = a;

endmodule // ydriver_lane_weird_square

module ydriver_lane_not (  a, x);

	input wire a;
	output wire x;

	assign x = ~a;

endmodule // ydriver_lane_not

module ydriver_lane_aoi (  a0, a1, b, x);

	input wire a0;
	input wire a1;
	input wire b;
	output wire x;

	assign x = ~((a0&a1) | b);

endmodule // ydriver_lane_aoi

module ydriver_lane_nor (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

	assign x = ~(a|b);

endmodule // ydriver_lane_nor

module ydriver_lane_level_shifter_inv (  a, na, x);

	input wire a;
	input wire na;
	output wire x;

	// fake
	assign x = na;

endmodule // ydriver_lane_level_shifter_inv

module ydriver_lane_nand3 (  x, a, b, c);

	output wire x;
	input wire a;
	input wire b;
	input wire c;

	assign x = ~(a & b & c);

endmodule // ydriver_lane_nand3

module ydriver_lane_mux_i0_i1_inv (  cck, ck, i0, i1, x);

	input wire cck;
	input wire ck;
	input wire i0;
	input wire i1;
	output wire x;

	assign x = ck ? ~i1 : ~i0;

endmodule // ydriver_lane_mux_i0_i1_inv

