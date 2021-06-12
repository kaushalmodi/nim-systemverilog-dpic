// How to access the TCL command line from HDL using calls to C code through DPI or VPI
// https://support.cadence.com/apex/ArticleAttachmentPortal?id=a1Od0000000nT4aEAE&pageName=ArticleContent

// /cad/adi/apps/cadence/xlm/linux/19.03-s13/tools.lnx86/include/cfclib.h
#include "cfclib.h"

void call_tcl(char* s)
{
    char *tcl_out;

    // https://support.cadence.com/apex/techpubDocViewerPage?xmlName=vhdlcuser.xml&title=VHDL%20Simulation%20C%20Interface%20User%20Guide%20--%202%20-%20%202.6.11%20%20char%20*%20cfcGetOutput()%20&hash=936044&c_version=18.03&path=vhdlcuser/vhdlcuser18.03/chap2.html#936044
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
