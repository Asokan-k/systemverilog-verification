class ram_read_mon;

    virtual ram_if.RD_MON rd_mon_if;

    ram_trans data2rm;
    ram_trans data2sb;

    mailbox #(ram_trans) mon2rm;
    mailbox #(ram_trans) mon2sb;

    function new (
        virtual ram_if.RD_MON rd_mon_if,
        mailbox #(ram_trans) mon2rm,
        mailbox #(ram_trans) mon2sb
    );
        this.rd_mon_if = rd_mon_if;
        this.mon2rm    = mon2rm;
        this.mon2sb    = mon2sb;
        this.data2rm   = new;
    endfunction : new

    task monitor();
        @(rd_mon_if.rd_mon_cb);
        wait (rd_mon_if.rd_mon_cb.read == 1)
        @(rd_mon_if.rd_mon_cb);
        begin
            data2rm.read       = rd_mon_if.rd_mon_cb.read;
            data2rm.rd_address = rd_mon_if.rd_mon_cb.rd_address;
            data2rm.data_out   = rd_mon_if.rd_mon_cb.data_out;
            data2rm.display("DATA FROM READ MONITOR");
        end
    endtask : monitor

    task start();
        fork
            forever begin
                monitor();
                data2sb = new data2rm;
                mon2rm.put(data2rm);
                mon2sb.put(data2sb);
            end
        join_none
    endtask : start

endclass : ram_read_mon