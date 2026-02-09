`timescale 1ns/1ps

module tb_ALU_4bit_clean;

    reg  [3:0] A, B;
    reg  [2:0] op_code;
    wire [3:0] result;
    wire ZF, SF, OF;

    // DUT
    ALU_4bit dut (
        .A(A),
        .B(B),
        .op_code(op_code),
        .result(result),
        .ZF(ZF),
        .SF(SF),
        .OF(OF)
    );

    // Dump waveform
    initial begin
        $dumpfile("alu_4bit.vcd");
        $dumpvars(0, tb_ALU_4bit_clean);
    end

    // Pretty print task
    task show;
        input [8*20:1] op_name;
        begin
            $display("%-12s | A=%4d (%b) B=%4d (%b) | R=%4d (%b) | Z=%b S=%b O=%b",
                op_name,
                $signed(A), A,
                $signed(B), B,
                $signed(result), result,
                ZF, SF, OF
            );
        end
    endtask

    initial begin
        $display("\n================ ALU 4-bit FUNCTIONAL TEST ================\n");
        $display("Operation    | Operands              | Result              | Flags");
        $display("---------------------------------------------------------------");

        // ---------------- ADD ----------------
        op_code = 3'b000;
        A = 4'd3;  B = 4'd4;   #5; show("ADD");
        A = 4'd7;  B = 4'd7;   #5; show("ADD (OF)");
        A = -4;    B = -5;     #5; show("ADD");

        // ---------------- SUB ----------------
        op_code = 3'b001;
        A = 4'd6;  B = 4'd2;   #5; show("SUB");
        A = -4;    B = 4'd5;   #5; show("SUB (OF)");
        A = 4'd3;  B = 4'd3;   #5; show("SUB (ZF)");

        // ---------------- AND ----------------
        op_code = 3'b010;
        A = 4'b1100; B = 4'b1010; #5; show("AND");

        // ---------------- OR -----------------
        op_code = 3'b011;
        A = 4'b1100; B = 4'b1010; #5; show("OR");

        // -------- ARITH RIGHT SHIFT ----------
        op_code = 3'b100;
        A = -8; B = 1; #5; show("ARSH");
        A = -8; B = 2; #5; show("ARSH");

        // -------- LEFT SHIFT -----------------
        op_code = 3'b101;
        A = 4'd3; B = 2; #5; show("LSH");

        // -------- COMPARATOR -----------------
        op_code = 3'b110;
        A = 4'd5; B = 4'd3; #5; show("CMP >");
        A = 4'd2; B = 4'd7; #5; show("CMP <");
        A = 4'd4; B = 4'd4; #5; show("CMP =");

        $display("\n===================== TEST COMPLETE =====================\n");
        $finish;
    end

endmodule
