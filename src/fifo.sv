

`timescale 1ns/1ns

module fifo #(
   parameter DATA_WIDTH = 16,
   parameter DATA_DEPTH = 8
   )(
   // Clock and reset
   input logic clk_i,
   input logic rst_i,

   // Enables
   input logic wr_en_i,
   input logic rd_en_i,

   input logic [DATA_WIDTH-1:0]write_data_i,
   input logic [DATA_WIDTH-1:0]read_data_o,

   output logic empty_o,
   output logic full_o

   );

   logic [DATA_WIDTH-1:0] memory [DATA_DEPTH-1:0];

   logic [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr;


   always_ff @(posedge clk_i) begin
      if (rst_i) begin
         rd_ptr  <= 1'b0;
         wr_ptr  <= 1'b0;

            
      end else begin
         
         if (wr_en_i & !full_o) begin
            memory[wr_ptr] <= write_data_i;
            wr_ptr <= wr_ptr +1;

         end

         if (rd_en_i & !empty_o) begin
            read_data_o <= memory[rd_ptr];
            rd_ptr <= rd_ptr + 1;
         end
      end
   end

   assign full_o  = (wr_ptr + 1) == rd_ptr;
   assign empty_o = wr_ptr == rd_ptr;

endmodule 