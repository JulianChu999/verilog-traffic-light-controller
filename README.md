# Verilog-Based Intelligent Traffic Light Controller (TLC) Design & FPGA Verification

本專案基於 Verilog HDL 開發一套智慧型雙向交通號誌控制器 (Traffic Light Controller, TLC)，具備主幹道/支線動態計時機制與左轉保護時相 (Left-Turn Phase)。整體架構採用 Top-Down 階層式模組化設計，結合有限狀態機 (FSM) 與動態計數器模組 (counter)，並已在 Intel Quartus 13.1 與 ModelSim-Altera 開發環境下完成完整邏輯合成與 RTL 時序模擬驗證。

---

## 📌 系統核心規格與特點

- **硬體描述語言**：Verilog HDL (2001 Standard)
- **核心架構**：Top-Down 階層式模組化設計 (Top module `TLC` + Sub-module `counter`)
- **狀態機架構**：6-State Finite State Machine ($S_0 \sim S_5$)
- **時相功能**：支援主幹道與支線之紅、黃、綠燈號，以及獨特的左轉保護時相 (`HRTR` / `FRTR`)
- **EDA 開發工具**：Intel Quartus 13.1 Web Edition
- **模擬驗證工具**：ModelSim-Altera Starter Edition 10.1d
- **目標晶片**：Intel Cyclone IV E (EP4CE6F17C8 / 同級目標元件)

---

## 🧱 系統架構圖 (System Architecture)

- **頂層模組 `TLC`**：負責整體 FSM 狀態跳轉與燈號控制，內嵌子模組 `counter` 進行動態計時。兩者透過 `ST_out` (狀態代碼) 與 `TL` / `TS` / `T_TR` (計數到期旗標) 進行同步對接。

---

## 📊 FSM 狀態規劃與時相定義

控制器規劃了 6 個穩定狀態 ($S_0 \sim S_5$)，精準分配各幹道的通行秒數：

| 狀態 | 對應號誌狀態 | 停留條件與時脈數 | 輸出燈號特徵 |
| :--- | :--- | :--- | :--- |
| **S0** | 主幹道直行綠燈 | 達 6 個時脈週期 ($TL = 1$) | $HG=1, FR=1$ (其餘為 0) |
| **S1** | 主幹道黃燈 | 達 4 個時脈週期 ($TS = 1$) | $HY=1, FR=1$ |
| **S2** | 主幹道紅燈＋左轉保護 | 達 3 個時脈週期 ($T\_TR = 1$) | $HRTR=1, FR=1$ |
| **S3** | 支線直行綠燈 | 達 6 個時脈週期 ($TL = 1$) | $HR=1, FG=1$ |
| **S4** | 支線黃燈 | 達 4 個時脈週期 ($TS = 1$) | $HR=1, FY=1$ |
| **S5** | 支線紅燈＋左轉保護 | 達 3 個時脈週期 ($T\_TR = 1$) | $HR=1, FRTR=1$ |

---

## ⚙️ Quartus 邏輯合成與資源評估

透過 Quartus 13.1 的 Analysis & Synthesis 與 TimeQuest Timing Analyzer 針對 Cyclone IV E 晶片進行硬體資源評估與時序分析：

- **Logic Utilization**：使用的 Logic Elements (LEs) 僅佔晶片總容量的 < 2%，顯示極高的邏輯資源效率。
- **Registers**：狀態與計數器暫存器資源開銷極低。
- **TimeQuest Timing**：在 50MHz / 100MHz 系統時脈下，Setup/Hold Slack 均為正值 (MET)，無任何時序違規 (Timing Violation)。

---

## 📊 ModelSim 模擬與功能驗證

透過 `tb_traffic_light.v` 測試平台進行 RTL 級功能驗證，系統時脈週期為 20ns，並於 12ns 時釋放 `reset`：

- **完整狀態切換**：狀態機由 $S_0$ 正確依序經過 $S_1 \to S_2 \to S_3 \to S_4 \to S_5$ 進行大循環。
- **無 Glitch 輸出**：各個號誌燈號切換反應迅速且波形無異常雜訊。

---

## 📂 檔案結構說明

```text
verilog-traffic-light-controller/
├── rtl/
│   ├── TLC.v              # 頂層 Verilog 控制模組 (FSM)
│   └── counter.v          # 內部計數器子模組
├── testbench/
│   └── tb_traffic_light.v # ModelSim 測試平台
├── docs/
│   ├── block_diagram.png  # 系統架構方塊圖
│   ├── fsm_diagram.png    # FSM 狀態轉移圖
│   └── waveform.png       # ModelSim 模擬波形截圖
├── TLC.qpf                # Quartus 專案檔
└── README.md              # 專案說明文件

🚀 快速開始 / 如何執行模擬
使用 Quartus NativeLink 自動模擬：

開啟 Quartus 13.1 並開啟專案檔 TLC.qpf。

點選選單 Tools -> Options -> EDA Tool Locations，確認 ModelSim-Altera 路徑已設為你的 win32aloem 資料夾。

點選 Tools -> Run Simulation Tool -> RTL Simulation 即可自動啟動 ModelSim 並載入波形。

📄 授權條款
本專案採用 MIT License 授權。
