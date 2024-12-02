module main (CLOCK_50, KEY, LEDR, SW,           // De1 Soc stuff
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,        // HEX Display for Debug

    VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS,        // VGA Adaptor
    VGA_BLANK_N, VGA_SYNC_N, VGA_CLK,           // Assignments

    PS2_CLK, PS2_DAT                            // PS/2 Connectors
    );

    /*******************************************************************************************
        I/O Declarations
    *******************************************************************************************/
    input CLOCK_50; input [3:0] KEY; output[9:0] LEDR; input [0:0] SW;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    output [7:0] VGA_R; output [7:0] VGA_G; output [7:0] VGA_B;
    output VGA_HS; output VGA_VS; output VGA_BLANK_N;
    output VGA_SYNC_N; output VGA_CLK;

    inout PS2_CLK; inout PS2_DAT;

    /*******************************************************************************************
        Human Inputs // To be replaced with PS/2
    *******************************************************************************************/
    wire softRes, hardRes;
    assign softRes = KEY[0]; assign hardRes = SW[0];

    reg hit, stand, start; //KEY[3], KEY[2], KEY[1]
    reg hit_, stand_, start_;
    always @ (posedge CLOCK_50) begin // Debouncing
        if (KEY[3]) begin
            if (!hit_) begin
                hit <= 1;
                hit_ <= 1;
            end else
                hit <= 0;
        end else
            hit_ <= 0;
        if (KEY[2]) begin
            if (!stand_) begin
                stand <= 1;
                stand_ <= 1;
            end else
                stand <= 0;
        end else
            stand_ <= 0;
        if (KEY[1]) begin
            if (!start_) begin
                start <= 1;
                start_ <= 1;
            end else
                start <= 0;
        end else
            start_ <= 0;
    end
	 
    /*******************************************************************************************
        Card Deck Ram Management
    *******************************************************************************************/
    wire cardWrtEn; wire [5:0] cardDatOut;
    reg [5:0] cardAdr; reg [5:0] cardDatIn;
    carddeck cardRAM (cardAdr, CLOCK_50, cardDatIn, cardWrtEn, cardDatOut);

    wire startShuffle, shuffleWrtEn, shuffleOn;
    wire [5:0] shuffleAdr, shuffleDatIn, shuffleDatOut;
    cardshuffle shuffler (CLOCK_50, startShuffle, hardRes, shuffleOn, shuffleAdr, shuffleDatIn, shuffleWrtEn, cardDatOut);

    wire cardGetEn; wire [5:0] cardGetOut;
    wire [5:0] cardGetAdr, cardGetCurrAdr;
    get_card getter (CLOCK_50, hardRes, cardGetEn, cardGetOut, cardGetAdr, cardDatOut, cardGetCurrAdr);

    always @ (*) begin // control access to card deck RAM
        if (shuffleAdr == 6'b111111)
            cardAdr <= cardGetAdr;
        else if (cardGetAdr == 6'b111111)
            cardAdr <= shuffleAdr;

        cardDatIn <= shuffleDatIn;

        // cardAdr <= cardGetAdr; //temp
    end

    wire playerGetCardEn, dealerGetCardEn; // control cardGetEn
    assign cardGetEn = playerGetCardEn | dealerGetCardEn;
      

    /*******************************************************************************************
        Main Game Modules
    *******************************************************************************************/
    wire [9:0] balance;
    wire [4:0] playerHandVal, dealerHandVal;
    wire [9:0] betAmount; wire betLock;
    wire dealStart; wire dealOn;
    wire dealerStart; wire dealerOn;
    wire refresh;
    wire [2:0] state;

    state_controller FSM(
        CLOCK_50, softRes,              //
        playerHandVal, dealerHandVal,   // Value of the Hands
        betAmount, betLock,             // Bet Controller
        startShuffle, shuffleOn,        // Shuffle Controller
        dealStart, dealOn,              // Deal Controller
        dealerStart, dealerOn,          // Dealer Controller
        hit, stand, start,              // Player Inputs
        balance,                        // Amount of Money Owned
        refresh,                        // Refresh Bet and Hands
        state                           // Output Current State
    );

    betControl betCTRL (CLOCK_50, refresh, betLock, hit, stand, balance, betAmount);
	 
	 
	 wire playerDealOn, dealerDealOn;
	 assign dealOn = playerDealOn | dealerDealOn;
    playerHand playerHand (CLOCK_50, refresh, dealStart, hit, state, playerDealOn, playerGetCardEn, cardGetOut, playerHandVal);
    dealerHand dealerHand (CLOCK_50, refresh, dealStart, dealerStart, state, dealerDealOn, dealerOn, dealerGetCardEn, cardGetOut, dealerHandVal);

    /*******************************************************************************************
        Debug Output
    *******************************************************************************************/
    wire [3:0] playerBCD1, playerBCD2, dealerBCD1, dealerBCD2;
    bin_to_bcd bcd1 (playerHandVal, playerBCD1, playerBCD2);
    bin_to_bcd bcd2 (dealerHandVal, dealerBCD1, dealerBCD2);
    Hex7Segment hex0 (playerBCD2, HEX0);    // players hand
    Hex7Segment hex1 (playerBCD1, HEX1);
    Hex7Segment hex2 (dealerBCD2, HEX2);    // dealers hand
    Hex7Segment hex3 (dealerBCD1, HEX3);
//    Hex7Segment hex4 (balance[3:0]      , HEX4);    // balance
//    Hex7Segment hex5 (betAmount[3:0]    , HEX5);    // bet amount
	 Hex7Segment hex4 (cardGetOut[3:0]    , HEX4);    
    Hex7Segment hex5 ({2'b00, cardGetOut[5:4]} , HEX5);    

	assign LEDR[9:4] = cardGetCurrAdr;
    assign LEDR[2:0] = state;
    /*******************************************************************************************
        VGA Output
    *******************************************************************************************/
    // start drawing signal
    reg [5:0] prevCard; reg newcard;
    always @ (posedge CLOCK_50) begin
        if (prevCard != cardGetOut)
            newcard <= 1;
        else
            newcard <= 0;
        
        prevCard <= cardGetOut;
    end

    // Constants for object dimensions
    parameter OBJECT_WIDTH = 24;
    parameter OBJECT_HEIGHT = 36;

    // Wire declarations
    wire [7:0] X;           // Starting X position of object
    wire [6:0] Y;           // Starting Y position of object
    wire [4:0] XC;          // Column counter for object memory
    wire [5:0] YC;          // Row counter for object memory
    wire [7:0] VGA_X;       // X coordinate for VGA
    wire [6:0] VGA_Y;       // Y coordinate for VGA
    reg [2:0] VGA_COLOR;   // Color for the current pixel
	 wire [13:0] pix;
    wire Ex, Ey;            // End signals for counters
    wire [3:0] value;
    wire [3:0] card_value;
    wire [1:0] symbolOut;
    reg plot;               // Plot enable signal
    reg [7:0] preset_x;     // Predefined starting X position
    reg [6:0] preset_y;     // Predefined starting Y position
    reg draw_started;       // Flag to control drawing
    reg [2:0] x_index;  // Index for the predefined positions
	 reg [1:0] y_index;
	 reg [1:0] x_position;
	 reg [1:0] position_index;
     reg [1:0] player_card;
     reg [2:0] prevState;
	 
    
    // Predefined positions for the object (4 positions)
    reg [7:0] x_positions[3:0];  // X coordinates for 4 positions
    reg [7:0] x_positions_turn[1:0];
    reg [6:0] y_positions[3:0];  // Y coordinates for 4 positions

    // Initialize starting coordinates and position index
    initial begin
		  draw_started = 0;
        position_index = 0;         // Start from the first position
		  plot = 0;
		  
        x_positions[0] = 8'h09;  // Position 1
        x_positions[1] = 8'h26;  // Position 2
        x_positions[2] = 8'h43;  // Position 3
        x_positions[3] = 8'h60;  // Position 4

        x_positions_turn[0] = 8'h43;
        x_positions_turn[1] = 8'h60;
		  
		player_card = 2'b00;
        x_index = 3'b000;
        
    end
	 
     // 010 = deal
     // 011 = player turn
     // 100 = dealer turn
	 
    // Drawing control logic
    always @(posedge CLOCK_50) begin
        if (prevState != state)
            position_index <= 0;
        prevState <= state;

		  if (!newcard) begin
            draw_started <= 0;  // Reset drawing flag
            plot <= 0;
            y_positions[0] = 7'h0B;  // Dealer Row
            y_positions[1] = 7'h49;  // Player Row
        end
		
       
			else if (newcard && !draw_started && state == 3'b010) begin // DEAL
            draw_started <= 1;  // Start drawing
            plot <= 1;
           
            // Update the position index to select the next coordinate
            if(player_card == 2'b10 && x_index <=1) begin
                preset_x <= x_positions[x_index];
                preset_y <= y_positions[0];

                x_index <= x_index + 1;
            end

			else if (position_index <= 1) begin
                position_index <= position_index + 1;

                player_card <= player_card + 1;
                preset_x <= x_positions[position_index];
                preset_y <= y_positions[1];
            end
        end
        else if (newcard && !draw_started && state == 3'b011) begin // PLAYER turn
            draw_started <= 1;  // Start drawing
            plot <= 1;
            
            // Update the position index to select the next coordinate
                if (position_index <= 1) begin
                    position_index <= position_index + 1;
                    
                    preset_x <= x_positions_turn[position_index];
                    preset_y <= y_positions[1];
                end
        end
		else if (newcard && !draw_started && state == 3'b100) begin // DEALER turn
                draw_started <= 1;  // Start drawing
                plot <= 1;
                
                // Update the position index to select the next coordinate
                if (position_index <= 1) begin
                    position_index <= position_index + 1;
                    preset_x <= x_positions_turn[position_index];
                    preset_y <= y_positions[0];
		        end
        end
    end

    // Coordinate assignments
    assign X = preset_x;
    assign Y = preset_y;

    // Column counter (horizontal)
     countX U3 (CLOCK_50, KEY[0], Ex, XC);
     defparam U3.n = 5;  // 5 bits for 24 columns (2^5 = 32)

     // Row counter (vertical)
     countY U4 (CLOCK_50, KEY[0], Ey, YC);
     defparam U4.n = 6;  // 6 bits for 36 rows (2^6 = 64)

     // Enable Ex when VGA plotting starts
     regn U5 (1'b1, KEY[0], newcard, CLOCK_50, Ex);
     defparam U5.n = 1;

     // Enable Ey at the end of each row (XC == 23)
     assign Ey = (XC == 23);
	 
     cardNumber card_number(CLOCK_50, 1'b1, cardGetOut, value);


	  symbol symbol_out(CLOCK_50, 1'b1, cardGetOut, symbolOut);

	 
	 
     // Access the object memory (24x36 object)
     address add(CLOCK_50, XC, YC, value, pix);

	 	wire [2:0] heart_color, diamond_color, spade_color, club_color;
	   hearts hearts(pix, CLOCK_50, heart_color);
      diamonds diamonds(pix, CLOCK_50, diamond_color);
      spades spades(pix, CLOCK_50, spade_color);
      club club(pix, CLOCK_50, club_color);
	  
	   always@(*) begin
	 		case(symbolOut)
	 		2'b00: VGA_COLOR = heart_color;
          2'b01: VGA_COLOR = diamond_color;
          2'b10: VGA_COLOR = spade_color;
          2'b11: VGA_COLOR = club_color;
	 		endcase
	   end
	  
	  
     // Synchronize VGA coordinates
     regn U7 (X + XC, KEY[0], 1'b1, CLOCK_50, VGA_X);
     defparam U7.n = 8;

     regn U8 (Y + YC, KEY[0], 1'b1, CLOCK_50, VGA_Y);
     defparam U8.n = 7;

     // VGA adapter instantiation
     vga_adapter VGA (
         .resetn(KEY[0]),
         .clock(CLOCK_50),
         .colour(VGA_COLOR),
         .x(VGA_X),
         .y(VGA_Y),
         .plot(!plot),
         .VGA_R(VGA_R),
         .VGA_G(VGA_G),
         .VGA_B(VGA_B),
         .VGA_HS(VGA_HS),
         .VGA_VS(VGA_VS),
         .VGA_BLANK_N(VGA_BLANK_N),
         .VGA_SYNC_N(VGA_SYNC_N),
         .VGA_CLK(VGA_CLK)
     );
     defparam VGA.RESOLUTION = "160x120";
     defparam VGA.MONOCHROME = "FALSE";
     defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
     defparam VGA.BACKGROUND_IMAGE = "background.mif";

endmodule