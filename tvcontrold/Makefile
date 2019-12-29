target = appletv:12.1
GO_EASY_ON_ME=1
include $(THEOS)/makefiles/common.mk

TOOL_NAME = tvcontrold

tvcontrold_FILES = main.mm TVCCDaemonListener.m
tvcontrold_FRAMEWORKS = Foundation UIKit
tvcontrold_CFLAGS = -fobjc-arc -I.
tvcontrold_CODESIGN_FLAGS=-Sent.plist

include $(THEOS_MAKE_PATH)/tool.mk

after-TVControlService-stage::
	$(ECHO_NOTHING)$(FAKEROOT) chown root:wheel $(THEOS_STAGING_DIR)/Library/LaunchDaemons/com.nito.tvcontrold.plist$(ECHO_END)
