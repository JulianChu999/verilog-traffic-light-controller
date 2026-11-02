`timescale 1ns/10ps
module tb_traffic_light;

reg clk, reset;
wire HG, HY, HR, HRTR, FG, FY, FR, FRTR;

// 呼叫你的主模組 TLC
TLC u1 (
    .clk(clk),
    .reset(reset),
    .HG(HG),
    .HY(HY),
    .HR(HR),
    .HRTR(HRTR),
    .FG(FG),
    .FY(FY),
    .FR(FR),
    .FRTR(FRTR)
);

// 產生時脈：週期設為 20ns（每 10ns 翻轉一次）
initial begin
    clk = 1'b0;
    reset = 1'b1;
end

always begin
    #10 clk = ~clk;
end

// 控制 reset：一開始為 1，在 12ns 時降為 0 開始運作
initial begin
    #12 reset = 1'b0;
    #1500 $finish; // 執行 1500ns 後結束模擬
end

endmodule