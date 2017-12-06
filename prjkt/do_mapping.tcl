# Step 1:  Read in the source file
analyze -format sverilog -lib WORK {n_bitmultiplier.sv full_adder.sv matrixgenerator.sv}
elaborate matrixgenerator -lib WORK
uniquify

# Step 2: Set design constraints
# Uncomment below to set timing, area, power, etc. constraints
# set_max_delay <delay> -from "<input>" -to "<output>"
# set_max_area <area>
# set_max_total_power <power> mW


# Step 3: Compile the design
compile -map_effort medium

# Step 4: Output reports
report_timing -path full -delay max -max_paths 1 -nworst 1 > reports/matrixgenerator.rep
report_area >> reports/matrixgenerator.rep
report_power -hier >> reports/matrixgenerator.rep

# Step 5: Output final VHDL and Verilog files
write_file -format verilog -hierarchy -output "mapped/matrixgenerator.v"

# Second Compilation Run. Repeat Steps 2-5
# Step 2: Put the max delay constraints in the second pass only.
#set_max_delay 6 -from "b[0]" -to "sum[15]"

# Step 3: Compile the design
#set_structure true -design matrixgenerator -boolean true -boolean_effort medium
#compile -map_effort high

# Step 4: Output reports
#report_timing -path full -delay max -max_paths 1 -nworst 1 > reports/matrixgenerator_1.rep
#report_area >> reports/matrixgenerator_1.rep
#report_power -hier >> reports/matrixgenerator_1.rep

# Step 5: Output final VHDL and Verilog files
#write_file -format verilog -hierarchy -output "mapped/matrixgenerator_1.v"

echo "\nScript Done\n"
echo "\nChecking Design\n"
check_design
quit
