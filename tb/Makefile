
simulate:
	iverilog -s tb -o tb -c file_list.txt
	vvp tb

waves:
	
	iverilog -s tb -o tb -c file_list.txt
	vvp tb
	gtkwave my_dumpfile.vcd &

clean:
	rm tb *.vcd
