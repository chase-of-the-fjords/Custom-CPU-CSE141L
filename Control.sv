// control decoder
module Control #(parameter opwidth = 3, mcodebits = 3)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  input [1:0] typeselect,
  output logic RegDst, Branch, 
     MemtoReg, MemWrite, ALUSrc, RegWrite,
  output logic[opwidth-1:0] ALUOp);	   // for up to 8 ALU operations

always_comb begin
// defaults
  RegDst 	=   'b0;   // 1: not in place  just leave 0
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	=	'b0;   // 1: immediate  0: second reg file output
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  ALUOp	    =   instr; // y = a+0;
// sample values only -- use what you need
case(instr)    // override defaults with exceptions
  'b000:  begin					// store operation
            MemWrite = 'b1;      // write to data mem
            RegWrite = 'b0;      // typically don't also load reg_file
          end
  'b001:  ALUOp      = 'b000;  // add:  y = a+b
  'b010:  begin				  // load
            MemtoReg = 'b1;    // 
          end
  'b011:  begin

          end
// ...
endcase

end
	
endmodule