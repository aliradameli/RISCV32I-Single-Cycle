module RiscV_tb ();
    reg clk;
    reg rst; 

    RiscV_Processor CUT(
        .clk(clk), 
        .rst(rst)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
	clk = 0 ;
        rst = 1;#1 rst = 0;
        repeat (3) @(posedge clk);
        rst = 1;
        while (CUT.riscv_datapath.PC < 32'd76) begin
            @(posedge clk);
        end
        $stop;
    end

endmodule