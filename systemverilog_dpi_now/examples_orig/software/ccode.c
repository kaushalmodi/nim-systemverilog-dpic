#include <stdio.h>
#include "svdpi.h"

#include "dpiheader.h"

#define PCI_CFGREAD  1
#define PCI_CFGWRITE 2

int
c_test()
{
    pcicmd_t cmd;

    vpi_printf("Running\n");

    /*
     * Program a series of PCI tests, configure
     * the registers in the hardware, perform tests.
     */

    cmd.addr = 0x30;
    cmd.cb_e = PCI_CFGREAD;
    cmd.databuffer = 0;

    /* Call HW */
    pci_transaction(&cmd);

    /* Check results */
    vpi_printf(" c: read config databuffer = %d\n", 
        cmd.databuffer);

    /* ... */

    vpi_printf("...done.\n");
    return 0;
}

