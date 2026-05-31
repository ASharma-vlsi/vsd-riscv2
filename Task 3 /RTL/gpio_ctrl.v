module gpio_ip (
    input wire clk,
    input wire resetn,

    input wire [29:0] mem_wordaddr,
    input wire        isIO,
    input wire        mem_wstrb,
    input wire [31:0] mem_wdata,

    output wire [31:0] gpio_rdata,
    output wire [31:0] gpio_out
);

    // GPIO address bit
    wire sel_data = mem_wordaddr[3];
    wire sel_dir  = mem_wordaddr[4];
    wire sel_read = mem_wordaddr[5];

    // Internal register
    reg [31:0] gpio_data;
    reg [31:0] gpio_dir;

    // WRITE LOGIC
    always @(posedge clk) begin
    if(!resetn) begin
        gpio_data <= 32'b0;
        gpio_dir  <= 32'b0;
    end
    else if(isIO && mem_wstrb) begin

        if(sel_data)
            gpio_data <= mem_wdata;

        if(sel_dir)
            gpio_dir <= mem_wdata;

    end
    end

    // OUTPUT CONNECTION
    assign gpio_out = gpio_data & gpio_dir;

    // READBACK LOGIC
    
    assign gpio_rdata =
        sel_data ? gpio_data :
        sel_dir  ? gpio_dir  :
        sel_read ? gpio_read :
        32'b0;
        
     // Read Logic  
    wire [31:0] gpio_read;

    assign gpio_read = (gpio_data & gpio_dir);

endmodule
