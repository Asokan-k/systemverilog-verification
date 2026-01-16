class ram_trans;

  // Randomized fields
  rand bit [63:0] data_in;
  rand bit [11:0] rd_address;
  rand bit [11:0] wr_address;
  rand bit        read;
  rand bit        write;

  // Output data
  logic [63:0] data_out;

  // Transaction counters
  static int trans_id;
  static int no_of_read_trans;
  static int no_of_write_trans;
  static int no_of_RW_trans;

  // Constraints
  constraint VALID_ADDR {
    wr_address == rd_address;
  }

  constraint VALID_CTRL {
    {read, write} != 2'b00;
  }

  constraint VALID_DATA {
    data_in inside {[1:4294]};
  }

  // Display function
  function void display(input string message);
    $display("=================================================");
    $display("%s", message);
    $display("\tTransaction No: %0d", trans_id);
    $display("\tRead TRANSACTION No: %0d", no_of_read_trans);
    $display("\tWrite TRANSACTION No: %0d", no_of_write_trans);
    $display("\tRead-Write TRANSACTION No: %0d", no_of_RW_trans);
    $display("\tRead=%0d Write=%0d", read, write);
    $display("\tRead Address=%0d Write Address=%0d", rd_address, wr_address);
    $display("\tData_in=%0d", data_in);
    $display("\tData_out=%0d", data_out);
    $display("=================================================");
  endfunction : display


  // Post-randomize function
  function void post_randomize();

    if (this.read == 1 && this.write == 0)
      no_of_read_trans++;

    if (this.read == 0 && this.write == 1)
      no_of_write_trans++;

    if (this.read == 1 && this.write == 1)
      no_of_RW_trans++;

    this.display("\tRANDOMIZED DATA");

  endfunction : post_randomize

  // Compare function
  function bit compare(input ram_trans rcv, output string message);
    compare = 0;

    // Address comparison
    if (this.rd_address != rcv.rd_address) begin
      $display($time);
      message = "----ADDRESS MISMATCH----";
      return (0);
    end

    // Data comparison
    if (this.data_out != rcv.data_out) begin
      $display($time);
      message = "----DATA MISMATCH----";
      return (0);
    end

    // Successful comparison
    message = "SUCCESSFULLY COMPARED";
    return (1);
  endfunction : compare

endclass : ram_trans
