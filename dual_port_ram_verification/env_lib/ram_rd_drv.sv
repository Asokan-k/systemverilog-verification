class ram_read_drv;

    virtual ram_if.RD_DRV rd_drv_if;

    ram_trans data2duv;

    mailbox #(ram_trans) gen2rd;

    function new (
        virtual ram_if.RD_DRV rd_drv_if,
        mailbox #(ram_trans) gen2rd
    );
        this.rd_drv_if = rd_drv_if;
        this.gen2rd    = gen2rd;
    endfunction : new
	
virtual task drive();
        @(rd_drv_if.rd_drv_cb);
        rd_drv_if.rd_drv_cb.rd_address <= data2duv.rd_address;
        rd_drv_if.rd_drv_cb.read       <= data2duv.read;

        // wait for 1 clock cycle after applying all the inputs
        // If read is high, 1 cycle will be required to read the data
        repeat (2) @(rd_drv_if.rd_drv_cb);

        // Disable the read signal
        rd_drv_if.rd_drv_cb.read <= '0;
    endtask : drive

virtual task start();
        fork
            forever begin
                gen2rd.get(data2duv);
                drive();
            end
        join_none
    endtask : start

endclass : ram_read_drv