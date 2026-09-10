`ifndef STEP_RF_DATA_ITEM_SV
`define STEP_RF_DATA_ITEM_SV

class step_rf_data_item extends uvm_sequence_item;
  `uvm_object_utils(step_rf_data_item)

  typedef enum bit {
    ITEM_READ = 1'b0,
    ITEM_WRITE = 1'b1
  } item_type_e;

  rand item_type_e item_type;
  rand bit [3:0] port_idx;
  rand bit [31:0] data_payload;

  // Simple bound: ensure port index stays within valid physical read ports
  constraint c_valid_port {
    port_idx < step_rf_ctrl_pkg::NUM_RD_PORTS;
  }

  function new(string name = "step_rf_data_item");
    super.new(name);
  endfunction

endclass

`endif