// control decoder
module Control #(parameter opwidth = 3, mcodebits = 3)(

    input [mcodebits-1:0] instr,          // subset of machine code (any width you need)
    input [2:0] typeselect,
    output logic    RegDst, 
                    Branch,
                    MemWrite,
                    RegWrite, 
                    MemtoReg,
                    RegtoReg,
                    SinChange
    );

    logic[1:0] memselect;
    assign memselect = typeselect[1:0];

    always_comb begin
        // defaults
        RegDst = 0;         // 0: write to R0; 1: write to RA (load and shift)
        Branch = 0;         // 1: branch (absolute)
        MemWrite = 0;       // 1: store into memory
        RegWrite = 1;       // 0: for store, branching, no op  1: other operations 
        MemtoReg = 0;       // 0: ALU to reg_file; 1: memory to reg_file (load)
        RegtoReg = 0;       // 0: normal data flow; 1: moving data from reg to reg
        SinChange = 0;      // 0: non carry-in instructions 1: carry-in instructions
        
        case(instr)    // override defaults with exceptions
            3'b000: begin // rxor - reduction xor
                // same as default
            end
            3'b001: begin // shift
                case(typeselect)
                    3'b100: begin// shift left with carry in
                        SinChange = 1;
							RegDst = 1;
						  end
                    3'b101: begin // shift right with carry in
                        SinChange = 1;
							RegDst = 1;
						  end
                    default:
							RegDst = 1;
                endcase
            end
            3'b010: begin // mem - memory
                case(memselect) 
                    2'b00: begin // load from memory using address R0
                        RegDst = 1;
                        MemtoReg = 1;
                    end  
                    2'b01: begin // store into memory using address R0
                        MemWrite = 1;
                        RegWrite = 0;
                    end
                    2'b10: begin // move RA into R0
                        RegtoReg = 1;
                    end  
                    2'b11: begin // move R0 into RA
                        RegDst = 1;
                        RegtoReg = 1;
                    end
                endcase
            end
            3'b011: begin // bneq - branch not equal
                Branch = 1;
                RegWrite = 0;
            end
            3'b100: begin // halfset
                // same as default
            end
            3'b101: begin // and - bitwise AND
                // same as default
            end
            3'b110: begin // blt - branch less than
                Branch = 1;
                RegWrite = 0;
            end
            3'b111: begin // not used (no op)
                RegWrite = 0;
            end
            
            default: // no op
                RegWrite = 0;

        endcase
    end
	
endmodule