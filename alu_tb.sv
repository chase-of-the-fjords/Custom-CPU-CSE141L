`timescale 1ns/1ns
module alu_tb;

    logic[2:0] alu_cmd;                  
    logic[7:0] inA, inB, rslt;
    logic[3:0] immed;
    logic[2:0] typeselect;
    logic   sc_o, sc_in,
            notequal,
            lessthan;
    
    alu alu_instance(
        // inputs
        .alu_cmd,
        .inA, 
        .inB,
        .sc_in,
        .typeselect,
        .immed,
        // outputs
        .rslt,
        .sc_o,
        .notequal,
        .lessthan
    );

    initial begin
        // reduction XOR
        alu_cmd = 3'b000;
        inA = 8'b00000001;
        #1;
        assert (rslt == 8'b00000001) $display("rxor passed");
        #10;

        inA = 8'b10101010;
        #1;
        assert (rslt == 8'b00000000) $display("rxor passed");
        #10;

        inA = 8'b10101011;
        #1;
        assert (rslt == 8'b00000001) $display("rxor passed");
        #10;
        
        // SHIFTS
        // shift left with 0
        alu_cmd = 3'b001;
        typeselect = 3'b000;
        inA = 8'b01010101;
        sc_in = 1; // should be ignored
        #1;
        assert (rslt == 8'b10101010 && sc_o == 1'b0) $display("shift left with 0 passed");
        #10;

        // shift left with 1
        alu_cmd = 3'b001;
        typeselect = 3'b001;
        inA = 8'b01010110;
        sc_in = 0; // should be ignored
        #1;
        assert (rslt == 8'b10101101 && sc_o == 1'b0) $display("shift left with 1 passed");
        #10;

        // shift right with 0
        alu_cmd = 3'b001;
        typeselect = 3'b010;
        inA = 8'b10000001;
        sc_in = 1; // should be ignored
        #1;
        assert (rslt == 8'b01000000 && sc_o == 1'b1) $display("shift right with 0 passed");
        #10;

        // shift right with 1
        alu_cmd = 3'b001;
        typeselect = 3'b011;
        inA = 8'b10010001;
        sc_in = 0; // should be ignored
        #1;
        assert (rslt == 8'b11001000 && sc_o == 1'b1) $display("shift right with 1 passed");
        #10;

        // shift left with carry in 1
        alu_cmd = 3'b001;
        typeselect = 3'b100;
        inA = 8'b01110000;
        sc_in = 1'b1;
        #1;
        assert (rslt == 8'b11100001 && sc_o == 1'b0) $display("shift left with sc_in 1 passed");
        #10;

        // shift left with carry in 0
        alu_cmd = 3'b001;
        typeselect = 3'b100;
        inA = 8'b10110011;
        sc_in = 1'b0;
        #1;
        assert (rslt == 8'b01100110 && sc_o == 1'b1) $display("shift left with sc_in 0 passed");
        #10;

        // shift right with carry in 1
        alu_cmd = 3'b001;
        typeselect = 3'b101;
        inA = 8'b01110001;
        sc_in = 1'b1;
        #1;
        assert (rslt == 8'b10111000 && sc_o == 1'b1) $display("shift left with sc_in 1 passed");
        #10;

        // shift right with carry in 0
        alu_cmd = 3'b001;
        typeselect = 3'b101;
        inA = 8'b01011011;
        sc_in = 1'b0;
        #1;
        assert (rslt == 8'b00101101 && sc_o == 1'b1) $display("shift left with sc_in 0 passed");
        #10;

        // decrement
        alu_cmd = 3'b001;
        typeselect = 3'b110;
        inA = 8'b00000001;
        #1;
        assert (rslt == 8'b00000000) $display("decrement passed");
        #10;

        typeselect = 3'b110;
        inA = 8'b00000000;
        #1;
        assert (rslt == 8'b00000000) $display("decrement passed");
            else $display("rslt = %b", rslt);
        #10; // 11111111

        typeselect = 3'b110;
        inA = 8'b11111110;
        #1;
        assert (rslt == 8'b11111101) $display("decrement passed");
            else $display("rslt = %b // wrap around", rslt);
        #10; // 11111101

        // increment
        alu_cmd = 3'b001;
        typeselect = 3'b111;
        inA = 8'b00000001;
        #1;
        assert (rslt == 8'b00000010) $display("increment passed");
        #10;

        typeselect = 3'b111;
        inA = 8'b11111111;
        #1;
        assert (rslt == 8'b00000000) $display("increment passed");
        #10;

        typeselect = 3'b111;
        inA = 8'b11111110;
        #1;
        assert (rslt == 8'b11111111) $display("increment passed");
        #10;

        // mem
        alu_cmd = 3'b010;
        #10;
        
        // bneq - branch not equal
        alu_cmd = 3'b011;
        inA = 8'b00000001;
        inB = 8'b00000010;
        #1;
        assert (notequal == 1'b1) $display("not equal passed");
        #10;

        inA = 8'b00000001;
        inB = 8'b00000001;
        #1;
        assert (notequal == 1'b0) $display("not equal passed");
        #10;

        inA = 8'b11111111;
        inB = 8'b11111110;
        #1;
        assert (notequal == 1'b1) $display("not equal passed");
        #10;
        
        // halfset
        alu_cmd = 3'b100;
        inA = 8'b00000000;
        immed = 4'b1111;
        #1;
        assert (rslt == 8'b00001111) $display("halfset passed");
        #10;

        inA = 8'b00001111;
        immed = 4'b0111;
        #1;
        assert (rslt == 8'b11110111) $display("halfset passed");
        #10;

        inA = 8'b11001111;
        immed = 4'b0001;
        #1;
        assert (rslt == 8'b11110001) $display("halfset passed");
        #10;

        // and - bitwise AND
        alu_cmd = 3'b101;
        inA = 8'b00000011;
        inB = 8'b00000010;
        #1;
        assert (rslt == 8'b00000010) $display("bitwise and passed");
        #10;

        inA = 8'b01100011;
        inB = 8'b00100010;
        #1;
        assert (rslt == 8'b00100010) $display("bitwise and passed");
        #10;

        inA = 8'b00000000;
        inB = 8'b11111010;
        #1;
        assert (rslt == 8'b00000000) $display("bitwise and passed");
        #10;

        // blt - branch less than
        alu_cmd = 3'b110;
        inA = 8'b00000011;
        inB = 8'b00000110;
        #1;
        assert (lessthan == 1'b1) $display("less than passed");
        #10;

        inA = 8'b10000011;
        inB = 8'b01111110;
        #1;
        assert (lessthan == 1'b0) $display("less than passed");
        #10;

        inA = 8'b01111111;
        inB = 8'b10000000;
        #1;
        assert (lessthan == 1'b1) $display("less than passed");
        #10;

        //no op
        alu_cmd = 3'b111;
        #10;
        
        // terminate simulation
        $finish();
    end

endmodule