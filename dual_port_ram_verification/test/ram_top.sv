
`include "test.sv"

module top();

  // Clock parameter
  parameter cycle = 10;
  reg clock;

  // Instantiate the interface
  ram_if DUT_IF (clock);

  // Declare test handle
  test test_h;

  // Instantiate DUT
  ram_4096 RAM (
    .data_in   (DUT_IF.data_in),
    .data_out  (DUT_IF.data_out),
    .wr_address(DUT_IF.wr_address),
    .rd_address(DUT_IF.rd_address),
    .read      (DUT_IF.read),
    .write     (DUT_IF.write)
  );
  // Clock generation
  initial begin
    clock = 1'b0;
    forever #(cycle/2) clock = ~clock;
  end

  // Create test object and run simulation
  initial begin
    test_h = new(
      DUT_IF.WR_DRV,
      DUT_IF.RD_DRV,
      DUT_IF.WR_MON,
      DUT_IF.RD_MON
    );

    test_h.build_and_run();
  end


endmodule : top