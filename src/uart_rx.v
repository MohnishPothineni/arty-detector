// UART receiver: 8 data bits, no parity, 1 stop bit
module uart_rx #(parameter CLKS_PER_BIT = 104) (   // 12 MHz / 115200 baud
    input  wire       clk,
    input  wire       rx,
    output reg  [7:0] data  = 8'd0,
    output reg        valid = 1'b0
);
    // Two-flop synchronizer (rx comes from outside the FPGA clock domain)
    reg r1 = 1'b1, r2 = 1'b1;
    always @(posedge clk) begin
        r1 <= rx;
        r2 <= r1;
    end

    localparam IDLE = 2'd0, START = 2'd1, DATA = 2'd2, STOP = 2'd3;
    reg [1:0] state = IDLE;
    reg [7:0] cnt   = 8'd0;
    reg [2:0] bitn  = 3'd0;
    reg [7:0] shift = 8'd0;

    always @(posedge clk) begin
        valid <= 1'b0;
        case (state)
            IDLE:  if (!r2) begin state <= START; cnt <= 0; end
            START: if (cnt == CLKS_PER_BIT/2) begin        // middle of start bit
                       if (!r2) begin state <= DATA; cnt <= 0; bitn <= 0; end
                       else     state <= IDLE;               // false start
                   end else cnt <= cnt + 1;
            DATA:  if (cnt == CLKS_PER_BIT-1) begin
                       cnt   <= 0;
                       shift <= {r2, shift[7:1]};            // LSB first
                       if (bitn == 3'd7) state <= STOP;
                       else              bitn  <= bitn + 1;
                   end else cnt <= cnt + 1;
            STOP:  if (cnt == CLKS_PER_BIT-1) begin
                       state <= IDLE;
                       cnt   <= 0;
                       if (r2) begin data <= shift; valid <= 1'b1; end
                   end else cnt <= cnt + 1;
        endcase
    end
endmodule
