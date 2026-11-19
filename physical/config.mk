export DESIGN_NAME = aes_128_accelerator
export PLATFORM = nangate45

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/aes128/rtl/*.sv))

export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/aes128/constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY = 0.50
