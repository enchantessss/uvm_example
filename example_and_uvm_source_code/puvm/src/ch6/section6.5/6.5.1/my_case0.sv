`ifndef MY_CASE0__SV
`define MY_CASE0__SV
class case0_sequence extends uvm_sequence #(my_transaction);
   my_transaction m_trans;

   function  new(string name= "case0_sequence");
      super.new(name);
   endfunction 
   
   virtual task body();
      if(starting_phase != null) 
         starting_phase.raise_objection(this);
      repeat (10) begin
         `uvm_do(m_trans)
         `uvm_info("sequence0", "send one transaction", UVM_MEDIUM)
      end
      #100;
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask

   `uvm_object_utils(case0_sequence)
endclass


class my_case0 extends base_test;

   function new(string name = "my_case0", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   extern virtual function void build_phase(uvm_phase phase);
   extern task main_phase(uvm_phase phase);
   `uvm_component_utils(my_case0)
endclass


function void my_case0::build_phase(uvm_phase phase);
   super.build_phase(phase);

   //uvm_config_db#(uvm_object_wrapper)::set(this, 
   //                                        "env0.i_agt.sqr.main_phase", 
   //                                        "default_sequence", 
   //                                        case0_sequence::type_id::get());
   //uvm_config_db#(uvm_object_wrapper)::set(this, 
   //                                        "env1.i_agt.sqr.main_phase", 
   //                                        "default_sequence", 
   //                                        case0_sequence::type_id::get());
endfunction

task my_case0::main_phase(uvm_phase phase);
    case0_sequence seq_inst;
    super.main_phase(phase);
    seq_inst = new("new sequence");
    seq_inst.starting_phase = phase;
    seq_inst.start(env0.i_agt.sqr);
    seq_inst.start(env1.i_agt.sqr);
endtask

`endif
