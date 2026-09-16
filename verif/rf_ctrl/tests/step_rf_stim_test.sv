`ifndef STEP_RF_STIM_TEST_SV
`define STEP_RF_STIM_TEST_SV

class step_rf_stim_test extends step_rf_base_test;
  `uvm_component_utils(step_rf_stim_test)

  function new(string name = "step_rf_stim_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    step_rf_stim_seq seq;
    seq = step_rf_stim_seq::type_id::create("seq");

    phase.raise_objection(this);

    `uvm_info(get_type_name(), "=== Starting Stimulus File Test ===", UVM_LOW)

    // Run the file-reading sequence on the agent's sequencer
    seq.start(m_env.m_agent.m_sequencer);

    // wait a few cycles so the last transactions clear the DUT
    #100ns;

    `uvm_info(get_type_name(), "Stimulus File Test Complete", UVM_LOW)

    phase.drop_objection(this);

  endtask

endclass
