#import <Preferences/PSViewController.h>

@interface FingalRootListController : PSViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *enabledIdentifiers;
    NSMutableArray *disabledIdentifiers;
    NSMutableArray *allIdentifiers;
    NSArray *defEnabled;
    NSArray *defDisabled;
    NSString *enabledKey;
    NSString *disabledKey;
    NSMutableDictionary *themeInfoDicts;
}
@end
