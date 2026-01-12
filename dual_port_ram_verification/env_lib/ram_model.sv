class ram_model;

  // Transactions from monitors
  ram_trans mon_data1;
  ram_trans mon_data2;

  // Reference memory
  logic [63:0] ref_data [int];

  // Mailboxes
  mailbox #(ram_trans) wr2rm;
  mailbox #(ram_trans) rd2rm;
  mailbox #(ram_trans) rm2sb;

   // Constructor
  
  function new(
    mailbox #(ram_trans) wr2rm,
    mailbox #(ram_trans) rd2rm,
    mailbox #(ram_trans) rm2sb
  );
    this.wr2rm = wr2rm;
    this.rd2rm = rd2rm;
    this.rm2sb = rm2sb;
  endfunction

  // Dual memory write function

  task dual_mem_fun_write(ram_trans mon_data1);
    begin
      if (mon_data1.write)
        mem_write(mon_data1);
    end
  endtask

    // Dual memory read function
  
  task dual_mem_fun_read(ram_trans mon_data2);
    begin
      if (mon_data2.read)
        mem_read(mon_data2);
    end
  endtask

  
  // Memory write task
 
  task mem_write(ram_trans mon_data1);
    ref_data[mon_data1.wr_address] = mon_data1.data_in;
  endtask

   // Memory read task
  
  task mem_read(ram_trans mon_data2);
    if (ref_data.exists(mon_data2.rd_address))
      mon_data2.data_out = ref_data[mon_data2.rd_address];
  endtask

    // Start task
  
  virtual task start();
    fork

      // Write path
      begin
        forever begin
          wr2rm.get(mon_data1);
          dual_mem_fun_write(mon_data1);
        end
      end

      // Read path
      begin
        forever begin
          rd2rm.get(mon_data2);
          dual_mem_fun_read(mon_data2);
          rm2sb.put(mon_data2);
        end
      end

    join_none
  endtask

endclass : ram_model