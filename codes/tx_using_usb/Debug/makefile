################################################################################
# Automatically-generated file. Do not edit!
################################################################################

CG_TOOL_ROOT := /home/arktheshadow/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.0.LTS

GEN_OPTS__FLAG := 
GEN_CMDS__FLAG := 

ORDERED_OBJS += \
"./startup_ccs.obj" \
"./tx.obj" \
"./tx_direct_buffer.obj" \
"./tx_usb_dev_bulk.obj" \
"./usb_bulk_structs.obj" \
"./utils/uartstdio.obj" \
"./utils/ustdlib.obj" \
"../usb_dev_bulk_ccs.cmd" \
$(GEN_CMDS__FLAG) \
-llibc.a \
-l"/home/arktheshadow/ti/SW-EK-TM4C123GXL-2.1.3.156/driverlib/ccs/Debug/driverlib.lib" \
-l"/home/arktheshadow/ti/SW-EK-TM4C123GXL-2.1.3.156/usblib/ccs/Debug/usblib.lib" \

-include ../makefile.init

RM := rm -rf
RMDIR := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir_vars.mk
-include utils/subdir_vars.mk
-include subdir_rules.mk
-include utils/subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(INO_DEPS)),)
-include $(INO_DEPS)
endif
ifneq ($(strip $(CLA_DEPS)),)
-include $(CLA_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(SV7A_DEPS)),)
-include $(SV7A_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(PDE_DEPS)),)
-include $(PDE_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXE_OUTPUTS += \
tx_using_usb.out \

EXE_OUTPUTS__QUOTED += \
"tx_using_usb.out" \

BIN_OUTPUTS += \
tx_using_usb.bin \

BIN_OUTPUTS__QUOTED += \
"tx_using_usb.bin" \


# All Target
all: tx_using_usb.out

# Tool invocations
tx_using_usb.out: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@echo 'Building target: $@'
	@echo 'Invoking: ARM Linker'
	"/home/arktheshadow/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.0.LTS/bin/armcl" -mv7M4 --code_state=16 --float_support=FPv4SPD16 --abi=eabi -me -O2 --advice:power=all -g --gcc --define=ccs="ccs" --define=PART_TM4C123GH6PM --define=TARGET_IS_TM4C123_RB1 --define=UART_BUFFERED --diag_wrap=off --diag_warning=225 --display_error_number --gen_func_subsections=on --ual -z -m"usb_dev_bulk_ccs.map" --heap_size=0 --stack_size=1024 -i"/home/arktheshadow/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.0.LTS/lib" -i"/home/arktheshadow/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.0.LTS/include" --reread_libs --display_error_number --diag_wrap=off --warn_sections --xml_link_info="tx_using_usb_linkInfo.xml" --rom_model -o "tx_using_usb.out" $(ORDERED_OBJS)
	@echo 'Finished building target: $@'
	@echo ' '
	@$(MAKE) --no-print-directory post-build

tx_using_usb.bin: $(EXE_OUTPUTS)
	@echo 'Invoking: ARM Hex Utility'
	"/home/arktheshadow/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.0.LTS/bin/armhex"  -o "tx_using_usb.bin" $(EXE_OUTPUTS__QUOTED)
	@echo 'Finished building: $@'
	@echo ' '
	@$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) $(BIN_OUTPUTS__QUOTED)$(EXE_OUTPUTS__QUOTED)
	-$(RM) "startup_ccs.obj" "tx.obj" "tx_direct_buffer.obj" "tx_usb_dev_bulk.obj" "usb_bulk_structs.obj" "utils/uartstdio.obj" "utils/ustdlib.obj" 
	-$(RM) "startup_ccs.d" "tx.d" "tx_direct_buffer.d" "tx_usb_dev_bulk.d" "usb_bulk_structs.d" "utils/uartstdio.d" "utils/ustdlib.d" 
	-@echo 'Finished clean'
	-@echo ' '

post-build:
	-"/home/arktheshadow/ti/ccsv7/utils/tiobj2bin/tiobj2bin" "tx_using_usb.out" "tx_using_usb.bin" "/home/arktheshadow/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.0.LTS/bin/armofd" "/home/arktheshadow/ti/ccsv7/tools/compiler/ti-cgt-arm_16.9.0.LTS/bin/armhex" "/home/arktheshadow/ti/ccsv7/utils/tiobj2bin/mkhex4bin"
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets

