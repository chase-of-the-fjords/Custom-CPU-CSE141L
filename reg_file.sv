// cache memory/register file
// default address pointer width = 3, for 8 registers
module reg_file #(parameter pw=3)(
    input[7:0] dat_in,
    input   clk,
    input   wr_en,                  // write enable
    input[pw-1:0]   wr_addr,		    // write address pointer
                    rd_addrA,		    // read address pointers
                    rd_addrB,
    output logic[7:0]   datA_out,   // read data
                        datB_out,
                        dat0_out
    );

    logic[7:0] core[2**pw];         // 2-dim array  8 wide  16 deep

    initial begin
        core[0] = 8'b00000000;
        core[1] = 8'b00000000;
        core[2] = 8'b00000000;
        core[3] = 8'b00000000;
        core[4] = 8'b00000000;
        core[5] = 8'b00000000;
        core[6] = 8'b00000000;
        core[7] = 8'b00000000;
    end

    // reads are combinational
    assign datA_out = core[rd_addrA];
    assign datB_out = core[rd_addrB];
    assign dat0_out = core[0];

    // writes are sequential (clocked)
    always @(posedge clk) begin
        if(wr_en) begin				   // anything but stores or no ops
            core[wr_addr] <= dat_in;
            $display("writing %d into register %d",dat_in,wr_addr);
        end
    end 

endmodule

/*
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
*/