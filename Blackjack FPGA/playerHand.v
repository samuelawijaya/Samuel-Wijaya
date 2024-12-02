module playerHand(clk, reset, deal, hit, FSMState, dealOn, getCard, cardIn, handVal);
    input clk, reset, deal, hit;
    input [2:0] FSMState;           //only allow taking cards during players turn (3'b011)
    output reg dealOn, getCard;
    input [5:0] cardIn;             // 6-bit input representing a new card
    output reg [4:0] handVal;       // 5-bit output for the total value of the hand

    wire [3:0] card_real = cardIn[3:0]; // Takes first 4 bits

    // Variables
    reg [3:0] card_value;         // Stores the value of the incoming card
    reg [4:0] sum;                // Accumulated sum of card values
    reg [1:0] ace_count, new_ace; // Keeps track of the number of Aces in the hand
    reg [12:0] step, nextstep;
    reg refresh;
    // Determine the value of the card based on Blackjack rules
    always @(*) begin
        case (card_real)
            4'b0001: card_value = 11; // Ace
            4'b0010: card_value = 2;  // 2
            4'b0011: card_value = 3;  // 3
            4'b0100: card_value = 4;  // 4
            4'b0101: card_value = 5;  // 5
            4'b0110: card_value = 6;  // 6
            4'b0111: card_value = 7;  // 7
            4'b1000: card_value = 8;  // 8
            4'b1001: card_value = 9;  // 9
            4'b1010: card_value = 10; // 10
            4'b1011: card_value = 10; // Jack
            4'b1100: card_value = 10; // Queen
            4'b1101: card_value = 10; // King
            default: card_value = 0;
        endcase
    end
	 
	//  always @ (cardIn) begin
	// 	if (FSMState == 3'b011 || FSMState == 3'b010)
	// 	sum <= handVal + card_value;
	// 	end

    always @(posedge clk or posedge refresh) begin
        if (refresh) begin
            handVal <= 0;
//            sum <= 0; // temp
            step <= 0;
            ace_count <= 0;
        end
        else begin
            step <= nextstep;
//            if (sum > 21 && ace_count > 0) begin
//                handVal <= sum - 10;
//                ace_count <= new_ace - 1;
//            end else begin
            handVal <= sum;
            ace_count <= new_ace;
            
        end
    end

    always @ (*) begin
        if (FSMState == 3'b001 || FSMState == 3'b000) begin
            refresh <= 1;
            sum <= 0;
        end
        else
            refresh <= 0;
            
        if (FSMState == 3'b011) begin // during player's turn
            if (hit) begin
                nextstep <= 1;
                sum <= handVal;
            end
            case (step)
                1: begin
                    getCard <= 1;
                    nextstep <= step + 1;
                end
                2: begin
                    getCard <= 0;
                    nextstep <= step + 1;
                    sum <= handVal;
                end
                3 : begin
					getCard <= 0;
                    sum <= handVal + card_value;
                    nextstep <= 0;
                    if (card_real == 4'b0001)  // If the card is an Ace, increase the ace_count
                        new_ace <= ace_count + 1;
                end
                default: begin
                    getCard <= 0;
                end
            endcase
        end
        else if (FSMState == 3'b010) begin // during deal phase
            if (deal) begin
                nextstep <= 1;
                dealOn <= 1;
                sum <= handVal;
            end
            if (step == 1) begin
                getCard <= 1;
                nextstep <= step + 1;
                dealOn <= 1;
            end
            else if (step == 2) begin
                getCard <= 0;
                nextstep <= step + 1;
            end
				else if (step == 3) begin
                getCard <= 0;
                nextstep <= step + 1;
                sum <= handVal;
            end
            else if (step == 4) begin
                getCard <= 0;
                sum <= handVal + card_value;
                nextstep <= step + 1;
                if (card_real == 4'b0001)  // If the card is an Ace, increase the ace_count
                    new_ace <= ace_count + 1;
            end
            else if (step > 4 && step < 2228) begin
                getCard <= 0;
                nextstep <= step + 1;
            end
            else if (step == 2228) begin
                getCard <= 1;
                nextstep <= step + 1;
            end
            else if (step == 2229) begin
                getCard <= 0;
                nextstep <= step + 1;
            end
				else if (step == 2230) begin
                getCard <= 0;
                nextstep <= step + 1;
            end
            else if (step == 2231) begin
                sum <= handVal + card_value;
                nextstep <= step + 1;
                if (card_real == 4'b0001)  // If the card is an Ace, increase the ace_count
                    new_ace <= ace_count + 1;
            end
            else if (step == 2232) begin
                dealOn <= 0;
                nextstep <= 0;
            end
            else begin
                getCard <= 0;
            end
        end
    end
endmodule
