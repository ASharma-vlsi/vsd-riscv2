module timer_ip (
    input            clk,
    input            resetn,
    input            sel,
    input            we,
    input            rd_en,
    input  [31:0]     addr,
    input  [31:0]    wdata,
    output reg [31:0] rdata,
    output reg       timeout
);
    // ------------------------------------------------------------
    // Register map (offsets)
    // ------------------------------------------------------------
    localparam REG_CTRL  = 32'h00;  // bit0: en, bit1: mode
    localparam REG_LOAD  = 32'h04;  // load value
    localparam REG_VALUE = 32'h08;  // current value (RO)
    localparam REG_STAT  = 32'h0C;  // bit0: timeout (W1C)

    // ------------------------------------------------------------
    // Internal registers
    // ------------------------------------------------------------
    reg        en;
    reg        mode;          // 0 = one-shot, 1 = periodic
    reg [31:0] load_reg;
    reg [31:0] value_reg;

    // ------------------------------------------------------------
    // Prescaler (simple divide-by-1, expandable)
    // ------------------------------------------------------------
    wire tick = 1'b1;   // one decrement per clock (clean + reliable)

    // ------------------------------------------------------------
    // Write logic
    // ------------------------------------------------------------
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            en       <= 1'b0;
            mode     <= 1'b0;
            load_reg <= 32'd0;
        end else if (sel && we) begin
            case (addr[3:0])
                REG_CTRL: begin
                    en   <= wdata[0];
                    mode <= wdata[1];
                end
                REG_LOAD: begin
                load_reg  <= wdata;
                end
                default: ;
            endcase
        end
    end

    // ------------------------------------------------------------
    // Timer core + TIMEOUT PULSE 
    // ------------------------------------------------------------
    always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        value_reg <= 32'd0;
        timeout   <= 1'b0;
    end else begin

        timeout <= 1'b0;

        // Load timer when software writes LOAD register
        if (sel && we && addr[3:0] == REG_LOAD)
            value_reg <= wdata;

        else if (en && tick) begin
            if (value_reg > 0)
                value_reg <= value_reg - 1;
            else begin
                timeout <= 1'b1;

                if (mode)
                    value_reg <= load_reg;
                else
                    value_reg <= 32'd0;
            end
        end
    end
end
    
    // ------------------------------------------------------------
    // Read logic
    // ------------------------------------------------------------
    always @(*) begin
        case (addr[3:0])
            REG_CTRL:  rdata = {30'b0, mode, en};
            REG_LOAD:  rdata = load_reg;
            REG_VALUE: rdata = value_reg;
            REG_STAT:  rdata = {31'b0, timeout};
            default:   rdata = 32'b0;
        endcase
    end

endmodule

