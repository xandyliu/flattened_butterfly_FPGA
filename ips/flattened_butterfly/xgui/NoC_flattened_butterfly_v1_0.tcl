# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DATA_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FIFO_DEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NODE_PER_COL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NODE_PER_ROW" -parent ${Page_0}


}

proc update_PARAM_VALUE.DATA_W { PARAM_VALUE.DATA_W } {
	# Procedure called to update DATA_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_W { PARAM_VALUE.DATA_W } {
	# Procedure called to validate DATA_W
	return true
}

proc update_PARAM_VALUE.FIFO_DEPTH { PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to update FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_DEPTH { PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to validate FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.NODE_PER_COL { PARAM_VALUE.NODE_PER_COL } {
	# Procedure called to update NODE_PER_COL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NODE_PER_COL { PARAM_VALUE.NODE_PER_COL } {
	# Procedure called to validate NODE_PER_COL
	return true
}

proc update_PARAM_VALUE.NODE_PER_ROW { PARAM_VALUE.NODE_PER_ROW } {
	# Procedure called to update NODE_PER_ROW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NODE_PER_ROW { PARAM_VALUE.NODE_PER_ROW } {
	# Procedure called to validate NODE_PER_ROW
	return true
}


proc update_MODELPARAM_VALUE.DATA_W { MODELPARAM_VALUE.DATA_W PARAM_VALUE.DATA_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_W}] ${MODELPARAM_VALUE.DATA_W}
}

proc update_MODELPARAM_VALUE.FIFO_DEPTH { MODELPARAM_VALUE.FIFO_DEPTH PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_DEPTH}] ${MODELPARAM_VALUE.FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.NODE_PER_ROW { MODELPARAM_VALUE.NODE_PER_ROW PARAM_VALUE.NODE_PER_ROW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NODE_PER_ROW}] ${MODELPARAM_VALUE.NODE_PER_ROW}
}

proc update_MODELPARAM_VALUE.NODE_PER_COL { MODELPARAM_VALUE.NODE_PER_COL PARAM_VALUE.NODE_PER_COL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NODE_PER_COL}] ${MODELPARAM_VALUE.NODE_PER_COL}
}

