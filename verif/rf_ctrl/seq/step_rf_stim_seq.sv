`ifndef STEP_RF_STIM_SEQ_SV
`define STEP_RF_STIM_SEQ_SV

class step_rf_stim_seq extends uvm_sequence #(step_tokenizer_cfg_item);
  `uvm_object_utils(step_rf_stim_seq)

  string filename = "stimulus.txt";

  function new(string name = "step_rf_stim_seq");
    super.new(name);
  endfunction

  virtual task body();
    int file;
    string tag;
    int cfg_id, port_id, sink_id, delay, thread_id, tile_count;
    int cur_thread = 0;
    step_tokenizer_cfg_item item;

    // Open file
    file = $fopen(filename, "r");
    if (!file) begin
      `uvm_fatal("NO_FILE", {"Cannot open the file- ", filename})
    end

    // Read word by word until end of file
    while ($fscanf(file, "%s", tag) == 1) begin
      
      // If it's a comment, skip the rest of the line
      if (tag == "#" || tag == "TYPE") begin
        void'($fgets(tag, file)); 
      end

      // Update thread ID from metadata
      else if (tag == "META") begin
        void'($fscanf(file, "%h %h %h", 
                            cfg_id, thread_id, tile_count));
        cur_thread = thread_id;
      end

      // Send a tokenizer item
      else if (tag == "TOK") begin
        void'($fscanf(file, "%h %h %h %h", 
                            cfg_id, port_id, sink_id, delay));

        item = step_tokenizer_cfg_item::type_id::create("item");
        
        start_item(item);

        item.thread_id = cur_thread;
        item.num_active_sinks = 1;
        item.sinks[0].sink_id = sink_id;
        item.sinks[0].delay_cycles = delay;
        item.post_randomize(); // pack into bits
        finish_item(item);

      end
    end

    // Close file
    $fclose(file);
  endtask

endclass

`endif