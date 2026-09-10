`ifndef STEP_RF_RANDOM_SEQ_SV
`define STEP_RF_RANDOM_SEQ_SV

class step_rf_random_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(step_rf_random_seq)

  rand int loop_count;

  constraint c_loop_count {
    loop_count inside {[10:30]};
  }

  function new(string name = "step_rf_random_seq");
    super.new(name);
  endfunction

  virtual task body();
    step_tokenizer_cfg_item tok_item;
    step_rf_data_item data_item;

    `uvm_info(get_type_name(), $sformatf("Starting random sequence with %0d transactions", loop_count), UVM_LOW)

    for (int i = 0; i < loop_count; i++) begin

      // 1. Send Tokenizer Configuration Item
      tok_item = step_tokenizer_cfg_item::type_id::create("tok_item");
      
      start_item(tok_item);
      if (!tok_item.randomize()) begin
        `uvm_fatal("RND_FAIL", "Failed to randomize tok_item")
      end
      finish_item(tok_item);


      // 2. Send RF Data Item
      data_item = step_rf_data_item::type_id::create("data_item");
      
      start_item(data_item);
      if (!data_item.randomize()) begin
        `uvm_fatal("RND_FAIL", "Failed to randomize data_item")
      end
      finish_item(data_item);
      
    end
  endtask

endclass

`endif