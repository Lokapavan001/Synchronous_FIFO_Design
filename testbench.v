module tb;
  reg clk,rst,wen,ren;
  reg[31:0]data_in;
  wire [31:0]data_out;
  wire full,empty;
  
  fifo_sync dut(clk,rst,wen,ren,data_in,data_out,full,empty);
  initial clk=0;
  always #5 clk=~clk;
   
  //reset task
  task reset_fifo;
    begin
      rst = 1;
      wen = 0;
      ren = 0;
      #(2*10);
      rst = 0;
    end
  endtask
  
  // Write task
  task write_fifo(input [31:0] data);
    begin
      @(posedge clk);
      if (!full) begin
        wen = 1;
        data_in = data;
        $display("%0t: write data = %0d", $time, data);
       @(posedge clk);
        wen = 0;
      end else begin
        $display("%0t: FIFO FULL - Can't write %0d", $time, data);
      end
    end
  endtask

  // Read task
  task read_fifo;
    begin
      @(posedge clk);
      if (!empty) begin
        ren = 1;
        @(posedge clk);
        $display("%0t: Read data = %0d", $time, data_out);
        ren = 0;
      end else begin
        $display("%0t: FIFO EMPTY - Can't read", $time);
      end
    end
  endtask
  
   initial begin
    $display("Starting FIFO test...");
    reset_fifo();

    // Fill FIFO
     repeat (8) begin
      write_fifo($random);
    end

    // Try overflow
    write_fifo(32'hCAFEBABE);

    // Empty FIFO
     repeat (8) begin
      read_fifo();
    end

    // Try underflow
    read_fifo();

    $display("FIFO test completed.");
    $finish;
  end
endmodule
    
   
    
    