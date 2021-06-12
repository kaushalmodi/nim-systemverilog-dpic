// /cad/adi/apps/cadence/xlm/linux/19.03-s13/tools.lnx86/include/cfclib.h
#include "cfclib.h"

void call_tcl(char* s)
{
    char *tcl_out;

    // The cfcExecuteCommand() has to be preceeded by
    // cfcCaptureOutput() if you want cfcGetOutput() to capture the
    // output. Do cfcReleaseOutput() *only after* you are done with
    // cfcWriteMessage calls.
    cfcCaptureOutput();

    cfcExecuteCommand(s);

    tcl_out = cfcGetOutput();

    cfcWriteMessage("tcl out: `");
    cfcWriteMessage(tcl_out);
    cfcWriteMessage("'");

    cfcReleaseOutput();
}
