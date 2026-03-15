    .data
    .type a, %object
    .size a, 80                  // 10 elements * 8 bytes each = 80 bytes
a:
    .xword 79, 55, 94, 48, 19, 13, 45, 2, 3, 99  // Array of 10 elements

    .type n, %object
    .size n, 8
n:
    .xword 10                    // Number of elements

    .text
    .global main
    .arch armv8-a+fp+simd
    .type main, %function

main:
    ADRP    X15, a
    ADD     X15, X15, :lo12:a    // X15 points to array a

    ADRP    X1, n
    ADD     X1, X1, :lo12:n
    LDUR    X3, [X1, #0]         // X3 = end = 10

    MOV     X2, #0               // X2 = start = 0

loop:
    CMP     X2, X3               // while (start < end)
    B.GE    done                 // If start >= end, exit loop

    // Find the index of the smallest element from start to end
    MOV     X0, X15              // Base address of array
    MOV     X1, X2               // Start index
    MOV     X6, X3               // End index
    BL      findSmallest          // Call findSmallest
    MOV     X4, X0               // Store smallest index in X4

    // Swap a[start] with a[smallest index]
    MOV     X0, X15              // Base address of array
    MOV     X5, X2               // start index
    BL      swap                 // Call swap function

    ADD     X2, X2, #1           // start++

    // Find the index of the largest element from start to end
    MOV     X0, X15              // Base address of array
    MOV     X1, X2               // Start index
    MOV     X6, X3               // End index
    BL      findLargest           // Call findLargest
    MOV     X5, X0               // Store largest index in X5

    // Swap a[end] with a[largest index]
    MOV     X0, X15              // Base address of array
    SUB     X3, X3, #1           // end--
    BL      swap                 // Call swap function

    B       loop                 // Repeat loop

done:
    MOV     X0, #0               // Return 0 from main
    RET

// Function: findSmallest
// Arguments:
//   X0 - Base address of array
//   X1 - Start index
//   X6 - End index
// Returns:
//   X0 - Index of smallest element
findSmallest:
    LSL     X9, X1, #3           // Compute offset (start * 8)
    ADD     X9, X0, X9           // Address of a[start]
    LDUR    X10, [X9, #0]        // X10 = a[start]
    MOV     X4, X1               // Smallest index = start

    ADD     X1, X1, #1           // Move to next index

findSmallest_loop:
    CMP     X1, X6               // If start >= end, return
    B.GE    findSmallest_done

    LSL     X9, X1, #3           // Compute offset (i * 8)
    ADD     X9, X0, X9           // Address of a[i]
    LDUR    X11, [X9, #0]        // X11 = a[i]

    CMP     X11, X10             // Compare a[i] with smallest
    B.GE    findSmallest_next    // If not smaller, skip update

    MOV     X10, X11             // Update smallest value
    MOV     X4, X1               // Update smallest index

findSmallest_next:
    ADD     X1, X1, #1           // i++
    B       findSmallest_loop

findSmallest_done:
    MOV     X0, X4               // Return smallest index
    RET

// Function: findLargest
// Arguments:
//   X0 - Base address of array
//   X1 - Start index
//   X6 - End index
// Returns:
//   X0 - Index of largest element
findLargest:
    LSL     X9, X1, #3           // Compute offset (start * 8)
    ADD     X9, X0, X9           // Address of a[start]
    LDUR    X11, [X9, #0]        // X11 = a[start]
    MOV     X5, X1               // Largest index = start

    ADD     X1, X1, #1           // Move to next index

findLargest_loop:
    CMP     X1, X6               // If start >= end, return
    B.GE    findLargest_done

    LSL     X9, X1, #3           // Compute offset (i * 8)
    ADD     X9, X0, X9           // Address of a[i]
    LDUR    X10, [X9, #0]        // X10 = a[i]

    CMP     X10, X11             // Compare a[i] with largest
    B.LE    findLargest_next    // If not larger, skip update

    MOV     X11, X10             // Update largest value
    MOV     X5, X1               // Update largest index

findLargest_next:
    ADD     X1, X1, #1           // i++
    B       findLargest_loop

findLargest_done:
    MOV     X0, X5               // Return largest index
    RET

// Function: swap
// Arguments:
//   X0 - Base address of array
//   X4 - Index i
//   X5 - Index j
swap:
    SUB  SP, SP, #32          // Save registers
    STUR X9,  [SP, #24]
    STUR X10, [SP, #16]
    STUR X11, [SP, #8]
    STUR X12, [SP, #0]

    LSL X9, X4, #3
    ADD X9, X9, X0           // Address of a[i]
    LDUR X10, [X9, #0]       // Load a[i]

    LSL X11, X5, #3
    ADD X11, X11, X0         // Address of a[j]
    LDUR X12, [X11, #0]      // Load a[j]

    STUR X12, [X9, #0]       // Store a[i] at a[j]
    STUR X10, [X11, #0]      // Store a[j] at a[i]

    LDUR X12, [SP, #0]       // Restore registers
    LDUR X11, [SP, #8]
    LDUR X10, [SP, #16]
    LDUR X9,  [SP, #24]
    ADD  SP, SP, #32
    BR  X30
