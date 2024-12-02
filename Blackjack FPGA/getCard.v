 module get_card(Clock, resetn, getEn, cardOut, Address, DataOut, currentAdr);
    input Clock, resetn, getEn; // pull getEn high to get card out of memory
    output reg [5:0] cardOut;
    output reg [5:0] Address; // control the card deck RAM
    input [5:0] DataOut;
    output reg [5:0] currentAdr;
   
    reg [1:0] step, nextstep;

    always @ (posedge getEn or negedge resetn)
        if (~resetn) begin
            currentAdr <= 6'b0;
//            cardOut <= 6'b0;
        end
        else if (getEn) begin
            currentAdr <= currentAdr + 1;
        end
        
    always @ (posedge Clock) begin
        if (getEn)
            step <= 1;
        else 
            step <= nextstep;
    end

    always @ (*)begin
        if (~resetn) begin
            cardOut <= 6'b0;
        end
        else case (step)
            1: begin
                Address <= currentAdr;
                nextstep <= step + 1;
            end
            2: begin
                nextstep <= step + 1;
                cardOut <= DataOut;
            end
            3: begin
                Address <= 6'b111111;
                nextstep <= step + 1;
            end
            0: Address <= 6'b111111;
            default: Address <= 6'b111111;
        endcase
    end
 endmodule