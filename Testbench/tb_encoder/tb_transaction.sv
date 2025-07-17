class encoder_transaction extends uvm_sequence_item;
  //Constructor/initalize
  `uvm_object_utils(encoder_transaction)
  
  function new(string name ="encoder_transaction");
    super.new(name);
  endfunction
  
  //Fields
  rand logic [3:0] in;
  logic [3:0] out;
  
  //Constraints
  constraint c_in {in inside {[0:15]}; };
  
  //Method Overwrites
  
  function string convert2string();
    return $sformatf("in=%b, out=%b", in, out);
  endfunction
  
  function bit do_compare(uvm_object rhs, uvm_comparer comparer);   
    bit status =1;
    encoder_transaction tx;
    $cast(tx, rhs);
    //bit status = 1;
    status &= (in == tx.in);
    return status;
  endfunction
  
  function void do_copy(uvm_object rhs);
    encoder_transaction tx;
    $cast(tx, rhs);
    in = tx.in;
    out = tx.out;
  endfunction
  
endclass
  