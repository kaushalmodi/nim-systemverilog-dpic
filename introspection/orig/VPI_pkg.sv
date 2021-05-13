//----------------------------------------------------------------------
// Copyright 2005-2007 Mentor Graphics Corporation
// Licensed under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of
// the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in
// writing, software distributed under the License is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See
// the License for the specific language governing
// permissions and limitations under the License.
//----------------------------------------------------------------------
/* $Id: dpi_vpi.sv,v 1.6 2013/03/22 23:39:42 drich Exp $ */
/* dave_rich@mentor.com */

package VPI_pkg;

  typedef chandle vpiHandle;

  // context is needed for calling VPI from DPI imported routines
  import "DPI-C" context
    VPI_handle_by_name = function vpiHandle vpi_handle_by_name(string name, vpiHandle scope);
  import "DPI-C" context
    VPI_iterate = function vpiHandle vpi_iterate (int _type, vpiHandle _ref);
  import "DPI-C" context
    VPI_scan = function vpiHandle vpi_scan (vpiHandle itr);
  import "DPI-C" context
    VPI_get_str = function void _vpi_get_str (int prop, vpiHandle obj, output string
                                              name);
  function automatic string vpi_get_str(int prop, vpiHandle obj);
    string s;
    _vpi_get_str(prop,obj,s);
    return s;
  endfunction : vpi_get_str

  import "DPI-C" context
    VPI_handle = function vpiHandle vpi_handle(int prop, vpiHandle obj);
  import "DPI-C" context
    VPI_get = function int vpi_get(int prop, vpiHandle handle);
  import "DPI-C" context
    VPI_get_value = function int vpi_get_int_value(vpiHandle handle);
  import "DPI-C" context
    VPI_put_value = function void vpi_put_int_value(vpiHandle handle, int value);

  /******************************** OBJECT TYPES ********************************/
  parameter vpiAlways = 1;         /* always construct */
  parameter vpiAssignStmt = 2;     /* quasi-continuous assignment */
  parameter vpiAssignment = 3;     /* procedural assignment */
  parameter vpiBegin = 4;          /* block statement */
  parameter vpiCase = 5;           /* case statement */
  parameter vpiCaseItem = 6;       /* case statement item */
  parameter vpiConstant = 7;       /* numerical constant or string literal */
  parameter vpiContAssign = 8;     /* continuous assignment */
  parameter vpiDeassign = 9;       /* deassignment statement */
  parameter vpiDefParam = 10;      /* defparam */

  parameter vpiModule = 32;        // module instance
  parameter vpiTimeUnit = 11;      // module time unit
  parameter vpiTimePrecision = 12; // module time precision
  parameter vpiParameter = 41;     // module parameter
  parameter vpiNet = 36;           // scalar or vector net
  parameter vpiFullName = 3;       // full hierarchical name
  parameter vpiSimNet = 126;       // simulated net after collapsing

  // [ The complete set of constants appears in Annex K and M od the IEEE 1800-2012 LRM]
endpackage : VPI_pkg
