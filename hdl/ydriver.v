// HDL implementation of DMG LCD Common Driver (Y-Driver)  aka 907 aka "Smaller Chip" aka LH5076F
// Most of HDL is restored automatically by Deroute utility. Top-level HDL is made by hand.

// The analog part is not used (levels V0, V1, V4, V5, analog modules like Level Shifter, Driver Amp) but is symbolically present

module Sharp_DMG_LCD_CommonDriver_LH5076F ( V0, V1, V4, V5, FR, S, CPL, Y);

	input V0; 			// Bias voltage V0. Used as analog Power for output drivers when FR=1; Hardwired to VDD in DMG
	input V1; 			// Bias voltage V1. Used as analog Power for output drivers when FR=0
	input V4; 			// Bias voltage V4. Used as analog Ground for output drivers when FR=1
	input V5; 			// Bias voltage V5. Used as analog Ground for output drivers when FR=0
	input FR;
	input S;
	input CPL;
	output [143:0] Y; 		// The reconstructed schematic uses the designations Y1-Y144 (starting with 1)

	wire s_int;
	wire n_fr_int;
	wire fr_int;
	wire fr_int_buffed;
	wire ck1;
	wire ck2;
	wire ck3;
	wire ck4;
	wire Driver_VDD;
	wire Driver_GND;

	ydriver_control control (  
		.FR(FR), 
		.S(S), 
		.CPL(CPL), 
		.s_int(s_int), 
		.n_fr_int(n_fr_int), 
		.fr_int(fr_int), 
		.fr_int_buffed(fr_int_buffed), 
		.ck1(ck1), 
		.ck2(ck2), 
		.ck3(ck3), 
		.ck4(ck4) );

	ydriver_driver_amp amp ( 
		.V0(V0), 
		.V1(V1), 
		.V4(V4), 
		.V5(V5), 
		.FR(FR), 
		.Driver_VDD(Driver_VDD), 
		.Driver_GND(Driver_GND) );

	ydriver_lanes drivers ( 
		.Driver_GND(Driver_GND), 
		.Driver_VDD(Driver_VDD), 
		.Y(Y), 
		.fr_int_buffed(fr_int_buffed), 
		.ck1(ck1), 
		.ck2(ck2), 
		.ck3(ck3), 
		.ck4(ck4), 
		.s_int(s_int) );

endmodule // Sharp_DMG_CommonDriver_LH5076F

// Fake amp
module ydriver_driver_amp ( V0, V1, V4, V5, FR, Driver_VDD, Driver_GND );

	input V0;
	input V1;
	input V4;
	input V5;
	input FR;
	output Driver_VDD;
	output Driver_GND;

	assign Driver_VDD = FR ? V0 : V1;
	assign Driver_GND = FR ? V4 : V5;

endmodule // ydriver_driver_amp

