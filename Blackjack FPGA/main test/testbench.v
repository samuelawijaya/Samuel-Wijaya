`timescale 1ns / 1ps

module testbench ( );

	parameter CLOCK_PERIOD = 0.10;

        reg CLOCK_50;
        reg [3:0] KEY;
        reg [0:0] SW;
        wire [9:0] LEDR;
        wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;


	initial begin
        CLOCK_50 <= 1'b1;
        KEY[0] <= 1'b0;
        KEY[1] <= 1'b0;
        KEY[2] <= 1'b0;
        KEY[3] <= 1'b0;
        SW[0]  <= 1'b0;
	end // initial

	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) CLOCK_50 <= ~CLOCK_50;
	end
	
        
	initial begin
        #8  KEY[0] <= 1'b1; SW[0] <= 1'b1;
        
        #40 KEY[1] <= 1;
        #6  KEY[1] <= 0;

        #10 KEY[3] <= 1;
        #6  KEY[3] <= 0;

        #10 KEY[3] <= 1;
        #6  KEY[3] <= 0;

        #20 KEY[1] <= 1;
        #6  KEY[1] <= 0;

        #10 KEY[3] <= 1;
        #6  KEY[3] <= 0;

        #10 KEY[3] <= 1;
        #6  KEY[3] <= 0;

        #20 KEY[2] <= 1;
        #6  KEY[2] <= 0;

        #20 KEY[1] <= 1;
        #6  KEY[1] <= 0;

        #10 KEY[3] <= 1;
        #6  KEY[3] <= 0;

        #10 KEY[2] <= 1;
        #6  KEY[2] <= 0;

        #10 KEY[3] <= 1;
        #6  KEY[3] <= 0;

        #20 KEY[1] <= 1;
        #6  KEY[1] <= 0;

        #10 KEY[3] <= 1;
        #6  KEY[3] <= 0;

        #20 KEY[2] <= 1;
        #6  KEY[2] <= 0;

	end // initial

	main U1 (CLOCK_50, KEY, LEDR, SW,           // De1 Soc stuff
                HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

endmodule
