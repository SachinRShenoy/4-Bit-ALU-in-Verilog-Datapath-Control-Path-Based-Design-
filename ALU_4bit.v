`timescale 1ns/1ps

/*
000 - add
001 - sub
010 - AND
011 - OR
100 - RightShift
101 - Leftshift
110 - Comparator
111 - 
*/

module ALU_4bit(input [3:0]A,B,input [2:0] op_code, output [3:0] result,output ZF,SF,OF);
	wire [2:0] alu_ctr;
  wire [3:0] addsum,subdif,andout,orout,rshiftt,lshiftt,compp;
  wire OF_add,OF_sub;
	alu_ctrl A1(.op_code(op_code),.alu_ctr(alu_ctr));
	alu_data A2(.A(A),.B(B),.addsum(addsum),.subdif(subdif),.andout(andout),.orout(orout),.rshiftt(rshiftt),.lshiftt(lshiftt),.compp(compp),.OF_add(OF_add),.OF_sub(OF_sub));
	alu_mux A3(.addsum(addsum),.subdif(subdif),.andout(andout),.orout(orout),.rshiftt(rshiftt),.lshiftt(lshiftt),.compp(compp),.alu_ctr(alu_ctr),.OF_add(OF_add),.OF_sub(OF_sub),.result(result),.ZF(ZF),.SF(SF),.OF(OF));
endmodule

module alu_ctrl(input [2:0]op_code, output reg [2:0]alu_ctr);
	always@(*)
	begin
		alu_ctr=3'b000;
		case(op_code)
			3'b000: alu_ctr=3'b000;//add
			3'b001: alu_ctr=3'b001;//sub
			3'b010: alu_ctr=3'b010;//AND
			3'b011: alu_ctr=3'b011;//OR
			3'b100: alu_ctr=3'b100;//RS
			3'b101: alu_ctr=3'b101;//LS
			3'b110: alu_ctr=3'b110;
			default: alu_ctr=3'b000;
		endcase
	end
endmodule 

module alu_data(input [3:0]A,B,output [3:0]addsum,subdif,andout,orout,rshiftt,lshiftt,compp,output OF_add,OF_sub);
	
	assign addsum  = A + B;
	assign subdif  = A - B;
	assign andout  = A & B;
	assign orout   = A | B;
	assign rshiftt = $signed(A)>>>B;
	assign lshiftt = A<<<B;
	assign compp=(A>B)?4'b0100:(A<B)?4'b0010:(A==B)?4'b0001:4'b0000;
	assign OF_add = (~(A[3] ^ B[3])) & (A[3] ^ addsum[3]);
	assign OF_sub = (A[3] ^ B[3]) & (A[3] ^ subdif[3]);

endmodule

module alu_mux(input[3:0]addsum,subdif,andout,orout,rshiftt,lshiftt,compp, input [2:0] alu_ctr,input OF_add,OF_sub,output reg [3:0] result,output ZF,SF,OF);
	always@(*)
	begin
		case(alu_ctr)
			3'b000: result=addsum;
			3'b001: result=subdif;
			3'b010: result=andout;
			3'b011: result=orout;
			3'b100: result=rshiftt;
			3'b101: result=lshiftt;
			3'b110: result=compp;
			default: result=4'b0;
		endcase
	end
	assign ZF=(result==4'b0);
	assign SF=result[3];
	assign OF=(alu_ctr==3'b000)?OF_add:(alu_ctr==3'b001)?OF_sub:1'b0;
endmodule
