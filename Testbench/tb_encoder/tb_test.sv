class encoder_test extends uvm_test;
  //Register this test with UVM Factory
  `uvm_component_utils (encoder_test)
  
  
  //Define new function
  function new (string name = "encoder_test", uvm_component parent = null);
    
    super.new(name,parent);
  endfunction
  
  //Declare tb components (env and config)
  encoder_env m_env;
  
  //Instatiate and build components
  function void build_phase(uvm_phase phase);
    m_env = encoder_env::type_id::create("m_env",this);
  endfunction
  //MAYBE define config params
  
  //MAYBE print topology
  
  //MAYBE assign sequence
  
  //define a task for running
  task run_phase(uvm_phase phase);
    encoder_sequence seq;
    seq = encoder_sequence::type_id::create("seq");
    `uvm_info("TEST", "Sequence Instatiated", UVM_MEDIUM)
    if(!seq.randomize())
      `uvm_error("SEQ", "Seq randomize failed")
    seq.start(m_env.m_sequencer);
    `uvm_info("TEST", "Run Phase End", UVM_MEDIUM)
  endtask
endclass