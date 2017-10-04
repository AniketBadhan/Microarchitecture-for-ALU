# Microarchitecture-for-ALU
Microarchitecture for ALU

Implemented a microprogrammed controller with a datapath. The datapath includes an ALU with shifter unit, a register file with 8 entries, an accumulator, and an input port.

The microinstruction word contains the information for the datapath as well as the microprogrammed controller. The design uses horizontal as vertical encoding. Each module is controlled independantly. Submodules within the machine use vertical encoding. 

The design completes a single instruction per clock cycle.

The implementation is tested for a code to find the number of ones in the input.
