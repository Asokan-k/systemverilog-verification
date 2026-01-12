package ram_pkg;
int number_of_transactions = 1;
`include "ram_trans.sv"
`include "ram_gen.sv"
`include "ram_wr_drv.sv"
`include "ram_rd_drv.sv"
`include "ram_wr_mon.sv"
`include "ram_rd_mon.sv"
`include "ram_model.sv"
`include "ram_sb.sv"
`include "ram_env.sv"
endpackage
