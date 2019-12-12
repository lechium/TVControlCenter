target = appletv:12.1
GO_EASY_ON_ME=1
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = checkra1n

checkra1n_FILES = CRModule.m
checkra1n_INSTALL_PATH = /Library/TVSystemMenuModules
checkra1n_FRAMEWORKS = UIKit Foundation CoreFoundation CoreServices
checkra1n_PRIVATE_FRAMEWORKS = TVSystemMenuUI PineBoardServices
checkra1n_CFLAGS = -fobjc-arc -F. -I.
checkra1n_LDFLAGS += -F. -I. #-undefined dynamic_lookup

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/TVSystemMenuModules$(ECHO_END)
	
