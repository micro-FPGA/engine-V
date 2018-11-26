#!/usr/bin/env python3

import fileinput

print("module ROM512K16 (clk, addr, dout);")
print("input clk;")
print("input [8:0] addr;")
print("output [15:0] dout;")

print("reg [15:0] dout; ")
print("reg [8:0] addr_r; ")
print("")
print("always @(posedge clk)  begin : process_clk  addr_r <= addr; end")
print("")
print("always @(addr_r) begin : process case (addr_r)")

print("")

i = 0
for line in fileinput.input():
        print(" ",i, ": begin dout <= 16'h %s; end" % line.strip() )
        i = i + 1	

print(" default: begin dout <= 16'h xxxx; end")
print("endcase")
print("end")   

print("")
print("endmodule")