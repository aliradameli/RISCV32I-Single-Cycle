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
        rst = 1; 
        repeat (2) @(posedge clk);
        rst = 0;
        repeat (2000) @(posedge clk);
        $stop;
    end

endmodule