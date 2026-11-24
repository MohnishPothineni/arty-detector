// UART transmitter: 8N1
module uart_tx #(parameter CLKS_PER_BIT = 104) (
    input  wire       clk,
    input  wire [7:0] data,
    input  wire       start,
    output reg        tx   = 1'b1,
    output wire       busy
);
    reg [9:0] frame  = 10'h3FF;
    reg [3:0] bitn   = 4'd0;
    reg [7:0] cnt    = 8'd0;
    reg       active = 1'b0;
    assign busy = active;

    always @(posedge clk) begin
        if (!active) begin
            tx <= 1'b1;
            if (start) begin
                frame  <= {1'b1, data, 1'b0};   // stop, data, start
                active <= 1'b1;
                bitn   <= 0;
                cnt    <= 0;
            end
        end else begin
            tx <= frame[bitn];
            if (cnt == CLKS_PER_BIT-1) begin
                cnt <= 0;
                if (bitn == 4'd9) active <= 1'b0;
                else              bitn   <= bitn + 1;
            end else cnt <= cnt + 1;
        end
    end
endmodule
