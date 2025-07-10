module fifo_sync(input clk,rst,wen,ren,input [31:0]data_in,output reg [31:0]data_out,output full,empty);
  
  reg [31:0] mem [7:0];
  reg [3:0] wptr; //write pointer
  reg [3:0] rptr; //read pointer

//   write operation
  always @(posedge clk) begin
    if(rst)
      wptr <= 0;
    else if(wen && ~full) begin
      mem[wptr[2:0]] <= data_in;
      wptr <= wptr + 1;
      data_out <=0;
    end 
  end
  
//   read operation
  always @(posedge clk) begin
    if(rst)
      rptr <= 0;
    else if(ren && ~empty) begin
      data_out <= mem[rptr[2:0]];
      rptr <= rptr + 1;
    end
  end
  
  
//   full and empty logic
  
  assign full  = ({~wptr[3], wptr[2:0]} == rptr);
  assign empty = (wptr == rptr);
  
  

endmodule