`ifndef STEP_RF_RANDOM_TEST_SV
`define STEP_RF_RANDOM_TEST_SV

class step_rf_random_test extends step_rf_base_test;
  `uvm_component_utils(step_rf_random_test)

  function new(string name = "step_rf_random_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    step_rf_random_seq seq;
    seq = step_rf_random_seq::type_id::create("seq");

    phase.raise_objection(this, "Starting step_rf_random_seq");
    
    // Start on the environment's sequencer
    seq.start(env.sequencer);

    #100ns; // Drain time for in-flight tokens
    phase.drop_objection(this, "Finished step_rf_random_seq");
  endtask

endclass

`endif