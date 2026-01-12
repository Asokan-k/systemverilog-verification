interface ram_if (input bit clock);

    logic [63:0] data_in;
    logic [63:0] data_out;
    logic [11:0] rd_address;
    logic [11:0] wr_address;
    logic        read;
    logic        write;

    // Write driver clocking block
    clocking wr_drv_cb @(posedge clock);
        default input #1 output #1;
        output wr_address;
        output data_in;
        output write;
    endclocking : wr_drv_cb

    // Read driver clocking block
    clocking rd_drv_cb @(posedge clock);
        default input #1 output #1;
        output rd_address;
        output read;
    endclocking : rd_drv_cb

    // Write Monitor clocking block
    clocking wr_mon_cb @(posedge clock);
        default input #1 output #1;
        input wr_address;
        input data_in;
        input write;
    endclocking : wr_mon_cb

    // Read Monitor clocking block
    clocking rd_mon_cb @(posedge clock);
        default input #1 output #1;
        input rd_address;
        input read;
        input data_out;
    endclocking : rd_mon_cb

    // Write Driver Modport
    modport WR_DRV (clocking wr_drv_cb);

    // Read Driver Modport
    modport RD_DRV (clocking rd_drv_cb);

    // Write Monitor Modport
    modport WR_MON (clocking wr_mon_cb);

    // Read Monitor Modport
    modport RD_MON (clocking rd_mon_cb);

endinterface : ram_if
