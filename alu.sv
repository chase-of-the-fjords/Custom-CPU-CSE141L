// ALU
module alu(
    input[2:0] alu_cmd,         // ALU instructions
    input[7:0] inA, inB,	    // 8-bit wide data path
    input      sc_in,           // shift_carry in
    input[2:0] typeselect,
    input[3:0] immed,
    
    output logic[7:0] rslt,
    output logic    sc_o,       // shift_carry out
                    notequal,   // branch flags
                    lessthan
    );

    always_comb begin
        // default values
        rslt = 8'b0;            
        sc_o = 1'b0;    
        notequal = 1'b0;
        lessthan = 1'b0

        case(alu_cmd)
            3'b000: begin // xor
                rslt = ^inA; // EDIT
            end
            3'b001: begin // shift
                case(typeselect)
                    3'b000: // shift left with 0
                        {sc_o, rslt} = {inA, 0};
                    3'b001: // shift left with 1
                        {sc_o, rslt} = {inA, 1};
                    3'b010: // shift right with 0
                        {rslt, sc_o} = {0, inA};
                    3'b011: // shift right with 1 
                        {rslt, sc_o} = {1, inA};
                    3'b100: // shift left with carry in
                        {sc_o, rslt} = {inA, sc_i};
                    3'b101: // shift right with carry in
                        {rslt, sc_o} = {sc_i, inA};
                    3'b110: // decrement
                        rslt = inA - 1'b1;
                    3'b111: // increment
                        rslt = inA + 1'b1;
                endcase
            end
            3'b010: begin // mem - memory
                // same as default
            end
            3'b011: begin // bneq - branch not equal
                if (inA !== inB)
                    notequal = 1;
            end
            3'b100: begin // halfset
                rslt = {inA[3:0], immed};
            end
            3'b101: begin // and - bitwise AND
                rslt = inA & inB;
            end
            3'b110: begin // blt - branch less than
                if (inA < inB)
                    lessthan = 1;
            end
            3'b111: begin // not used (no op)
                // same as default
            end

            default: // no op

        endcase
    end
   
endmodule