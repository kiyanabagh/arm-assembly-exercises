.data                        // Data section
    v:      .quad   -112, 17, 29, 2, 79, 55, 94, 0    // Array of integers
    n:      .quad   8                                  // Length of array
    sum:    .quad   0                                  // Variable to store sum
    max:    .quad   0                                  // Variable to store largest
    min:    .quad   0                                  // Variable to store smallest

.text                      // Program section
.global main               // Main function
.arch armv8-a              // Correct ARMv8-A architecture
.type main, %function      // Define main function

main:
    ADRP X13, v             // Load base address of array
    ADD  X13, X13, :lo12:v
    ADRP X14, n             // Load base address of size
    ADD  X14, X14, :lo12:n
    LDUR X14, [X14, #0]      // Load n (array length)

    LDUR X10, [X13, #0]      // sum = v[0]
    LDUR X11, [X13, #0]      // largest = v[0]
    LDUR X12, [X13, #0]      // smallest = v[0]
    ADD  X15, X13, #8        // Set pointer to v[1]
    SUB  X14, X14, #1        // Decrease count (since first element is processed)

loop:
    CMP  X14, #0             // Check if there are more elements
    B.LE Exit                // If no more elements, exit loop

    LDUR X9, [X15, #0]       // Load next element into X9
    ADD  X10, X10, X9        // sum += v[i]

    CMP  X11, X9             // Compare largest with v[i]
    B.GE check_smallest      // If largest >= v[i], check smallest
    MOV  X11, X9             // Update largest

check_smallest:
    CMP  X12, X9             // Compare smallest with v[i]
    B.LE continue_loop       // If smallest <= v[i], continue loop
    MOV  X12, X9             // Update smallest

continue_loop:
    ADD  X15, X15, #8        // Move to the next element
    SUB  X14, X14, #1        // Decrease count
    B    loop                // Repeat loop

Exit:
    // Store results
    ADRP X16, sum
    ADD  X16, X16, :lo12:sum
    STUR X10, [X16, #0]      // Store sum

    ADRP X16, max
    ADD  X16, X16, :lo12:max
    STUR X11, [X16, #0]      // Store largest

    ADRP X16, min
    ADD  X16, X16, :lo12:min
    STUR X12, [X16, #0]      // Store smallest

    NOP                      // End of program
