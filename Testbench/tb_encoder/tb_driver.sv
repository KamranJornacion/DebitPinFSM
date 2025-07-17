class encoder_driver extends uvm_driver #(encoder_transaction);
  
  `uvm_component_utils(encoder_driver)
  
  function new (string name ="encoder_driver", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  //declare virtual interface ahndle and get in build phase
  virtual encoder_if encoder_vi;
  
  encoder_transaction req;
  
  function void build_phase(uvm_phase phase);
    if( !uvm_config_db #(virtual encoder_if)::get(this,"","encoder_if",encoder_vi))
      `uvm_error("","uvm_config::get failed")
      endfunction
  
  //code the run phase   
      task run_phase(uvm_phase phase);
    	forever begin
          seq_item_port.get_next_item(req);
          encoder_vi.in <= req.in;
          //#1;
          seq_item_port.item_done();
        end
    endtask
endclass