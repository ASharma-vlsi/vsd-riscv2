module gpio_ip (
    input wire clk,
    input wire resetn,

    input wire [29:0] mem_wordaddr,
    input wire        isIO,
    input wire        mem_wstrb,
    input wire [31:0] mem_wdata,

    output reg [31:0] gpio_rdata,
    output reg [31:0] gpio_out
);

    // GPIO address bit
    localparam IO_GPIO_bit = 3;

    // Internal register
    reg [31:0] gpio_reg;

    // WRITE LOGIC
    always @(posedge clk) begin
        if(!resetn) begin
            gpio_reg <= 32'b0;
        end
        else if(isIO &&
                mem_wstrb &&
                mem_wordaddr[IO_GPIO_bit]) begin

            gpio_reg <= mem_wdata;
        end
    end

    // OUTPUT CONNECTION
    always @(*) begin
    gpio_out = gpio_reg;
end

    // READBACK LOGIC
    always @(*) begin
        if(isIO && mem_wordaddr[IO_GPIO_bit])
            gpio_rdata = gpio_reg;
        else
            gpio_rdata = 32'b0;
    end

endmodule
