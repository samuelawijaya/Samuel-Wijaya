module betControl(clk, refresh, bet_lock, increase_bet, decrease_bet, balance, bet);
    input wire clk;                  // Clock signal
    input wire refresh;              // REFRESH signal to reset the bet AMOUNT only
    input wire bet_lock;             // Lock In bet amount
    input wire increase_bet;         // Signal to increase the bet by 100
    input wire decrease_bet;         // Signal to decrease the bet by 100
    input wire [9:0] balance;        // Initial balance input
    output reg [9:0] bet;            // Current bet amount

    // Update balance and bet based on player input
    always @(posedge clk or posedge refresh) begin
        if (refresh) begin
            // Reset only the bet amount to zero on reset
            bet <= 10'd0;
        end
		  else if (!bet_lock)begin
            // Increase or decrease the bet within balance limits
            if (increase_bet && (bet + 1 <= balance)) begin //100 for real, 1 for test
                bet <= bet + 10'd1;
            end
            if (decrease_bet && (bet >= 1)) begin
                bet <= bet - 10'd1;
            end
        end
    end

endmodule
