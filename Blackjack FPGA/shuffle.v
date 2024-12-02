module cardshuffle (Clock, start, resetn, shuffleOn, Address, DataIn, WriteEn, DataOut);
    input Clock, start, resetn;
    output reg [5:0] Address, DataIn;
    output reg WriteEn; // control the card deck RAM
    input [5:0] DataOut;
    output reg shuffleOn; // 1 = shuffle in progress
    reg next;

    wire [5:0] countOut;
    reg countEn, countRst;
    count6 counter0 (Clock, countRst, countEn, countOut);
    wire [5:0] randAdr;
    random6 random0 (Clock, resetn, randAdr);
    reg [2:0] step, nextstep;

    always @ (posedge Clock or negedge resetn)
        if (!resetn)
            shuffleOn <= 1'b0;
        else
            shuffleOn <= next;
    
    always @ (posedge Clock or posedge start)
        case (shuffleOn)
            0 : begin
			    step <= 0;
                countEn <= 0;
                countRst <= 0;
                if (start) next <= 1;
                else next <= 0; 
            end  

            1 :
                if (countOut > 6'd51) begin //51
                    next <= 0;
                end
                else begin
                    countRst <= 1;
                    next <= 1;
						  case (step)
						  0 : step <= 1;
						  1 : begin
							   countEn <= 1;
                               step <= nextstep;
						  end
						  2 : begin
							   countEn <= 0;
                               step <= nextstep;
						  end
						  default : step <= nextstep;
						  
						  endcase
					 end
        endcase

    reg [5:0] tempData1, tempData2, toFlipAdr;
    always @ (*) begin
        case (step)
            0 : begin
                WriteEn <= 0;
                DataIn <= 6'b111111;
                Address <= 6'b111111;
            end
			1 : nextstep <= step + 1;	
            2 : begin
                WriteEn <= 0;
                Address <= countOut;
                toFlipAdr <= randAdr;
                nextstep <= step + 1;
            end
            3 : begin
                tempData1 <= DataOut;
                nextstep <= step + 1;
            end
            4 : begin
                Address <= toFlipAdr;
                tempData2 <= DataOut;
                nextstep <= step + 1;
            end
            5 : begin
                tempData2 <= DataOut;
                nextstep <= step + 1;
            end
            6 : begin
                WriteEn <= 1;
                Address <= countOut;
                DataIn <= tempData2;
                nextstep <= step + 1;
            end
            7 : begin
                WriteEn <= 1;
                Address <= toFlipAdr;
                DataIn <= tempData1;
                nextstep <= 0;
            end
            //step 6 and 7 for testing
            // 6 : begin
            //     WriteEn <= 0;
            //     Address <= countOut;
            // end
            // 7 : begin
            //     WriteEn <= 0;
            //     Address <= toFlipAdr;
            // end
            default : begin
                WriteEn <= 0;
                DataIn <= 6'b111111;
                Address <= 6'b111111;
            end
        endcase
    end
endmodule

module random6 (Clock, ResetN, Out);
    input Clock, ResetN;
    output reg [5:0] Out;

    reg [5:0] state;

    wire feedback;
    assign feedback = state[5] ^ state[4];


    always @(posedge Clock or negedge ResetN) begin
        if (~ResetN) begin
            state <= 6'b100101; 
            Out <= 6'b100101;
        end
        else begin
            state <= {state[4:0], feedback};

            if (state > 51)
                Out <= state - 51;
            else 
                Out <= state;
        end
    end

endmodule

module count6(Clock, ResetN, CountEn, Out);
    input Clock, ResetN, CountEn;
    output reg [5:0] Out;

    always @(posedge Clock or negedge ResetN) begin
        if (~ResetN) 
            Out <= 6'd0;
        else if (CountEn) 
            Out <= Out + 1;
    end
endmodule

module count3(Clock, ResetN, CountEn, Out);
    input Clock, ResetN, CountEn;
    output reg [2:0] Out;

    always @(posedge Clock or negedge ResetN) begin
        if (~ResetN) 
            Out <= 3'd0;
        else if (CountEn) 
            Out <= Out + 1;
    end
endmodule