# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "addr_width" -parent ${Page_0}
  ipgui::add_param $IPINST -name "baudrate" -parent ${Page_0}
  ipgui::add_param $IPINST -name "data_width" -parent ${Page_0}
  ipgui::add_param $IPINST -name "frame_length" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ref_clk_freq" -parent ${Page_0}


}

proc update_PARAM_VALUE.addr_width { PARAM_VALUE.addr_width } {
	# Procedure called to update addr_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.addr_width { PARAM_VALUE.addr_width } {
	# Procedure called to validate addr_width
	return true
}

proc update_PARAM_VALUE.baudrate { PARAM_VALUE.baudrate } {
	# Procedure called to update baudrate when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.baudrate { PARAM_VALUE.baudrate } {
	# Procedure called to validate baudrate
	return true
}

proc update_PARAM_VALUE.data_width { PARAM_VALUE.data_width } {
	# Procedure called to update data_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.data_width { PARAM_VALUE.data_width } {
	# Procedure called to validate data_width
	return true
}

proc update_PARAM_VALUE.frame_length { PARAM_VALUE.frame_length } {
	# Procedure called to update frame_length when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.frame_length { PARAM_VALUE.frame_length } {
	# Procedure called to validate frame_length
	return true
}

proc update_PARAM_VALUE.ref_clk_freq { PARAM_VALUE.ref_clk_freq } {
	# Procedure called to update ref_clk_freq when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ref_clk_freq { PARAM_VALUE.ref_clk_freq } {
	# Procedure called to validate ref_clk_freq
	return true
}


proc update_MODELPARAM_VALUE.data_width { MODELPARAM_VALUE.data_width PARAM_VALUE.data_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.data_width}] ${MODELPARAM_VALUE.data_width}
}

proc update_MODELPARAM_VALUE.frame_length { MODELPARAM_VALUE.frame_length PARAM_VALUE.frame_length } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.frame_length}] ${MODELPARAM_VALUE.frame_length}
}

proc update_MODELPARAM_VALUE.addr_width { MODELPARAM_VALUE.addr_width PARAM_VALUE.addr_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.addr_width}] ${MODELPARAM_VALUE.addr_width}
}

proc update_MODELPARAM_VALUE.ref_clk_freq { MODELPARAM_VALUE.ref_clk_freq PARAM_VALUE.ref_clk_freq } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ref_clk_freq}] ${MODELPARAM_VALUE.ref_clk_freq}
}

proc update_MODELPARAM_VALUE.baudrate { MODELPARAM_VALUE.baudrate PARAM_VALUE.baudrate } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.baudrate}] ${MODELPARAM_VALUE.baudrate}
}

