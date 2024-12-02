
// Register module
module regn(R, Resetn, E, Clock, Q);
    parameter n = 8;
    input [n-1:0] R;
    input Resetn, E, Clock;
    output reg [n-1:0] Q;

    always @(posedge Clock)
        if (!Resetn)
            Q <= 0;
        else if (E)
            Q <= R;
endmodule

// Column counter (horizontal) for object memory (24x36)
module countX(Clock, Resetn, E, Q, pix);
    parameter n = 8;
    input Clock, Resetn, E;
    output reg [4:0] Q;  // 5 bits for counting to 24 (max value 23)
	 output reg [9:0] pix;

    always @ (posedge Clock) begin
        if (Resetn == 0) // Reset when Resetn is low
            Q <= 0;
        else if (E && Q < 23)  // Count from 0 to 23 (24 columns)
            Q <= Q + 1;
        else if (Q == 23)  // Once it reaches 23, reset it
            Q <= 0;
    end
endmodule

// Row counter (vertical) for object memory (24x36)
module countY(Clock, Resetn, E, Q);
    parameter n = 8;
    input Clock, Resetn, E;
    output reg [5:0] Q;  // 6 bits for counting to 36 (max value 35)

    always @ (posedge Clock) begin
        if (Resetn == 0)  // Reset when Resetn is low
            Q <= 0;
        else if (E && Q < 35)  // Count from 0 to 35 (36 rows)
            Q <= Q + 1;
        else if (Q == 35)  // Once it reaches 35, reset it
            Q <= 0;
    end
endmodule

module address(Clock, XC,YC, card_value, pixel);
	input Clock;
    input [4:0] XC;
    input [5:0] YC;
    input [3:0] card_value;
    reg [13:0] posIndex;
    parameter OBJECT_WIDTH = 24;
    output reg [13:0] pixel;
    initial pixel = 14'b00000000000000;

    always @(*) begin
            case (card_value)
                4'b0010: posIndex = 864;  // 2
                4'b0011: posIndex = 1728;  // 3
                4'b0100: posIndex = 2592;  // 4
                4'b0101: posIndex = 3456;  // 5
                4'b0110: posIndex = 4320;  // 6
                4'b0111: posIndex = 5184;  // 7
                4'b1000: posIndex = 6048;  // 8
                4'b1001: posIndex = 6912;  // 9
                4'b1010: posIndex = 7776; // 10 
                4'b1011: posIndex = 8640; // Jack
                4'b1100: posIndex = 9504; // Queen
                4'b1101: posIndex = 10368; // King
                4'b0001: posIndex = 0; // Ace
                default: posIndex = 0;
            endcase
    end

    always @ (*)begin
        pixel = posIndex + (((YC << 4) + (YC << 3)) + XC);   // YC * OBJECT_WIDTH + XC
end
endmodule

module cardNumber(Clock, newCard, cardIn, value);
    input Clock;
    input newCard; //Signal of drawing new card
    input [5:0] cardIn; // 6 bit new card drawn
    output reg [3:0] value; // 4 bit card output value

    initial value = 4'b0000;

    always@(posedge Clock)begin
        if(newCard)begin
            value <= cardIn[3:0];
        end
        else
        value <= value;
    end
endmodule

module symbol(Clock, newCard, cardIn, symbolOut);
    input Clock;
    input newCard; //Signal of drawing a new card
    input [5:0] cardIn; // 6 bit new card drawn
    output reg [1:0] symbolOut;

    always@(posedge Clock)begin
        if(newCard)begin
            symbolOut <= cardIn[5:4];
        end
    end

endmodule