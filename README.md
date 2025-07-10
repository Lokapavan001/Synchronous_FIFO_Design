# Synchronous FIFO (Verilog)

This is a simple, fully synchronous FIFO (First-In, First-Out) buffer implemented in Verilog. It supports concurrent read/write operations and includes basic `full` and `empty` status signals. Ideal for small hardware buffers within a shared clock domain.

## 📄 Module: `fifo_sync`

###  Features

- 8-entry deep FIFO with 32-bit data width
- Synchronous read/write operations
- `full` and `empty` flags
- Automatically resets pointers on reset
- Easy to simulate and integrate in FPGA designs

---

###  Inputs

| Name     | Width  | Description             |
|----------|--------|-------------------------|
| `clk`    | 1 bit  | Clock signal            |
| `rst`    | 1 bit  | Active-high reset       |
| `wen`    | 1 bit  | Write enable            |
| `ren`    | 1 bit  | Read enable             |
| `data_in`| 32 bit | Input data to be written|

###  Outputs

| Name       | Width  | Description                  |
|------------|--------|------------------------------|
| `data_out` | 32 bit | Data output from FIFO        |
| `full`     | 1 bit  | High when FIFO is full       |
| `empty`    | 1 bit  | High when FIFO is empty      |

---

##  Internal Design

- **Memory Depth**: 8 entries (`mem[7:0]`)
- **Data Width**: 32 bits
- **Write Pointer (`wptr`)**: 4 bits (upper bit used for full detection)
- **Read Pointer (`rptr`)**: 4 bits
- **Full Condition**: When write pointer is one cycle ahead of read pointer with MSB inverted
- **Empty Condition**: When both pointers are equal

---

##  Example Behavior

- **Write**: Data is written to `mem[wptr[2:0]]` if `wen` is high and FIFO is not full.
- **Read**: Data is read from `mem[rptr[2:0]]` if `ren` is high and FIFO is not empty.
- **Reset**: Resets both `wptr` and `rptr` to 0.

---

##  Simulation Tips

Use a testbench to verify:

- Write/read at normal speed
- Overflow/underflow protection
- Proper reset behavior

Example waveforms:
- `data_out` should only change on successful reads.
- `full` should assert after 8 successful writes without reads.
- `empty` should assert after reset or all entries are read.

---

##  Integration Example

```verilog
fifo_sync u_fifo (
  .clk(clk),
  .rst(rst),
  .wen(wen),
  .ren(ren),
  .data_in(data_in),
  .data_out(data_out),
  .full(full),
  .empty(empty)
);
