
module fifo #(
    parameter data_width = 8,
    parameter depth      = 16,
    parameter add_width  = 4
)(
    input  logic                  clk,
    input  logic                  reset,
    input  logic                  wr_en,
    input  logic                  rd_en,
    input  logic [data_width-1:0] data_in,

    output logic [data_width-1:0] data_out,
    output logic                  full,
    output logic                  empty
);

    logic [data_width-1:0] mem [0:depth-1];

    logic [add_width-1:0] wr_ptr;
    logic [add_width-1:0] rd_ptr;

    logic [add_width:0] count;

    assign full  = (count == depth);
    assign empty = (count == 0);


    always_ff @(posedge clk) begin

        if (reset) begin

            wr_ptr   <= 0;
            rd_ptr   <= 0;
            count    <= 0;
            data_out <= 0;

        end

        else begin

            // WRITE
            if (wr_en && !full) begin

                mem[wr_ptr] <= data_in;

                if (wr_ptr == depth-1)
                    wr_ptr <= 0;
                else
                    wr_ptr <= wr_ptr + 1'b1;

            end


            // READ
            if (rd_en && !empty) begin

                data_out <= mem[rd_ptr];

                if (rd_ptr == depth-1)
                    rd_ptr <= 0;
                else
                    rd_ptr <= rd_ptr + 1'b1;

            end


            // COUNT
            case ({wr_en && !full, rd_en && !empty})

                2'b10: count <= count + 1'b1;

                2'b01: count <= count - 1'b1;

                default: count <= count;

            endcase

        end

    end

endmodule


