#import <UIKit/UIKit.h>
#import <dlfcn.h>

static NSArray *enabledApps = nil;

static void loadPreferences() {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/jb/var/mobile/Library/Preferences/com.erik.revealloader.plist"];
    enabledApps = prefs[@"selectedApplications"] ?: @[];
    NSLog(@"[RevealLoader] Preferences loaded: %@ %@", enabledApps,prefs);
}

static BOOL isRevealEnabledForCurrentApp() {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    return [enabledApps containsObject:bundleID];
}

static void reloadPrefsCallback(CFNotificationCenterRef center,
                                void *observer,
                                CFStringRef name,
                                const void *object,
                                CFDictionaryRef userInfo) {
    loadPreferences();
    NSLog(@"[RevealLoader] Preferences reloaded via Darwin notification.");
}

%ctor {
    @autoreleasepool {
        loadPreferences();

        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            reloadPrefsCallback,
            CFSTR("com.mikejing.revealloader/ReloadPrefs"),
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately
        );

        if (!isRevealEnabledForCurrentApp()) {
            NSLog(@"[RevealLoader] %@ not enabled, skipping Reveal.", [[NSBundle mainBundle] bundleIdentifier]);
            return;
        }

        NSString *libraryPath = @"/var/jb/Library/Application Support/RevealLoader/RevealServer";
        NSFileManager *fm = [NSFileManager defaultManager];

        if (![fm fileExistsAtPath:libraryPath]) {
            NSLog(@"[RevealLoader] RevealServer not found at %@", libraryPath);
            return;
        }

        dlerror();
        void *handle = dlopen([libraryPath UTF8String], RTLD_NOW | RTLD_GLOBAL);
        if (handle) {
            NSLog(@"[RevealLoader] RevealServer loaded successfully for %@", [[NSBundle mainBundle] bundleIdentifier]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IBARevealRequestStart" object:nil];
        } else {
            const char *err = dlerror();
            NSLog(@"[RevealLoader] Failed to load RevealServer: %s", err ?: "unknown");
        }
    }
}
