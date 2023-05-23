export THEOS=/Users/$(shell whoami)/Projects/theos
target = appletv
THEOS_DEVICE_IP=guest-room.local
DEBUG=1
INSTALL_TARGET_PROCESSES = TVSystemMenuService, demod, rapportd 

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TVControlCenter

TVControlCenter_FILES = TVControlCenter.x
TVControlCenter_CFLAGS = -fobjc-arc -IFindProcess -Itvcontrold
TVControlCenter_INSTALL_PATH = /fs/jb/Library/MobileSubstrate/DynamicLibraries/

include $(THEOS_MAKE_PATH)/tweak.mk
#SUBPROJECTS += checkra1n
SUBPROJECTS += tvcontrold
include $(THEOS_MAKE_PATH)/aggregate.mk
