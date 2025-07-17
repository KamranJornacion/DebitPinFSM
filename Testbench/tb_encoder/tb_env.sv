class encoder_env extends uvm_env;
  
  
  `uvm_component_utils(encoder_env)
  
  function new(string name ="encoder_env", uvm_component parent = null);
    
    super.new(name,parent);
  endfunction
  
  //Declare verification components, agents, config,etc
  encoder_driver m_driver;
  encoder_monitor m_monitor;
  encoder_sequencer m_sequencer;
  
  //Build components in build phase
  function void build_phase(uvm_phase phase);
    m_driver = encoder_driver::type_id::create("m_driver",this);
    m_monitor = encoder_monitor::type_id::create("m_monitor",this);
    m_sequencer = encoder_sequencer::type_id::create("m_sequencer",this);
  endfunction
  
  //Connect components phase
  function void connect_phase(uvm_phase phase);
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    
  endfunction
  
endclass