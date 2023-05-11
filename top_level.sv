// sample top level design
module top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 12,             // program counter width
            A = 3;             	// ALU command bit width
            R = 3;              // register bit width

  wire[D-1:0] target, 			    // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,dat0		    // from RegFile
              muxB, 
              muxRegIn,         // mux to determine reg input
              muxRegDes,
			        rslt,             // alu output
              immed,
              dmOut;            // data memory output
  logic sc_in,   				        // shift/carry out from/to ALU
   		  pariQ,                  // registered parity flag from ALU
		    zeroQ;                  // registered zero flag from ALU 
  wire  relj;                   // from control to PC; relative jump enable
  wire  absj;                   // absolute jump enable WE USE THIS ONE
  wire  pari,
        zero,
		    sc_clr,
		    sc_en,
        MemWrite,
        MemtoReg,
        RegDst,
        ALUSrc;		              // immediate switch
    
  
  wire[8:0]   mach_code;              // machine code
  wire[A-1:0] alu_cmd;                  
  wire[R-1:0]   rd_addrA, rd_adrB;    // address pointers to reg_file

  // fetch subassembly
  PC #(.D(D)) pc1 (					  // D sets program counter width
          .reset            ,
          .clk              ,
          .reljump_en (relj),
          .absjump_en (absj),
          .target           ,
          .prog_ctr         );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D)) pl1 (
          .addr  (how_high),
          .target);   

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// control decoder
  Control ctl1(
          .instr(mach_code[8:6]),
          .typeselect(mach_code[1:0]),
          .RegDst, 
          .Branch  (absj)  , 
          .MemWrite , 
          .ALUSrc   , 
          .RegWrite   ,     
          .MemtoReg,
          .ALUOp());

  
  
  
  
  assign alu_cmd  = mach_code[8:6];
  assign rd_addrA = mach_code[5:3];
  assign rd_addrB = mach_code[2:0];

  assign immed = mach_code[3:0];
  assign typeselect = mach_code[2:0];

  assign muxRegDes = RegDst ? rd_addrA : 3'b0; // 1 for load, shift

  reg_file #(.pw(3)) rf1(
              .dat_in(muxRegIn),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (muxRegDes),      // in place operation
              .datA_out(datA),
              .datB_out(datB),
              .dat0_out(dat0)); 

  alu alu1(
        .alu_cmd(),
        .inA    (datA),
        .inB    (datB),
        .sc_i   (sc),   // output from sc register
        .typeselect (typeselect),
        .immed (immed),
        .rslt       ,
        .sc_o   (sc_o), // input to sc register
        .pari  );  

  dat_mem dm1(
            .dat_in(datB)  ,  // from reg_file
            .clk           ,
            .wr_en  (MemWrite), // stores
            .addr   (dat0),     // always use R0 to hold address
            .dat_out(dmOut));

  assign muxRegIn = MemtoReg ? dmOut : rslt; // writeback mux

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr == 128;
 
endmodule