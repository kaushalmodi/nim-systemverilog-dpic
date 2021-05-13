//----------------------------------------------------------------------
//// Copyright 2005-2012 Mentor Graphics Corporation
////
//// Licensed under the Apache License, Version 2.0 (the
//// "License"); you may not use this file except in
//// compliance with the License. You may obtain a copy of
//// the License at
////
//// http://www.apache.org/licenses/LICENSE-2.0
////
//// Unless required by applicable law or agreed to in
//// writing, software distributed under the License is
//// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//// CONDITIONS OF ANY KIND, either express or implied. See
//// the License for the specific language governing
//// permissions and limitations under the License.
////----------------------------------------------------------------------
/* $Id: dpi_vpi.c,v 1.5 2013/03/22 22:46:21 drich Exp $ */
/* dave_rich@mentor.com */

#include "vpi_user.h"

vpiHandle VPI_handle_by_name(const char* name, vpiHandle scope) {
    vpiHandle handle;
    if(handle = vpi_handle_by_name((PLI_BYTE8*)name,scope))
        return handle;
    else {
        vpi_printf("VPI_handle_by_name: Can't find name %s\n", name);
        return 0;
    }
}

int32_t VPI_get_value(vpiHandle handle) {
    s_vpi_value value_p;
    if (handle) {
        value_p.format = vpiIntVal;
        vpi_get_value(handle,&value_p);
        return value_p.value.integer;
    }
    else
        vpi_printf("VPI_get_value: error null handle\n");
}

int32_t VPI_get(int32_t prop, vpiHandle obj) {
    if (obj) {
        return vpi_get(prop, obj);
    }
    else
        vpi_printf("VPI_get: error null handle\n");
}

vpiHandle VPI_iterate(int32_t type, vpiHandle ref) {
    return vpi_iterate(type,ref);
}

vpiHandle VPI_scan(vpiHandle itr){
    return vpi_scan(itr);
}

vpiHandle VPI_handle(int32_t type, vpiHandle ref) {
    return vpi_handle(type,ref);
}

void VPI_get_str(int32_t prop, vpiHandle obj, const char** name) {
    if (obj) {
        name[0] = vpi_get_str(prop, obj);
        return;
    }
    else
        vpi_printf("VPI_get_str: error null handle\n");
}

void VPI_put_value(vpiHandle handle, int value) {
    s_vpi_value value_p;
    if (handle) {
        value_p.format = vpiIntVal;
        value_p.value.integer = value;
        vpi_put_value(handle,&value_p,0,vpiNoDelay);
    }
    else
        vpi_printf("VPI_put_value: error null handle\n");
}
