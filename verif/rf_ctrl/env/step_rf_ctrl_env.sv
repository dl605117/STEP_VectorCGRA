// UVM Environment container for the STEP Register File Controller testbench.
// Instantiates the verification components (driver, sequencer, monitor, scoreboard, coverage).
// Connects the driver to the sequencer for transaction delivery.
// Connects the monitor analysis port to the scoreboard and coverage collector.

class step_rf_ctrl_env extends uvm_env;
  
  `uvm_component_utils(step_rf_ctrl_env)

  // Components
  step_rf_ctrl_driver driver;
  uvm_sequencer #(step_rf_cfg_metadata_item) sequencer;
  step_rf_ctrl_monitor monitor;
  step_rf_ctrl_scoreboard scoreboard;
  step_rf_ctrl_coverage coverage;


  function new(string name = "step_rf_ctrl_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    driver = step_rf_ctrl_driver::type_id::create("driver", this);
    sequencer = uvm_sequencer#(step_rf_cfg_metadata_item)::type_id::create("sequencer", this);
    monitor = step_rf_ctrl_monitor::type_id::create("monitor", this);
    scoreboard = step_rf_ctrl_scoreboard::type_id::create("scoreboard", this);
    coverage = step_rf_ctrl_coverage::type_id::create("coverage", this);
  endfunction


  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    driver.seq_item_port.connect(sequencer.seq_item_export);
    monitor.item_collected_port.connect(scoreboard.dut_export);
    monitor.item_collected_port.connect(coverage.analysis_export);
  endfunction

endclass : step_rf_ctrl_env