module Hex7Segment (hex_number, seven_seg_display);
input		[3:0]	hex_number;
output		[6:0]	seven_seg_display;

assign seven_seg_display =
		({7{(hex_number == 4'h0)}} & 7'b1000000) |
		({7{(hex_number == 4'h1)}} & 7'b1111001) |
		({7{(hex_number == 4'h2)}} & 7'b0100100) |
		({7{(hex_number == 4'h3)}} & 7'b0110000) |
		({7{(hex_number == 4'h4)}} & 7'b0011001) |
		({7{(hex_number == 4'h5)}} & 7'b0010010) |
		({7{(hex_number == 4'h6)}} & 7'b0000010) |
		({7{(hex_number == 4'h7)}} & 7'b1111000) |
		({7{(hex_number == 4'h8)}} & 7'b0000000) |
		({7{(hex_number == 4'h9)}} & 7'b0010000) |
		({7{(hex_number == 4'hA)}} & 7'b0001000) |
		({7{(hex_number == 4'hB)}} & 7'b0000011) |
		({7{(hex_number == 4'hC)}} & 7'b1000110) |
		({7{(hex_number == 4'hD)}} & 7'b0100001) |
		({7{(hex_number == 4'hE)}} & 7'b0000110) |
		({7{(hex_number == 4'hF)}} & 7'b0001110); 
endmodule

module bin_to_bcd(bin_in, bcd_tens, bcd_ones);
	input [5:0] bin_in;
    output reg [3:0] bcd_tens;
    output reg [3:0] bcd_ones;

       // Always block triggered by changes in bin_in
    always @ (bin_in) begin
        // Initialize BCD digits to 0
        bcd_tens = 4'b0000;
        bcd_ones = 4'b0000;

        // Perform binary to BCD conversion step by step

        // Shift the bits one by one and adjust BCD digits
        // Start with the most significant bit of the binary input
        // Step 1: Shift and add 3 if necessary
        if (bcd_tens >= 5) bcd_tens = bcd_tens + 3;
        if (bcd_ones >= 5) bcd_ones = bcd_ones + 3;
        bcd_tens = {bcd_tens[2:0], bcd_ones[3]};  // Shift tens left by 1
        bcd_ones = {bcd_ones[2:0], bin_in[5]};  // Add the most significant bit of bin_in to ones

        // Step 2: Repeat for the next bit (bin_in[4])
        if (bcd_tens >= 5) bcd_tens = bcd_tens + 3;
        if (bcd_ones >= 5) bcd_ones = bcd_ones + 3;
        bcd_tens = {bcd_tens[2:0], bcd_ones[3]};  // Shift tens left by 1
        bcd_ones = {bcd_ones[2:0], bin_in[4]};  // Add the next bit of bin_in to ones

        // Step 3: Repeat for bin_in[3]
        if (bcd_tens >= 5) bcd_tens = bcd_tens + 3;
        if (bcd_ones >= 5) bcd_ones = bcd_ones + 3;
        bcd_tens = {bcd_tens[2:0], bcd_ones[3]};  // Shift tens left by 1
        bcd_ones = {bcd_ones[2:0], bin_in[3]};  // Add the next bit of bin_in to ones

        // Step 4: Repeat for bin_in[2]
        if (bcd_tens >= 5) bcd_tens = bcd_tens + 3;
        if (bcd_ones >= 5) bcd_ones = bcd_ones + 3;
        bcd_tens = {bcd_tens[2:0], bcd_ones[3]};  // Shift tens left by 1
        bcd_ones = {bcd_ones[2:0], bin_in[2]};  // Add the next bit of bin_in to ones

        // Step 5: Repeat for bin_in[1]
        if (bcd_tens >= 5) bcd_tens = bcd_tens + 3;
        if (bcd_ones >= 5) bcd_ones = bcd_ones + 3;
        bcd_tens = {bcd_tens[2:0], bcd_ones[3]};  // Shift tens left by 1
        bcd_ones = {bcd_ones[2:0], bin_in[1]};  // Add the next bit of bin_in to ones

        // Step 6: Repeat for bin_in[0]
        if (bcd_tens >= 5) bcd_tens = bcd_tens + 3;
        if (bcd_ones >= 5) bcd_ones = bcd_ones + 3;
        bcd_tens = {bcd_tens[2:0], bcd_ones[3]};  // Shift tens left by 1
        bcd_ones = {bcd_ones[2:0], bin_in[0]};  // Add the least significant bit of bin_in to ones
    end

endmodule
