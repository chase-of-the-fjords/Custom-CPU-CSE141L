// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  input[2:0] typeselect,
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
        case(typeselect)
          3'b000: {rslt, sc_o} = {0, inA};
          3'b001: {rslt, sc_o} = {sc_i, inA};
          3'b010: {sc_o, rslt} = {inA, 0};
          3'b011: {sc_o, rslt} = {inA, sc_i};
          3'b100: rslt = inA - 1'b1;
          3'b101: rslt = inA - 1'b1;
          3'b110: rslt = inA + 1'b1;
          3'b111: rslt = inA + 1'b1;
        endcase
    3'b010: // load and store
        rslt = inA;
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