# ARM Assembly Exercises

Low-level programs written in ARMv8-A assembly (GAS syntax) targeting Linux ARM64.
These were written as part of coursework at the University of North Texas to build
familiarity with registers, memory addressing, and subroutine conventions at the
instruction level.

## Files

### sort_array.S
Sorts a 10-element array of 64-bit integers using a two-ended selection sort.
Each pass locates the smallest element from the front and the largest from the back,
placing them at opposite ends simultaneously. Logic is split into three subroutines:

- `findSmallest` — scans a range and returns the index of the minimum element
- `findLargest` — scans a range and returns the index of the maximum element
- `swap` — exchanges two elements by index, with proper register save/restore via the stack

### sum_max_min.S
Performs a single linear pass over an 8-element array of 64-bit integers to compute
the sum, maximum, and minimum values. Results are written back to labeled memory
locations.

## Environment

- Architecture: ARMv8-A (AArch64)
- Assembler: GNU Assembler (GAS)
- Target OS: Linux ARM64

## How to Build and Run
```bash
as -o sort_array.o sort_array.S
ld -o sort_array sort_array.o
./sort_array

as -o sum_max_min.o sum_max_min.S
ld -o sum_max_min sum_max_min.o
./sum_max_min
```

Requires an ARM64 machine or emulator (e.g., QEMU with an ARM64 Linux image).
