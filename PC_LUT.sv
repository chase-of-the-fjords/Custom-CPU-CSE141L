module PC_LUT #(parameter D=10)(
        input       [7:0] addr,
        output logic[D-1:0] target
    );
    
    always_comb begin
        case(addr)
            0: target = 7;
	        1: target = 8;
	        2: target = 285;
            3: target = 267;
            4: target = 360;
            5: target = 375;
            6: target = 390;
            7: target = 411;
            8: target = 426;
	        9: target = 441;
	        10: target = 456;
            11: target = 473;
            12: target = 488;
            13: target = 503;
            14: target = 519;
            15: target = 0;
            16: target = 35;
	        17: target = 65;
	        18: target = 102;
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
