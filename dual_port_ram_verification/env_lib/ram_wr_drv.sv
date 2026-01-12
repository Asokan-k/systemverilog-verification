class ram_write_drv;

    virtual ram_if.WR_DRV wr_drv_if;

    ram_trans data2duv;

    mailbox #(ram_trans) gen2wr;

    function new (
        virtual ram_if.WR_DRV wr_drv_if,
        mailbox #(ram_trans) gen2wr
    );
        this.wr_drv_if = wr_drv_if;
        this.gen2wr    = gen2wr;
    endfunction : new
	
virtual task drive();
        @(wr_drv_if.wr_drv_cb);
        wr_drv_if.wr_drv_cb.data_in    <= data2duv.data_in;
        wr_drv_if.wr_drv_cb.wr_address <= data2duv.wr_address;
        wr_drv_if.wr_drv_cb.write      <= data2duv.write;

        // wait for 1 clock cycle after applying all the inputs
        // If write is high, 1 cycle will be required to write the data
        repeat (2) @(wr_drv_if.wr_drv_cb);

        // Disable the write signal
        wr_drv_if.wr_drv_cb.write <= '0;
    endtask : drive

virtual task start();
        fork
            forever begin
                // get the data from mailbox (gen2wr)
                gen2wr.get(data2duv);
                drive();
            end
        join_none
    endtask : start

endclass : ram_write_drv