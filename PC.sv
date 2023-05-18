// program counter
// supports absolute jumps
module PC #(parameter D=12)(
    input   reset,					// synchronous reset
            clk,
            absjump_en,				// abs. jump enable
    input       [D-1:0] target,	    // how far/where to jump
    output logic[D-1:0] prog_ctr
);

always_ff @(posedge clk)
    if(reset)
	    prog_ctr <= 1'b0;
    else if(absjump_en)
	    prog_ctr <= target;
	else
	    prog_ctr <= prog_ctr + 1'b1;

endmodule