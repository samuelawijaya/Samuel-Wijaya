module state_controller (
    Clock, ResetN,                  //
    playerHandVal, dealerHandVal,   // Value of the Hands
    betAmount, betLock,             // Bet Controller
    shuffleStart, shuffleOn,        // Shuffle Controller
    dealStart, dealOn,              // Deal Controller
    dealerStart, dealerOn,          // Dealer Controller
    hit, stand, start,              // Player Inputs
    balance,                        // Amount of Money Owned
    refresh,                        // Refresh Bet and Hands
    state                           // Output Current State
);
    // I/O Declarations
    input Clock, ResetN;
    input [4:0] playerHandVal, dealerHandVal;
    input [9:0] betAmount; output reg betLock;
    output reg shuffleStart; input shuffleOn;
    output reg dealStart; input dealOn;
    output reg dealerStart; input dealerOn;
    input hit, stand, start;
    output reg [9:0] balance;
    output reg refresh;
    output [2:0] state;

    // Define states using parameter
    parameter SETUP       = 3'b000;
    parameter BET         = 3'b001;
    parameter DEAL        = 3'b010;
    parameter PLAYER_TURN = 3'b011;
    parameter DEALER_TURN = 3'b100;
    parameter CHECK_WIN   = 3'b101;
    parameter GAME_OVER   = 3'b110;

    reg [2:0] current_state, next_state;

    // Outputs
    assign state = current_state;

    reg shuffleDone, dealDone, dealerDone;
    reg [9:0] newBalance;
    always @ (posedge Clock) begin
        if (!ResetN) begin
            shuffleDone <= 0;
            dealDone <= 0;
            dealerDone <= 0;
        end
        if (current_state == SETUP) begin
            if (!shuffleDone) begin
                shuffleStart <= 1;
                shuffleDone <= 1;
                balance <= 10'd5; //100
            end else
                shuffleStart <= 0;
        end else
            shuffleDone <= 0;

        if (current_state == BET)
            betLock <= 0;
        else    
            betLock <= 1;

        if (current_state == DEAL) begin
            if (!dealDone) begin
                dealStart <= 1;
                dealDone <= 1;
            end else    
                dealStart <= 0;
        end else
            dealDone <= 0;

        if (current_state == DEALER_TURN) begin
            if (!dealerDone) begin
                dealerStart <= 1;
                dealerDone <= 1;
            end else    
                dealerStart <= 0;
        end else
            dealerDone <= 0;

        if (current_state == CHECK_WIN) begin
            balance <= newBalance;
        end

        if (current_state == GAME_OVER || current_state == SETUP) begin
            refresh <= 1;
        end else
            refresh <= 0;
    end
    
    // State Register: Update the current state on each clock cycle and resets game logic
    always @(posedge Clock) begin
        if (!ResetN) begin
            current_state <= SETUP;
        end
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            SETUP: begin
                if (start)
                    next_state = BET;
                else
                    next_state = SETUP;
            end

            BET: begin
                if(start)
                    next_state = DEAL;
                else 
                    next_state = BET;
            end

            DEAL: begin
                if (!dealOn && !dealStart && dealDone)
                    next_state = PLAYER_TURN;
                else
                    next_state = DEAL;
            end

            PLAYER_TURN: begin
                if (playerHandVal > 21)
                    next_state = CHECK_WIN;
                else if (playerHandVal == 21)
                    next_state = DEALER_TURN; 
                else if (hit)
                    next_state = PLAYER_TURN;
                else if (stand)
                    next_state = DEALER_TURN; 
            end

            DEALER_TURN: begin
                if (!dealerOn)
                    next_state = CHECK_WIN;
                else
                    next_state = DEALER_TURN;
            end

            CHECK_WIN: begin
                if(dealerHandVal > 21) begin        // dealer bust
                    newBalance <= balance + betAmount;
                    next_state <= GAME_OVER;
                end
                else if(playerHandVal > 21) begin   // player bust
                    newBalance <= balance - betAmount;
                    next_state <= GAME_OVER;
                end
                else if(playerHandVal < dealerHandVal) begin   // Lose Condition
                    newBalance <= balance - betAmount;
                    next_state <= GAME_OVER;
                end 
                else if(playerHandVal > dealerHandVal) begin   // Win Condition
                    newBalance <= balance + betAmount;
                    next_state <= GAME_OVER;
                end
                else if(playerHandVal == dealerHandVal) begin                       // Draw Condition
                    newBalance <= balance;
                    next_state = GAME_OVER;
                end
                else
                    next_state = CHECK_WIN;
            end

            GAME_OVER: begin
                if (start) begin
                    next_state = BET; 
                end
            end

            default: next_state = BET;
        endcase
    end
endmodule