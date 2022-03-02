module PE(
    input wire CLK,                         
    input wire RESET,                       
    input wire EN,                          
    input wire SELECTOR,                    
    input wire W_EN,                        
    
    input wire [31:0]active_left,
    output reg [31:0]active_right,

    input wire [63:0]in_sum,
    output reg [63:0]out_sum,

    input wire [31:0]in_weight_above,
    output wire [31:0]out_weight_below
	);
    reg [31:0] weight_1; 
    reg [31:0] weight_2;

    
    always @(negedge RESET or posedge CLK )begin
        if(~RESET)
        begin
            out_sum <= 0;
            active_right <= 0;
            
            weight_1 <= 0;
            weight_2 <= 0;
        end
        else
        begin
            if(EN)
            begin
                active_right <= active_left;              
                if(SELECTOR)
                begin                                       
                    out_sum <= weight_2*active_left+in_sum;//我把浮点加法和浮点乘法的模块删掉了，以*和+表达浮点乘和浮点加的意思，便于理解
                    if(W_EN)
                    begin
                        weight_1 = in_weight_above;
                        
                    end
                end  
                else
                begin
                    out_sum <= weight_1*active_left+in_sum;
                    if(W_EN)
                    begin
                        weight_2 = in_weight_above;
                        
                    end
                end             
            end
        end
    end
    assign out_weight_below = (SELECTOR)?weight_1 :weight_2;
endmodule