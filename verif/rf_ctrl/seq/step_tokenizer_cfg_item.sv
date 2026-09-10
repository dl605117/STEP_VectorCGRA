`ifndef STEP_TOKENIZER_CFG_ITEM_SV
`define STEP_TOKENIZER_CFG_ITEM_SV

class step_tokenizer_cfg_item extends uvm_sequence_item;
  `uvm_object_utils(step_tokenizer_cfg_item)

  // Configuration metadata
  rand bit [1:0] num_active_sinks;
  rand tokenizer_sink_entry_t sinks[4];
  rand bit [step_rf_ctrl_pkg::TID_WIDTH-1:0] thread_id;

  // Packed output struct for DUT drive
  step_compressed_tokenizer_cfg_t packed_cfg;

  // Execution-specific routing constraints
  constraint c_valid_sink_count {
    num_active_sinks inside {[1:3]};    // At least 1 active sink per active token route
  }

  constraint c_execution_valid_routes {
    // Sinks must point to physically valid taker ports
    foreach (sinks[i]){
      sinks[i].sink_id < step_rf_ctrl_pkg::NUM_TAKER_PORTS;
      sinks[i].delay_cycles <= step_rf_ctrl_pkg::MAX_DELAY;
    }

    // Disallow duplicate sinks in the same instruction cycle (no double-fires)
    unique { sinks[0].sink_id, sinks[1].sink_id, sinks[2].sink_id, sinks[3].sink_id };
  }

  function new(string name = "step_tokenizer_cfg_item");
    super.new(name);
  endfunction

  function void post_randomize();
    
    packed_cfg.num_active_sinks = num_active_sinks;
    for (int i = 0; i < 4; i++) begin
      packed_cfg.sinks[i] = sinks[i];
    end
    
    packed_cfg.reserved = '0;
  endfunction

endclass

`endif