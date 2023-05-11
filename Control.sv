// control decoder
module Control #(parameter opwidth = 3, mcodebits = 3)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  input [2:0] typeselect,
  output logic RegDst, 
               Branch, 
               MemtoReg, 
               MemWrite, 
               ALUSrc, 
               RegWrite,
  output logic[opwidth-1:0] ALUOp);	   // for up to 8 ALU operations

  logic[1:0] memselect;
  assign memselect = typeselect[1:0];

  always_comb begin
  // defaults
    RegDst 	=   'b0;   // 0: write to r0; 1: write to register A
    Branch 	=   'b0;   // 1: branch (absolute)
    MemWrite  =	'b0;   // 1: store to memory
    ALUSrc 	=	  'b0;   // unused
    RegWrite  =	'b1;   // 0: for store, branching, no op  1: other operations 
    MemtoReg  =	'b0;   // 0: ALU to reg_file; 1: memory to reg_file
    ALUOp	    =   instr; // unused
    
    
    // sample values only -- use what you need
    case(instr)    // override defaults with exceptions
      // OUR control signals
      'b000:  begin	// rxor - reduction xor
                
              end
      'b001:  begin // shift
                
              end
      'b010:  begin // mem - memory
                case(memselect) 
                  2'b00 : begin // load from memory address in R0
                            RegDst = 'b1;
                            MemtoReg = 'b1;
                          end  
                  2'b01 : begin  // move RA to R0

                          end
                  2'b10 : begin // store into memory using address R0
                            MemWrite = 'b1;   // 1: store to memory
                          end;  
                  2'b11 : begin // move from R0 to RA
                            RegDst = 'b1;
                          end;  
                endcase
              end
      'b011:  begin // beq - branch equal

              end
      'b100:  begin // hset - half set

              end
      'b101:  begin // band - bitwise AND

              end
      'b110:  begin // blt - branch less than

              end
      'b111:  begin // not used

              end
    endcase

  end
	
endmodule