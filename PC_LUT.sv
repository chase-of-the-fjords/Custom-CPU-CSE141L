module PC_LUT #(parameter D=12)(
        input       [7:0] addr,
        output logic[D-1:0] target
    );
    
    always_comb begin
        case(addr)
            0: target = 7;
	        1: target = 6;
	        2: target = 503;
            3: target = 328;
            4: target = 298;
            5: target = 315;
            6: target = 282;
            7: target = 266;
            8: target = 247;
	        9: target = 231;
	        10: target = 215;
            11: target = 199;
            12: target = 177;
            13: target = 161;
            14: target = 145;
            15: target = 0;
            16: target = 35;
	        17: target = 65;
	        18: target = 101;
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
