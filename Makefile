target = appletv:12.1
THEOS_DEVICE_IP=guest-room.local
DEBUG=0
INSTALL_TARGET_PROCESSES = TVSystemMenuService, demod, rapportd 

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TVControlCenter

TVControlCenter_FILES = TVControlCenter.x FindProcess/FindProcess.m
TVControlCenter_CFLAGS = -fobjc-arc -IFindProcess -Itvcontrold

include $(THEOS_MAKE_PATH)/tweak.mk
#SUBPROJECTS += checkra1n
SUBPROJECTS += tvcontrold
include $(THEOS_MAKE_PATH)/aggregate.mk
