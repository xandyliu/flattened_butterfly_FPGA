# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DATA_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TEST_CASES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "mem_file" -parent ${Page_0}


}

proc update_PARAM_VALUE.DATA_W { PARAM_VALUE.DATA_W } {
	# Procedure called to update DATA_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_W { PARAM_VALUE.DATA_W } {
	# Procedure called to validate DATA_W
	return true
}

proc update_PARAM_VALUE.TEST_CASES { PARAM_VALUE.TEST_CASES } {
	# Procedure called to update TEST_CASES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TEST_CASES { PARAM_VALUE.TEST_CASES } {
	# Procedure called to validate TEST_CASES
	return true
}

proc update_PARAM_VALUE.mem_file { PARAM_VALUE.mem_file } {
	# Procedure called to update mem_file when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.mem_file { PARAM_VALUE.mem_file } {
	# Procedure called to validate mem_file
	return true
}


proc update_MODELPARAM_VALUE.DATA_W { MODELPARAM_VALUE.DATA_W PARAM_VALUE.DATA_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_W}] ${MODELPARAM_VALUE.DATA_W}
}

proc update_MODELPARAM_VALUE.TEST_CASES { MODELPARAM_VALUE.TEST_CASES PARAM_VALUE.TEST_CASES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TEST_CASES}] ${MODELPARAM_VALUE.TEST_CASES}
}

proc update_MODELPARAM_VALUE.mem_file { MODELPARAM_VALUE.mem_file PARAM_VALUE.mem_file } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.mem_file}] ${MODELPARAM_VALUE.mem_file}
}

