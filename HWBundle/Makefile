target = appletv:12.1
GO_EASY_ON_ME=1
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HWBundle

HWBundle_FILES = HWModule.m
HWBundle_INSTALL_PATH = /Library/TVSystemMenuModules
HWBundle_FRAMEWORKS = UIKit Foundation CoreFoundation CoreServices
HWBundle_PRIVATE_FRAMEWORKS = TVSystemMenuUI PineBoardServices
HWBundle_CFLAGS = -fobjc-arc -F. -I.
HWBundle_LDFLAGS += -F. -I. #-undefined dynamic_lookup

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/TVSystemMenuModules$(ECHO_END)
	