module ydriver_lanes ( Driver_GND, Driver_VDD, Y, fr_int_buffed, ck1, ck2, ck3, ck4, s_int );

	input Driver_GND;
	input Driver_VDD;
	output [143:0] Y;
	input fr_int_buffed;
	input ck1;
	input ck2;
	input ck3;
	input ck4;
	input s_int;

	wire [143:0] sr_out;
	wire extra_mux_out;

	// mux: ck=ck2 for even bits, ck=ck1 for odd bits
	// nand3: ck4 for even, ck3 for odd bits

	//                                                                              ⚠                                                 ⚠                 ⚠                 ⚠                ⚠                         ⚠                          ⚠  
	ydriver_lane bit0   ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[  0]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(      s_int), .next_bit_out(sr_out[  1]), .this_bit_out(sr_out[  0]) );
	ydriver_lane bit1   ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[  1]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[  0]), .next_bit_out(sr_out[  2]), .this_bit_out(sr_out[  1]) );
	ydriver_lane bit2   ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[  2]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[  1]), .next_bit_out(sr_out[  3]), .this_bit_out(sr_out[  2]) );
	ydriver_lane bit3   ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[  3]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[  2]), .next_bit_out(sr_out[  4]), .this_bit_out(sr_out[  3]) );
	ydriver_lane bit4   ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[  4]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[  3]), .next_bit_out(sr_out[  5]), .this_bit_out(sr_out[  4]) );
	ydriver_lane bit5   ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[  5]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[  4]), .next_bit_out(sr_out[  6]), .this_bit_out(sr_out[  5]) );
	ydriver_lane bit6   ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[  6]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[  5]), .next_bit_out(sr_out[  7]), .this_bit_out(sr_out[  6]) );
	ydriver_lane bit7   ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[  7]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[  6]), .next_bit_out(sr_out[  8]), .this_bit_out(sr_out[  7]) );
	ydriver_lane bit8   ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[  8]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[  7]), .next_bit_out(sr_out[  9]), .this_bit_out(sr_out[  8]) );
	ydriver_lane bit9   ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[  9]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[  8]), .next_bit_out(sr_out[ 10]), .this_bit_out(sr_out[  9]) );

	ydriver_lane bit10  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 10]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[  9]), .next_bit_out(sr_out[ 11]), .this_bit_out(sr_out[ 10]) );
	ydriver_lane bit11  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 11]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 10]), .next_bit_out(sr_out[ 12]), .this_bit_out(sr_out[ 11]) );
	ydriver_lane bit12  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 12]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 11]), .next_bit_out(sr_out[ 13]), .this_bit_out(sr_out[ 12]) );
	ydriver_lane bit13  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 13]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 12]), .next_bit_out(sr_out[ 14]), .this_bit_out(sr_out[ 13]) );
	ydriver_lane bit14  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 14]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 13]), .next_bit_out(sr_out[ 15]), .this_bit_out(sr_out[ 14]) );
	ydriver_lane bit15  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 15]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 14]), .next_bit_out(sr_out[ 16]), .this_bit_out(sr_out[ 15]) );
	ydriver_lane bit16  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 16]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 15]), .next_bit_out(sr_out[ 17]), .this_bit_out(sr_out[ 16]) );
	ydriver_lane bit17  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 17]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 16]), .next_bit_out(sr_out[ 18]), .this_bit_out(sr_out[ 17]) );
	ydriver_lane bit18  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 18]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 17]), .next_bit_out(sr_out[ 19]), .this_bit_out(sr_out[ 18]) );
	ydriver_lane bit19  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 19]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 18]), .next_bit_out(sr_out[ 20]), .this_bit_out(sr_out[ 19]) );

	ydriver_lane bit20  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 20]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 19]), .next_bit_out(sr_out[ 21]), .this_bit_out(sr_out[ 20]) );
	ydriver_lane bit21  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 21]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 20]), .next_bit_out(sr_out[ 22]), .this_bit_out(sr_out[ 21]) );
	ydriver_lane bit22  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 22]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 21]), .next_bit_out(sr_out[ 23]), .this_bit_out(sr_out[ 22]) );
	ydriver_lane bit23  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 23]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 22]), .next_bit_out(sr_out[ 24]), .this_bit_out(sr_out[ 23]) );
	ydriver_lane bit24  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 24]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 23]), .next_bit_out(sr_out[ 25]), .this_bit_out(sr_out[ 24]) );
	ydriver_lane bit25  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 25]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 24]), .next_bit_out(sr_out[ 26]), .this_bit_out(sr_out[ 25]) );
	ydriver_lane bit26  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 26]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 25]), .next_bit_out(sr_out[ 27]), .this_bit_out(sr_out[ 26]) );
	ydriver_lane bit27  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 27]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 26]), .next_bit_out(sr_out[ 28]), .this_bit_out(sr_out[ 27]) );
	ydriver_lane bit28  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 28]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 27]), .next_bit_out(sr_out[ 29]), .this_bit_out(sr_out[ 28]) );
	ydriver_lane bit29  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 29]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 28]), .next_bit_out(sr_out[ 30]), .this_bit_out(sr_out[ 29]) );

	ydriver_lane bit30  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 30]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 29]), .next_bit_out(sr_out[ 31]), .this_bit_out(sr_out[ 30]) );
	ydriver_lane bit31  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 31]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 30]), .next_bit_out(sr_out[ 32]), .this_bit_out(sr_out[ 31]) );
	ydriver_lane bit32  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 32]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 31]), .next_bit_out(sr_out[ 33]), .this_bit_out(sr_out[ 32]) );
	ydriver_lane bit33  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 33]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 32]), .next_bit_out(sr_out[ 34]), .this_bit_out(sr_out[ 33]) );
	ydriver_lane bit34  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 34]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 33]), .next_bit_out(sr_out[ 35]), .this_bit_out(sr_out[ 34]) );
	ydriver_lane bit35  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 35]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 34]), .next_bit_out(sr_out[ 36]), .this_bit_out(sr_out[ 35]) );
	ydriver_lane bit36  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 36]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 35]), .next_bit_out(sr_out[ 37]), .this_bit_out(sr_out[ 36]) );
	ydriver_lane bit37  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 37]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 36]), .next_bit_out(sr_out[ 38]), .this_bit_out(sr_out[ 37]) );
	ydriver_lane bit38  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 38]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 37]), .next_bit_out(sr_out[ 39]), .this_bit_out(sr_out[ 38]) );
	ydriver_lane bit39  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 39]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 38]), .next_bit_out(sr_out[ 40]), .this_bit_out(sr_out[ 39]) );	

	ydriver_lane bit40  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 40]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 39]), .next_bit_out(sr_out[ 41]), .this_bit_out(sr_out[ 40]) );
	ydriver_lane bit41  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 41]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 40]), .next_bit_out(sr_out[ 42]), .this_bit_out(sr_out[ 41]) );
	ydriver_lane bit42  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 42]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 41]), .next_bit_out(sr_out[ 43]), .this_bit_out(sr_out[ 42]) );
	ydriver_lane bit43  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 43]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 42]), .next_bit_out(sr_out[ 44]), .this_bit_out(sr_out[ 43]) );
	ydriver_lane bit44  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 44]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 43]), .next_bit_out(sr_out[ 45]), .this_bit_out(sr_out[ 44]) );
	ydriver_lane bit45  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 45]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 44]), .next_bit_out(sr_out[ 46]), .this_bit_out(sr_out[ 45]) );
	ydriver_lane bit46  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 46]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 45]), .next_bit_out(sr_out[ 47]), .this_bit_out(sr_out[ 46]) );
	ydriver_lane bit47  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 47]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 46]), .next_bit_out(sr_out[ 48]), .this_bit_out(sr_out[ 47]) );
	ydriver_lane bit48  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 48]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 47]), .next_bit_out(sr_out[ 49]), .this_bit_out(sr_out[ 48]) );
	ydriver_lane bit49  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 49]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 48]), .next_bit_out(sr_out[ 50]), .this_bit_out(sr_out[ 49]) );

	ydriver_lane bit50  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 50]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 49]), .next_bit_out(sr_out[ 51]), .this_bit_out(sr_out[ 50]) );
	ydriver_lane bit51  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 51]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 50]), .next_bit_out(sr_out[ 52]), .this_bit_out(sr_out[ 51]) );
	ydriver_lane bit52  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 52]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 51]), .next_bit_out(sr_out[ 53]), .this_bit_out(sr_out[ 52]) );
	ydriver_lane bit53  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 53]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 52]), .next_bit_out(sr_out[ 54]), .this_bit_out(sr_out[ 53]) );
	ydriver_lane bit54  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 54]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 53]), .next_bit_out(sr_out[ 55]), .this_bit_out(sr_out[ 54]) );
	ydriver_lane bit55  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 55]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 54]), .next_bit_out(sr_out[ 56]), .this_bit_out(sr_out[ 55]) );
	ydriver_lane bit56  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 56]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 55]), .next_bit_out(sr_out[ 57]), .this_bit_out(sr_out[ 56]) );
	ydriver_lane bit57  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 57]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 56]), .next_bit_out(sr_out[ 58]), .this_bit_out(sr_out[ 57]) );
	ydriver_lane bit58  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 58]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 57]), .next_bit_out(sr_out[ 59]), .this_bit_out(sr_out[ 58]) );
	ydriver_lane bit59  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 59]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 58]), .next_bit_out(sr_out[ 60]), .this_bit_out(sr_out[ 59]) );

	ydriver_lane bit60  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 60]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 59]), .next_bit_out(sr_out[ 61]), .this_bit_out(sr_out[ 60]) );
	ydriver_lane bit61  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 61]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 60]), .next_bit_out(sr_out[ 62]), .this_bit_out(sr_out[ 61]) );
	ydriver_lane bit62  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 62]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 61]), .next_bit_out(sr_out[ 63]), .this_bit_out(sr_out[ 62]) );
	ydriver_lane bit63  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 63]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 62]), .next_bit_out(sr_out[ 64]), .this_bit_out(sr_out[ 63]) );
	ydriver_lane bit64  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 64]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 63]), .next_bit_out(sr_out[ 65]), .this_bit_out(sr_out[ 64]) );
	ydriver_lane bit65  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 65]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 64]), .next_bit_out(sr_out[ 66]), .this_bit_out(sr_out[ 65]) );
	ydriver_lane bit66  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 66]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 65]), .next_bit_out(sr_out[ 67]), .this_bit_out(sr_out[ 66]) );
	ydriver_lane bit67  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 67]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 66]), .next_bit_out(sr_out[ 68]), .this_bit_out(sr_out[ 67]) );
	ydriver_lane bit68  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 68]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 67]), .next_bit_out(sr_out[ 69]), .this_bit_out(sr_out[ 68]) );
	ydriver_lane bit69  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 69]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 68]), .next_bit_out(sr_out[ 70]), .this_bit_out(sr_out[ 69]) );

	ydriver_lane bit70  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 70]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 69]), .next_bit_out(sr_out[ 71]), .this_bit_out(sr_out[ 70]) );
	ydriver_lane bit71  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 71]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 70]), .next_bit_out(sr_out[ 72]), .this_bit_out(sr_out[ 71]) );
	ydriver_lane bit72  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 72]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 71]), .next_bit_out(sr_out[ 73]), .this_bit_out(sr_out[ 72]) );
	ydriver_lane bit73  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 73]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 72]), .next_bit_out(sr_out[ 74]), .this_bit_out(sr_out[ 73]) );
	ydriver_lane bit74  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 74]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 73]), .next_bit_out(sr_out[ 75]), .this_bit_out(sr_out[ 74]) );
	ydriver_lane bit75  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 75]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 74]), .next_bit_out(sr_out[ 76]), .this_bit_out(sr_out[ 75]) );
	ydriver_lane bit76  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 76]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 75]), .next_bit_out(sr_out[ 77]), .this_bit_out(sr_out[ 76]) );
	ydriver_lane bit77  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 77]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 76]), .next_bit_out(sr_out[ 78]), .this_bit_out(sr_out[ 77]) );
	ydriver_lane bit78  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 78]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 77]), .next_bit_out(sr_out[ 79]), .this_bit_out(sr_out[ 78]) );
	ydriver_lane bit79  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 79]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 78]), .next_bit_out(sr_out[ 80]), .this_bit_out(sr_out[ 79]) );

	ydriver_lane bit80  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 80]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 79]), .next_bit_out(sr_out[ 81]), .this_bit_out(sr_out[ 80]) );
	ydriver_lane bit81  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 81]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 80]), .next_bit_out(sr_out[ 82]), .this_bit_out(sr_out[ 81]) );
	ydriver_lane bit82  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 82]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 81]), .next_bit_out(sr_out[ 83]), .this_bit_out(sr_out[ 82]) );
	ydriver_lane bit83  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 83]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 82]), .next_bit_out(sr_out[ 84]), .this_bit_out(sr_out[ 83]) );
	ydriver_lane bit84  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 84]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 83]), .next_bit_out(sr_out[ 85]), .this_bit_out(sr_out[ 84]) );
	ydriver_lane bit85  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 85]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 84]), .next_bit_out(sr_out[ 86]), .this_bit_out(sr_out[ 85]) );
	ydriver_lane bit86  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 86]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 85]), .next_bit_out(sr_out[ 87]), .this_bit_out(sr_out[ 86]) );
	ydriver_lane bit87  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 87]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 86]), .next_bit_out(sr_out[ 88]), .this_bit_out(sr_out[ 87]) );
	ydriver_lane bit88  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 88]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 87]), .next_bit_out(sr_out[ 89]), .this_bit_out(sr_out[ 88]) );
	ydriver_lane bit89  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 89]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 88]), .next_bit_out(sr_out[ 90]), .this_bit_out(sr_out[ 89]) );

	ydriver_lane bit90  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 90]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 89]), .next_bit_out(sr_out[ 91]), .this_bit_out(sr_out[ 90]) );
	ydriver_lane bit91  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 91]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 90]), .next_bit_out(sr_out[ 92]), .this_bit_out(sr_out[ 91]) );
	ydriver_lane bit92  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 92]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 91]), .next_bit_out(sr_out[ 93]), .this_bit_out(sr_out[ 92]) );
	ydriver_lane bit93  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 93]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 92]), .next_bit_out(sr_out[ 94]), .this_bit_out(sr_out[ 93]) );
	ydriver_lane bit94  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 94]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 93]), .next_bit_out(sr_out[ 95]), .this_bit_out(sr_out[ 94]) );
	ydriver_lane bit95  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 95]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 94]), .next_bit_out(sr_out[ 96]), .this_bit_out(sr_out[ 95]) );
	ydriver_lane bit96  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 96]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 95]), .next_bit_out(sr_out[ 97]), .this_bit_out(sr_out[ 96]) );
	ydriver_lane bit97  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 97]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 96]), .next_bit_out(sr_out[ 98]), .this_bit_out(sr_out[ 97]) );
	ydriver_lane bit98  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 98]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 97]), .next_bit_out(sr_out[ 99]), .this_bit_out(sr_out[ 98]) );
	ydriver_lane bit99  ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[ 99]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[ 98]), .next_bit_out(sr_out[100]), .this_bit_out(sr_out[ 99]) );

	ydriver_lane bit100 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[100]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[ 99]), .next_bit_out(sr_out[101]), .this_bit_out(sr_out[100]) );
	ydriver_lane bit101 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[101]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[100]), .next_bit_out(sr_out[102]), .this_bit_out(sr_out[101]) );
	ydriver_lane bit102 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[102]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[101]), .next_bit_out(sr_out[103]), .this_bit_out(sr_out[102]) );
	ydriver_lane bit103 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[103]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[102]), .next_bit_out(sr_out[104]), .this_bit_out(sr_out[103]) );
	ydriver_lane bit104 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[104]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[103]), .next_bit_out(sr_out[105]), .this_bit_out(sr_out[104]) );
	ydriver_lane bit105 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[105]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[104]), .next_bit_out(sr_out[106]), .this_bit_out(sr_out[105]) );
	ydriver_lane bit106 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[106]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[105]), .next_bit_out(sr_out[107]), .this_bit_out(sr_out[106]) );
	ydriver_lane bit107 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[107]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[106]), .next_bit_out(sr_out[108]), .this_bit_out(sr_out[107]) );
	ydriver_lane bit108 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[108]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[107]), .next_bit_out(sr_out[109]), .this_bit_out(sr_out[108]) );
	ydriver_lane bit109 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[109]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[108]), .next_bit_out(sr_out[110]), .this_bit_out(sr_out[109]) );

	ydriver_lane bit110 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[110]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[109]), .next_bit_out(sr_out[111]), .this_bit_out(sr_out[110]) );
	ydriver_lane bit111 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[111]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[110]), .next_bit_out(sr_out[112]), .this_bit_out(sr_out[111]) );
	ydriver_lane bit112 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[112]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[111]), .next_bit_out(sr_out[113]), .this_bit_out(sr_out[112]) );
	ydriver_lane bit113 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[113]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[112]), .next_bit_out(sr_out[114]), .this_bit_out(sr_out[113]) );
	ydriver_lane bit114 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[114]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[113]), .next_bit_out(sr_out[115]), .this_bit_out(sr_out[114]) );
	ydriver_lane bit115 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[115]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[114]), .next_bit_out(sr_out[116]), .this_bit_out(sr_out[115]) );
	ydriver_lane bit116 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[116]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[115]), .next_bit_out(sr_out[117]), .this_bit_out(sr_out[116]) );
	ydriver_lane bit117 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[117]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[116]), .next_bit_out(sr_out[118]), .this_bit_out(sr_out[117]) );
	ydriver_lane bit118 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[118]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[117]), .next_bit_out(sr_out[119]), .this_bit_out(sr_out[118]) );
	ydriver_lane bit119 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[119]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[118]), .next_bit_out(sr_out[120]), .this_bit_out(sr_out[119]) );

	ydriver_lane bit120 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[120]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[119]), .next_bit_out(sr_out[121]), .this_bit_out(sr_out[120]) );
	ydriver_lane bit121 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[121]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[120]), .next_bit_out(sr_out[122]), .this_bit_out(sr_out[121]) );
	ydriver_lane bit122 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[122]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[121]), .next_bit_out(sr_out[123]), .this_bit_out(sr_out[122]) );
	ydriver_lane bit123 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[123]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[122]), .next_bit_out(sr_out[124]), .this_bit_out(sr_out[123]) );
	ydriver_lane bit124 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[124]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[123]), .next_bit_out(sr_out[125]), .this_bit_out(sr_out[124]) );
	ydriver_lane bit125 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[125]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[124]), .next_bit_out(sr_out[126]), .this_bit_out(sr_out[125]) );
	ydriver_lane bit126 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[126]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[125]), .next_bit_out(sr_out[127]), .this_bit_out(sr_out[126]) );
	ydriver_lane bit127 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[127]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[126]), .next_bit_out(sr_out[128]), .this_bit_out(sr_out[127]) );
	ydriver_lane bit128 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[128]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[127]), .next_bit_out(sr_out[129]), .this_bit_out(sr_out[128]) );
	ydriver_lane bit129 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[129]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[128]), .next_bit_out(sr_out[130]), .this_bit_out(sr_out[129]) );

	ydriver_lane bit130 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[130]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[129]), .next_bit_out(sr_out[131]), .this_bit_out(sr_out[130]) );
	ydriver_lane bit131 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[131]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[130]), .next_bit_out(sr_out[132]), .this_bit_out(sr_out[131]) );
	ydriver_lane bit132 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[132]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[131]), .next_bit_out(sr_out[133]), .this_bit_out(sr_out[132]) );
	ydriver_lane bit133 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[133]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[132]), .next_bit_out(sr_out[134]), .this_bit_out(sr_out[133]) );
	ydriver_lane bit134 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[134]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[133]), .next_bit_out(sr_out[135]), .this_bit_out(sr_out[134]) );
	ydriver_lane bit135 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[135]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[134]), .next_bit_out(sr_out[136]), .this_bit_out(sr_out[135]) );
	ydriver_lane bit136 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[136]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[135]), .next_bit_out(sr_out[137]), .this_bit_out(sr_out[136]) );
	ydriver_lane bit137 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[137]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[136]), .next_bit_out(sr_out[138]), .this_bit_out(sr_out[137]) );
	ydriver_lane bit138 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[138]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[137]), .next_bit_out(sr_out[139]), .this_bit_out(sr_out[138]) );
	ydriver_lane bit139 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[139]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[138]), .next_bit_out(sr_out[140]), .this_bit_out(sr_out[139]) );

	ydriver_lane bit140 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[140]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[139]), .next_bit_out(sr_out[141]), .this_bit_out(sr_out[140]) );
	ydriver_lane bit141 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[141]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[140]), .next_bit_out(sr_out[142]), .this_bit_out(sr_out[141]) );
	ydriver_lane bit142 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[142]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck2), .cck_for_mux(ck1), .ck_for_nand(ck4), .s(sr_out[141]), .next_bit_out(sr_out[143]), .this_bit_out(sr_out[142]) );
	ydriver_lane bit143 ( .Driver_GND(Driver_GND), .Driver_VDD(Driver_VDD), .Lane_out(Y[143]), .fr_int_buffed(fr_int_buffed), .ck_for_mux(ck1), .cck_for_mux(ck2), .ck_for_nand(ck3), .s(sr_out[142]), .next_bit_out(extra_mux_out), .this_bit_out(sr_out[143]) );

	// extra terminating mux (even)

	wire w17;
	ydriver_lane_not g8 (.a(w17), .x(extra_mux_out) );
	ydriver_lane_mux_i0_i1_inv g9 (.cck(ck1), .ck(ck2), .i1(sr_out[143]), .i0(extra_mux_out), .x(w17) );

endmodule // ydriver_lanes
