class ram_sb;

  // Event to indicate completion
  event DONE;

  // Counters
  int data_verified = 0;
  int rm_data_count = 0;
  int mon_data_count = 0;

  // Transactions
  ram_trans rm_data;
  ram_trans rcvd_data;
  ram_trans cov_data;

  // Mailboxes
  mailbox #(ram_trans) rm_in_ch;    // ref model to scoreboard
  mailbox #(ram_trans) mon_in_ch;   // monitor to scoreboard

  // Coverage
  covergroup mem_coverage;

    // Address coverage
    RD_ADD : coverpoint cov_data.rd_address {
      bins ZERO      = {0};
      bins LOW1      = {[1:585]};
      bins LOW2      = {[586:1170]};
      bins MID_LOW   = {[1171:1755]};
      bins MID       = {[1756:2340]};
      bins MID_HIGH  = {[2341:2925]};
      bins HIGH1     = {[2926:3510]};
      bins HIGH2     = {[3511:4094]};
      bins MAX       = {4095};
    }

    // Data coverage
    DATA : coverpoint cov_data.data_out {
      bins ZERO      = {0};
      bins LOW1      = {[1:500]};
      bins LOW2      = {[501:1000]};
      bins MID_LOW   = {[1001:1500]};
      bins MID       = {[1501:2000]};
      bins MID_HIGH  = {[2001:2500]};
      bins HIGH1     = {[2501:3000]};
      bins HIGH2     = {[3001:4293]};
      bins MAX       = {4294};
    }

    // Read enable coverage
    RD : coverpoint cov_data.read {
      bins read = {1};
    }

    // Cross coverage
    READADDRDATA : cross RD, RD_ADD, DATA;

  endgroup : mem_coverage


  // Constructor
  function new(mailbox #(ram_trans) rm_in_ch,
               mailbox #(ram_trans) mon_in_ch);
    this.rm_in_ch  = rm_in_ch;
    this.mon_in_ch = mon_in_ch;
    mem_coverage   = new();
  endfunction : new


  // Start task
  task start();
    fork
      while (1) begin
        rm_in_ch.get(rm_data);
        rm_data_count++;

        mon_in_ch.get(rcvd_data);
        mon_data_count++;

        check(rcvd_data);
      end
    join_none
  endtask : start


  // Check task
  virtual task check(ram_trans rc_data);
    string diff;

    if (rc_data.read == 1) begin

      if (rc_data.data_out == 0)
        $display("SB: Random data not written");

      else if ((rc_data.read == 1) && (rc_data.data_out != 0)) begin

        if (!rm_data.compare(rc_data, diff)) begin
          $display("SB: Failed compare");
          $display("SB: Received Data");
          rc_data.display("SB: Data sent to DUT");
          rm_data.display("SB:\n\n", diff);
        end
        else 
          $display("SB: %s\n\n\n", diff);
          cov_data = new rm_data;
          mem_coverage.sample();
        end
  data_verified++;

    if (data_verified >= (number_of_transactions - rc_data.no_of_write_trans))
	begin
      -> DONE;
    end
	end
  endtask : check


  // Report
  function void report();
    $display("-------------------------------- SCOREBOARD REPORT --------------------------------");
    $display("%0d Read Data Generated, %0d Received Data Received",
              rm_data_count, mon_data_count);
    $display("%0d Read Data Verified\n",
              data_verified);
    $display("-----------------------------------------------------------------------------------");
  endfunction : report

endclass : ram_sb
