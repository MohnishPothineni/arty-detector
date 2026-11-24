// Drone detector alert board: receives status from the Raspberry Pi over USB-UART
module top (
    input  wire       CLK12MHZ,
    input  wire       uart_txd_in,    // data FROM the Pi
    output wire       uart_rxd_out,   // data TO the Pi
    input  wire [3:0] btn,
    output wire [3:0] led,
    output wire       led0_r, led0_g, led0_b,
    output wire       led1_r, led1_g, led1_b
);
    // ---- Receive commands ----
    wire [7:0] rx_data;
    wire       rx_valid;
    uart_rx #(.CLKS_PER_BIT(104)) u_rx (
        .clk(CLK12MHZ), .rx(uart_txd_in), .data(rx_data), .valid(rx_valid));

    localparam CLEAR = 2'd0, PERSON = 2'd1, HIDDEN = 2'd2;
    localparam [24:0] WD_LIMIT = 25'd24_000_000;   // 2 s at 12 MHz

    reg [1:0]  mode     = CLEAR;
    reg [3:0]  count    = 4'd0;
    reg [24:0] watchdog = 25'd0;

    always @(posedge CLK12MHZ) begin
        if (rx_valid) begin
            watchdog <= 0;
            case (rx_data)
                "P": mode <= PERSON;
                "H": mode <= HIDDEN;
                "C": begin mode <= CLEAR; count <= 0; end
                default:
                    if (rx_data >= "0" && rx_data <= "9")
                        count <= rx_data - "0";
            endcase
        end else if (watchdog < WD_LIMIT) begin
            watchdog <= watchdog + 1;
        end else begin                      // Pi went silent: fail safe
            mode  <= CLEAR;
            count <= 0;
        end
    end

    // ---- LED outputs ----
    reg [23:0] blink = 0;                   // ~0.7 s blink for HIDDEN
    reg [3:0]  pwm   = 0;                   // dim the very bright RGB LEDs
    always @(posedge CLK12MHZ) begin
        blink <= blink + 1;
        pwm   <= pwm + 1;
    end
    wire dim = (pwm == 4'd0);               // 1/16 brightness

    wire red    = (mode == PERSON) || (mode == HIDDEN && blink[23]);
    wire yellow = (mode == HIDDEN && blink[23]);

    assign led0_r = dim & red;
    assign led0_g = dim & yellow;           // red + green = yellow
    assign led0_b = 1'b0;
    assign led1_r = led0_r;
    assign led1_g = led0_g;
    assign led1_b = 1'b0;

    assign led = btn[0] ? 4'b1111 : count;  // hold BTN0 to test LEDs

    // ---- Acknowledge each byte with 'K' ----
    reg tx_start = 1'b0;
    always @(posedge CLK12MHZ) tx_start <= rx_valid;

    uart_tx #(.CLKS_PER_BIT(104)) u_tx (
        .clk(CLK12MHZ), .data("K"), .start(tx_start), .tx(uart_rxd_out), .busy());
endmodule
