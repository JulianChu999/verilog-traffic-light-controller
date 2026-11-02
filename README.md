# Verilog Traffic Light Controller (TLC)

這是一個基於 FSM (Finite State Machine) 實作的智慧型交通號誌控制器，使用 Verilog HDL 開發，專為 FPGA 原型設計所打造，並透過 ModelSim 進行功能驗證（Functional Simulation）。

## 📌 專案概述 (Project Overview)
本專案實作了一個可管理主幹道與支線（包含左轉專用時相）的交通號誌控制器。專案採用 **Top-Down 模組化設計方法**，將控制器狀態機與計時管理邏輯清楚分離。

## 🧱 系統架構 (System Architecture)
系統主要由兩個核心模組整合至 Top-level 設計中：
1. **`TLC` (Finite State Machine / 狀態機)**：
   - 管理 6 個不同的運作狀態（$S0 \sim S5$）。
   - 根據計時器閥值（`TL`, `TS`, `T_TR`）產生主幹道與支線的控制信號（包含綠燈 `HG`/`FG`、黃燈 `HY`/`FY`、紅燈 `HR`/`FR` 與左轉保護燈號）。
2. **`counter` (計時器模組)**：
   - 由狀態輸出（`ST_out`）驅動的動態計時器。
   - 產生清除旗標（`timer_clr`）與時間到脈衝，以精確驅動狀態轉移邏輯。

## 🛠️ 開發與驗證環境 (Development & Verification Environment)
- **綜合與實現 (Synthesis & Implementation)**：Intel Quartus 13.1（目標晶片：Cyclone IV E）
- **功能驗證 (Functional Verification)**：ModelSim-Altera Starter Edition
- **模擬驗證 (Simulation Validation)**：透過完整的 RTL simulation testbench (`tb_traffic_light.v`) 進行驗證。

## 📊 模擬結果 (Simulation Results)
Testbench 提供 20ns 的時脈週期（Clock Cycle）與非同步重置（Asynchronous Reset）控制。功能驗證確認所有狀態皆能循序切換，且輸出信號（如 `HG`, `HY`, `HR`, `FG`, `FY`, `FR`）皆能依照時序規格正確切換。

## 🚀 快速開始 (Getting Started)
1. Clone 本專案並在 **Quartus 13.1** 中開啟專案。
2. 執行 Analysis & Synthesis 以確保程式碼順利完成編譯。
3. 使用 ModelSim 載入 `tb_traffic_light.v` 並執行模擬腳本，即可觀察完整的波形行為。