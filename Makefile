ADDITIONAL_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Fingal
Fingal_FILES = Tweak.xm NSArray+Reverse.m UIImage+animatedGIF.m
Fingal_FRAMEWORKS = UIKit QuartzCore ImageIO

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += fingalprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
