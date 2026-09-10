// Root UVM package for the STEP Register File Controller testbench.
// Defines architectural parameters (grid dimensions, port counts, bit-widths).
// Defines shared enumeration types (commands: IDLE, CONFIG, START).
// Includes all sequence items, verification components, sequences, and tests.

package step_rf_ctrl_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // 1. Architectural Parameters
  localparam int NUM_TILE_ROWS = 4;
  localparam int NUM_TILE_COLS = 4;
  localparam int NUM_TILES = 16;
  localparam int NUM_CONSTS = 1;
  localparam int NUM_BANKS = 4;
  localparam int NUM_REGISTERS = 16;
  localparam int NUM_PRED_REGS = 16;
  localparam int NUM_TOKENS = 8;
  localparam int MAX_DELAY = 16;
  localparam int MAX_THREAD_COUNT = 32;

  localparam int NUM_RD_PORTS = 16;
  localparam int NUM_WR_PORTS = 8;
  localparam int NUM_LD_PORTS = 2;
  localparam int NUM_ST_PORTS = 2;
  localparam int NUM_TAKER_PORTS = 16;
  localparam int NUM_RETURNER_PORTS = 12;

  localparam int REG_DATA_WIDTH = 8;
  localparam int REG_ADDR_WIDTH = $clog2(NUM_REGISTERS);
  localparam int PRED_ADDR_WIDTH = $clog2(NUM_PRED_REGS);
  localparam int TID_WIDTH = $clog2(MAX_THREAD_COUNT);
  localparam int PORT_ROUTE_WIDTH = NUM_RETURNER_PORTS;
  localparam int PORT_DELAY_WIDTH = $clog2(NUM_TILES);
  localparam int CFG_METADATA_WIDTH = 128;
  localparam int CFG_TOKENIZER_WIDTH = 64;


  // 2. Shared Enums
  typedef enum logic [2:0] {
    CMD_IDLE = 3'd0,
    CMD_CONFIG = 3'd1,
    CMD_START = 3'd2
  } cmd_type_e;


  // 3. Packed Bit-Structs
  typedef struct packed {
    logic [3:0] sink_id;
    logic [3:0] delay_cycles;
  } tokenizer_sink_entry_t;

  typedef struct packed {
    logic [1:0] num_active_sinks;
    tokenizer_sink_entry_t [3:0] sinks;
    logic [1:0] reserved;
  } step_compressed_tokenizer_cfg_t;


  // 4. File Includes (in exact dependency order)
  `include "step_tokenizer_cfg_item.sv"
  `include "step_rf_cfg_metadata_item.sv"
  `include "step_rf_data_item.sv"

  `include "step_rf_directed_seq.sv"
  `include "step_rf_random_seq.sv"

  `include "step_rf_ctrl_driver.sv"
  `include "step_rf_ctrl_monitor.sv"
  `include "step_rf_ctrl_coverage.sv"
  `include "step_rf_ctrl_scoreboard.sv"

  `include "step_rf_ctrl_env.sv"
  `include "step_rf_base_test.sv"
  `include "step_rf_random_test.sv"

endpackage : step_rf_ctrl_pkg