# RTL Design of Synchronous FIFO

Introduction:

This project focuses on designing a synchronous FIFO (First-In-First-Out) buffer using RTL, aimed at efficient data communication in high-speed digital systems. The primary challenge lies in synchronizing data transfer between clock domains while maintaining reliability and preventing data loss. Traditional FIFO designs often struggle with managing read and write operations effectively in synchronous environments. The proposed design introduces a token parallel synchronizer ring mechanism to handle read/write enable signals, along with a robust data storage and status detection architecture. Objectives include developing a configurable, low-latency FIFO with precise depth control, enhanced throughput, and reliable detection of full and empty conditions to meet diverse application needs.

Literature Review:

The design of synchronous FIFOs has been extensively explored for high-performance digital systems requiring efficient data transfer and synchronization across mixed clock domains. Pulse-based asynchronous handshake protocols like the AsP protocol (Tarik Ono, Mark Greenstreet) have proven effective for seamless interfacing, providing robust synchronization in Network-on-Chip (NoC) systems. Enhancements such as almost full and almost empty flags optimize data flow control, reducing latency and minimizing overflow/underflow risks (David Wylan).

Optimization of FIFO performance through RTL design and synthesis (e.g., Qflow, Cadence Encounter) has revealed significant trade-offs in area, speed, and power. Hemant Kaushal and Tushar Puri demonstrated FPGA-specific optimizations like dual-port RAM for data storage, showing improved data throughput and reduced latency. Pausible bisynchronous FIFOs (Ben Keller et al.) are key for GALS systems, using delay lines, Muller C-elements, and mutex circuits to minimize metastability and synchronize data transfer between mismatched clock domains.

Distributed synchronization using token rings and micropipelines is highly effective in managing data flow across mixed timing domains. Components like put and get rings (shift registers) and OR/AND gates for control logic enable scalable depth and width expansion. Ivan Miro Panades and Alain Greiner’s bi-synchronous FIFOs emphasize one-hot encoding for pointers, enhancing metastability handling and increasing transfer reliability. Master-slave FIFO configurations improve depth and width expandability, where the master controls full/empty signals, enabling scalable operation for various requirements (Xin Wang, Jari Nurmi).

Micropipeline control blocks and token-passing mechanisms further enhance synchronization, employing C-element chains and arbiter designs for metastability mitigation. Two-phase request-acknowledge protocols maintain high throughput despite clock mismatches. Advanced control techniques like pausible clocking reduce latency in bisynchronous FIFOs, integrating features like full detectors, latches for data storage, and multi-phase interfaces to enhance performance. This modular architecture is instrumental for complex, high-speed digital communication systems, ensuring low-latency and reliable data transfer across diverse timing domains.

Proposed Design Version 1:

1\. Clock Domain:  
The FIFO uses a single clock (clk) for both read and write operations, making it a synchronous FIFO suitable for scenarios where read and write occur at the same clock frequency.

2\. Parameterization:  
The FIFO is parameterized by depth (number of entries) and width (bit-width of each entry), allowing the design to be flexible and scalable for different applications.

3\. Data Storage:  
An internal memory array (data) stores the input data. The size of this array is defined by the depth and width parameters.

4\. Pointers:  
Two pointers, write\_pointer and read\_pointer, are used to keep track of the current write and read positions in the FIFO buffer.  
The pointers wrap around when they reach the end (depth), implementing a circular buffer.

5\. Status Flags:  
Full Flag (full1): Indicates when the FIFO is full, i.e., when the write\_pointer reaches depth while the read\_pointer is at the starting position.  
Empty Flag (empty1): Indicates when the FIFO is empty, i.e., when the read\_pointer reaches depth while the write\_pointer is at the initial position.

6\. Write Operation:  
Data is written to the FIFO when the write signal is high and the FIFO is not full. The write\_pointer is incremented after each successful write.  
7\. Read Operation:  
Data is read from the FIFO when the read signal is high and the FIFO is not empty. The read\_pointer is incremented after each successful read, and the read data is output through dataout.

8\. Circular Buffer Behavior:  
The use of modulo depth incrementing for pointers ensures efficient circular buffer behavior, preventing overflow or underflow errors in data access.

9\. Adaptability:  
The design's parameterization and synchronous nature make it suitable for use in various high-speed, low-latency applications where FIFO buffers are needed for temporary data storage between producer and consumer processes.

Proposed Design Version 2:

1\. Token Ring Mechanism  
![][image1]![][image2]

\- Token Ring (Figure 1 & Figure 2): The token ring structure consists of multiple flip-flops connected in a circular fashion, with enable signals driven by the clock. It forms a shift register-based mechanism to pass the token, which controls access to the FIFO's write or read operations. This setup ensures only one writer or reader accesses the FIFO at a time, mitigating contention issues.  
\- Parallel Synchronizer: It combines multiple token rings in a parallel configuration to synchronize data and control signals effectively. The parallel synchronizer ensures reliable data transfer between the clock domains by minimizing metastability risks.

2\. Bi-Synchronous FIFO Architecture (Figure 5\)  
\- Control Logic: The bi-synchronous FIFO utilizes separate write and read pointers to track the positions for writing and reading data, respectively. It incorporates full and empty detectors to manage flow control and prevent overflow or underflow conditions.  
\- Full and Empty Detectors (Figure 8): The detectors utilize combinational logic with AND/OR gates to signal when the FIFO is full or empty, based on the comparison of the write and read pointers. This approach enhances synchronization between the asynchronous and synchronous clock domains.

![][image3]![][image4]

