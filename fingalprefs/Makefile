include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FingalPrefs
FingalPrefs_FILES = FingalRootListController.m FingalBannerCell.m
FingalPrefs_INSTALL_PATH = /Library/PreferenceBundles
FingalPrefs_FRAMEWORKS = UIKit
FingalPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FingalPrefs.plist$(ECHO_END)
