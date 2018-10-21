`timescale 1ns/1ps
`include "uvm_macros.svh"

import uvm_pkg::*;
`include "my_if.sv"
`include "my_transaction.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "my_model.sv"
`include "my_scoreboard.sv"
`include "my_env.sv"
`include "base_test.sv"
`include "my_case0.sv"
class father;
    string m_name;
    function new(string name);
        m_name = name;
    endfunction: new

    function void print();
        $display("Hello ================= %s", m_name);
    endfunction
endclass: father

class child0 extends father;
    string car = "car";
    function new(string name);
        super.new(name);
    endfunction
endclass

class child1 extends father;
    string plane = "plane";
    function new(string name);
        super.new(name);
    endfunction
endclass

module top_tb;

    father f;
    child0 c0;
    child0 c2;
    child1 c1;

reg clk;
reg rst_n;
reg[7:0] rxd;
reg rx_dv;
wire[7:0] txd;
wire tx_en;

my_if input_if(clk, rst_n);
my_if output_if(clk, rst_n);

dut my_dut(.clk(clk),
           .rst_n(rst_n),
           .rxd(input_if.data),
           .rx_dv(input_if.valid),
           .txd(output_if.data),
           .tx_en(output_if.valid));

initial begin
   clk = 0;
   forever begin
      #100 clk = ~clk;
   end
end

initial begin
   rst_n = 1'b0;
   #1000;
   rst_n = 1'b1;
end

initial begin
   run_test();
end

initial begin
    $vcdpluson();
end

initial begin
    f = new("father");
    c0 = new("child0"); // child 0 type
    c1 = new("child1"); // child 1 type
    c2 = new("child2"); // child 0 type
    f.print();
    f = c0;
    f.print;
    f = c1;
    f.print;
    f = c2;
    if($cast(c0,f)) begin
        $display("down cast success");
    end
    //c0.m_name = "";
    c0 = new(f.m_name);
    c2.m_name = "trunk";
    $display("father m_name is %s", c0.m_name);
    c2.m_name = "bike";
    $display("father m_name is %s", c0.m_name);

end

initial begin
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", input_if);
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", input_if);
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.o_agt.mon", "vif", output_if);
end

endmodule