3\. Write Pointer, Read Pointer, and Data Buffer Modules (Figure 7\)  
\- Write Pointer Module: The write pointer module, driven by the write clock, updates its value only when the FIFO is not full. The token ring controls the enable signal, ensuring synchronized incrementing of the write pointer. The module uses flip-flops or latches to store the pointer states, enabling precise control over write operations.  
\- Read Pointer Module: The read pointer module operates similarly, driven by the read clock. It synchronizes read operations using the token ring mechanism, enabling the read pointer only when the FIFO is not empty.  
\- Data Buffer: The data buffer consists of flip-flops or dual-port RAM cells, where data is written at the address specified by the write pointer and read from the address indicated by the read pointer. The separation of write and read clock domains in the data buffer allows independent control, enhancing the FIFO's performance in mixed-timing environments.  
![][image5]  
4\. Synchronization and Control Logic  
\- Synchronization of Token Rings: The synchronization between write and read operations is facilitated by the token ring's enable signals, derived from the clock domains. It effectively handles the phase differences between clock domains, reducing latency and ensuring reliable data transfer.  
\- Arbiter Design: The design includes an arbiter that manages access requests, ensuring that write and read operations are executed in an orderly fashion without causing data corruption.

Version 2: Technical Design 

1\. Synchronous FIFO Module (synchronous\_fifo)

- Purpose: Manages the main FIFO operations, such as data read/write, and integrates sub-modules for token rings, data storage, and status detection (full/empty).  
- Inputs:  
  - clk\_write, clk\_read: Separate clock signals for writing and reading.  
  - write, read: Control signals for enabling write/read operations.  
  - datain: Input data for writing.  
- Outputs:  
  - dataout: Output data from the FIFO.  
  - full1, empty1: Indicate if FIFO is full or empty.  
  - err: Error flag for invalid read/write attempts when FIFO is full/empty.  
- Key Features:  
  - Token Ring Integration: Uses token\_rings modules for write and read synchronization.  
  - Error Handling: err flag is set when invalid read/write operations are detected.  
  - Pointer Logic: Generates pointers (write\_pointer and read\_pointer) to track data indices.

2\. Token Rings Module (token\_rings)

- Purpose: Implements a token ring mechanism to cycle through write/read operations, ensuring ordered access.  
- Parameters: Configurable parameter N defines the bit-width.  
- Key Operations:  
  - Data Shifting: Rotates the input data using a shift register, where the most significant bit is wrapped to the least significant bit.  
  - Enable Control: Data shifting occurs only if en (enable) is asserted.

3\. Data Storage Module (data\_storage)

- Purpose: Manages the physical storage of data during write and read operations, handling different clock domains.  
- Inputs:  
  - clk\_write, clk\_read: Clocks for writing and reading data.  
  - flag: Indicates the mode (write \= 0, read \= 1).  
  - datain, dataout: Handles input data for writing and output data for reading.  
  - write\_pointer, read\_pointer: Pointers indicating the current index for read/write.  
- Key Features:  
  - Data Write: Updates the storage with input data at the location specified by write\_pointer.  
  - Data Read: Retrieves the data from the location indicated by read\_pointer.

4\. Full Detector Module (FullDetector)

- Purpose: Detects the 'full' condition of the FIFO using synchronized pointers.  
- Inputs:  
  - write\_pointer, read\_pointer: Pointers for write and read positions.  
  - clk\_write: Clock signal for the write domain.  
- Key Operations:  
- Pointer Synchronization: Synchronizes the read\_pointer using a dual-flip-flop mechanism to mitigate metastability.  
- Full Condition Check: Checks if the write pointer has reached the maximum depth while the read pointer is at the initial position, indicating FIFO is full.

5\. Empty Detector Module (empty\_detector)

- Purpose: Detects the 'empty' condition of the FIFO using synchronized pointers.  
- Inputs:  
  - write\_pointer, read\_pointer: Pointers for write and read positions.  
  - clk\_read: Clock signal for the read domain.  
- Key Operations:  
  - Pointer Synchronization: Synchronizes the write\_pointer using a dual-flip-flop mechanism in the read domain.  
  - Empty Condition Check: Detects if both pointers are at the initial position, indicating FIFO is empty.

Elaborated Design Schematic:  
Version 1:  
![][image6]

Version 2:  
![][image7]

Simulation Waveform:  
![][image8]

Timing Reports:  
![][image9]  
Utilisation Reports:  
![][image10]

References:

- Synthesizable Synchronisation FIFOs utilising the asynchronous pulse-based handshake protocol  
- A Modular Synchronizing FIFO for NoCs Tarik Ono Mark Greenstreet (asp protocol in detail)  
- Performance Analysis of RTL to GDS-II Flow in Opensource Tool Qflow and Commercial Tool Cadence Encounter for Synchronous FIFO (for complete design flow)  
- New Features in Synchronous FIFOS David Wylan  
- Design of RTL Synthesizable 32-Bit FIFO Memory  
- Designing of 8-bit Synchronous FIFO Memory using Register File   
- Design of Synthesizable Asynchronous FIFO And Implementation on FPGA Hemant Kaushal, Tushar Puri (for FPGA based module differentiation)  
- A RTL Asynchronous FIFO Design Using Modified Micropipeline Xin Wang, Jari Nurmi   
- Bi-Synchronous FIFO for Synchronous Circuit Communication Well Suited for Network-on-Chip in GALS Architectures Ivan MIRO PANADES Alain GREINER  
- A Pausible Bisynchronous FIFO for GALS Systems Ben Keller, Matthew Fojtik
