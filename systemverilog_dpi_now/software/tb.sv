`define PCI_CFGREAD  1
`define PCI_CFGWRITE 2

module top;
  reg pci_clk, pci_frame, pci_irdy;
  int pci_data;

  typedef struct {
    int addr;
    int cb_e;
    int databuffer;
    // ....
  } pcicmd_t;

  task pci_transaction(inout pcicmd_t cmd);
    case (cmd.cb_e)
      `PCI_CFGREAD: begin
        pci_frame = 1'b0;
        @(posedge pci_clk);
        pci_irdy = 1'b0;
        @(posedge pci_clk);

        // Perform HW operations...
        $display("vl: Reading config @ 0x%0x (%0d dec)", cmd.addr, cmd.addr);
        pci_data = 1234;
        cmd.databuffer = pci_data;
      end

      `PCI_CFGWRITE: begin
        // ...
      end
    endcase
  endtask

  import "DPI-C" context task c_test();
  export "DPI-C" task pci_transaction;

  initial begin
    c_test();
    $finish;
  end

  always begin
    pci_clk = 0; #50; pci_clk = 1; #50;
  end
endmodule
