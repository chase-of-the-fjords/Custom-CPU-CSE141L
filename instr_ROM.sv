module instr_ROM #(parameter D=12)(
    input       [D-1:0] prog_ctr,
    output logic[8:0] mach_code);
    
    logic[8:0] core[2**D];
	 
    initial
        $readmemb("mach_code.txt", core);

    always_comb  mach_code = core[prog_ctr];

endmodule