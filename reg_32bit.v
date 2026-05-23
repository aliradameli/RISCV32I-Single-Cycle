module reg_32bit (
    input clk,
    input rst_,
    input [31:0] D,                    
    output reg [31:0] Q
);

    always @(posedge clk or negedge rst_) begin
        if(rst_ == 1'b0)begin
            Q <= 32'd0;
        end 
        else begin
            Q <= D;  
        end
    end

endmodule