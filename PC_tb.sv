`timescale 1ns/1ns
module PC_tb #(parameter D=12);

    logic   reset,					// synchronous reset
            clk,
            absjump_en;				// abs. jump enable
    logic[D-1:0] target;	    // how far/where to jump
    logic[D-1:0] prog_ctr;
    logic[7:0] dat0;
    
    PC #(.D(D)) pc1 (
        //inputs
        .reset,
        .clk,
        .absjump_en,
        .target,
        //outputs
        .prog_ctr);

    PC_LUT #(.D(D)) pl1 (
        .addr(dat0),
        .target); 

    initial begin
        // reset
        reset = 1;
        #10;
        assert (prog_ctr == 0) $display("reset passed");
        
        // wait 10 clock cycles
        reset = 1;
        #10;
        reset = 0;
        #100;
        assert (prog_ctr == 10) $display("10 cycles passed");

        // jump to branch 0
        reset = 1;
        #10;
        reset = 0;
        absjump_en = 1;
        dat0 = 0;
        #10;
        assert (prog_ctr == 7) $display("jump to branch 0 passed");

        // jump to branch 18
        reset = 1;
        #10;
        reset = 0;
        absjump_en = 1;
        dat0 = 18;
        #10;
        assert (prog_ctr == 101) $display("jump to branch 18 passed");

        // jump to branch 18, then wait 10 cycles
        reset = 1;
        #10;
        reset = 0;
        absjump_en = 1;
        dat0 = 18;
        #10;
        absjump_en = 0;
        #100;
        assert (prog_ctr == 111) $display("jump to branch 18 then wait passed");
    end

    always begin
        #5 clk = 1;            // tic
        #5 clk = 0;			   // toc
    end	

endmodule