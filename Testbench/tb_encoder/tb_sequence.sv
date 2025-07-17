class encoder_sequence extends uvm_sequence #(encoder_transaction);
  
  `uvm_object_utils(encoder_sequence)
  
  function new (string name = "encoder_sequence");
    super.new(name);
  endfunction
  
  task body;
    begin
      if(starting_phase!=null)
        starting_phase.raise_objection(this);
      
      repeat(10)
        begin
          `uvm_info("SEQ", "Generating test vector", UVM_LOW)
          
          req = encoder_transaction::type_id::create("req");
          start_item(req);
          if (!req.randomize())
            `uvm_error("", "Randomize failed")
          finish_item(req);
          
        end
      
      if(starting_phase!=null)
        starting_phase.drop_objection(this);
    end
      endtask;
  
  
  
endclass
