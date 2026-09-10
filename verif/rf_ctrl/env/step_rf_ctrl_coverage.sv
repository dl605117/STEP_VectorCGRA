`ifndef STEP_RF_CTRL_COVERAGE_SV
`define STEP_RF_CTRL_COVERAGE_SV

class step_rf_ctrl_coverage extends uvm_subscriber #(step_tokenizer_cfg_item);
  `uvm_component_utils(step_rf_ctrl_coverage)

  step_tokenizer_cfg_item sampled_item;

  covergroup cg_tokenizer_routes;
    option.per_instance = 1;
    option.name = "cg_tokenizer_routes";

    // Cover distribution across all 16 physical taker ports
    cp_active_sinks: coverpoint sampled_item.num_active_sinks {
      bins single_sink = {1};
      bins dual_sink = {2};
      bins triple_sink = {3};
    }

    cp_sink_0: coverpoint sampled_item.sinks[0].sink_id {
      bins low_ports = {[0:3]};
      bins mid_ports = {[4:11]};
      bins high_ports = {[12:15]};
    }

    cp_delay_spread: coverpoint sampled_item.sinks[0].delay_cycles {
      bins zero_delay = {0};
      bins low_delay  = {[1:4]};
      bins high_delay = {[5:16]};
    }

    // Cross active sink density with delay distribution
    cross_sink_x_delay: cross cp_active_sinks, cp_delay_spread;
  
  endgroup


  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg_tokenizer_routes = new();
  endfunction


  virtual function void write(step_tokenizer_cfg_item t);
    sampled_item = t;
    cg_tokenizer_routes.sample();
  endfunction

endclass

`endif