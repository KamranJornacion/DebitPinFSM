
class encoder_monitor extends uvm_monitor;
  
  `uvm_component_utils(encoder_monitor)
  
  function new (string name ="encoder_monitor", uvm_component parent = null);
    
    super.new(name,parent);
  endfunction
  
  //declare analysis ports and virtual interface handles
  virtual encoder_if encoder_vi;
  
  uvm_analysis_port #(encoder_transaction) ap;
  
  //build uvm monitor phase
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual encoder_if)::get(this, "","encoder_if",encoder_vi))
      `uvm_error("MON","config_db::get failed")
      ap = new("ap",this);
   endfunction
      
  //code the run phase
  task run_phase(uvm_phase phase);
    	encoder_transaction tx;
    forever begin
      @(encoder_vi.in or encoder_vi.out);
      
      //#1;
      tx = encoder_transaction::type_id::create("tx");
      
      tx.in= encoder_vi.in;
      tx.out=encoder_vi.out;
      
      
      `uvm_info("MON", $sformatf("Captured: in = %0b, out = %0b", tx.in, tx.out), UVM_MEDIUM)
      ap.write(tx);
    end
    endtask
  
endclass