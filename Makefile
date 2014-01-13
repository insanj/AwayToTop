THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 arm64

TWEAK_NAME = AwayToTop
AwayToTop_FILES = Tweak.xm
AwayToTop_FRAMEWORKS = UIKit

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

internal-after-install::
	install.exec "killall -9 backboardd"