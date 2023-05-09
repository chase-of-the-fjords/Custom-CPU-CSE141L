// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  input[1:0] typeselect,
  input[3:0] immed,
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
			   zero      // NOR (output)
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  zero = !rslt;
  pari = ^rslt;
  case(alu_cmd)
    3'b000: // xor r1 r2
      rslt = ^inA;
	  3'b001: // left_shift
      {sc_o,rslt} = {inA, sc_i};
        case(typeselect)
          2'b00: {rslt, sc_o} = {0, inA};
          2'b01: {rslt, sc_o} = {sc_i, inA};
          2'b10: {sc_o, rslt} = {inA, 0};
          2'b11: {sc_o, rslt} = {inA, sc_i};
        endcase
    3'b010: // load and store
      
    3'b011: // bitwise XOR
	  rslt = inA ^ inB;
	3'b100: // set
	  rslt = {inA[7:4], immed}
	3'b101: // bitwise AND (mask)
	  rslt = inA & inB;
	3'b110: // subtract
	  {sc_o,rslt} = inA - inB + sc_i;
	3'b111: // pass A
	  rslt = inA;
  endcase
end
   
endmodule