ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME = rootless
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = revealloader

revealloader_FILES = Tweak.x
revealloader_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
