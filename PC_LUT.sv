module PC_LUT #(parameter D=12)(
        input       [7:0] addr,
        output logic[D-1:0] target
    );
    
    always_comb begin
        case(addr)
            0: target = 0;
	        1: target = 0;
	        2: target = 0;
            3: target = 0;
            4: target = 0;
            5: target = 0;
            6: target = 0;
            7: target = 0;
            8: target = 0;
	        9: target = 0;
	        10: target = 0;
            11: target = 0;
            12: target = 0;
            13: target = 0;
            14: target = 0;
            15: target = 0;
            16: target = 0;
	        17: target = 0;
	        18: target = 0;
            19: target = 0;
            20: target = 0;
            21: target = 0;
            22: target = 0;
            23: target = 0;
            24: target = 0;
            25: target = 0;
            26: target = 0;
            27: target = 0;
            28: target = 0;
            29: target = 0;
            30: target = 0;
            31: target = 0;
            32: target = 0;

	        default: target = 0;  
        endcase
    end

endmodule
