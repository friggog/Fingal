#import "FingalRootListController.h"
#import "FingalBannerCell.h"

NSInteger system_nd(const char *command) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
	return system(command);
#pragma GCC diagnostic pop
}

@implementation FingalRootListController

-(void) respring {
    system_nd("killall backboardd"); // maybe not the best way?
}

-(void) dealloc {
    [enabledIdentifiers release];
    [disabledIdentifiers release];
    [themeInfoDicts release];
    [super dealloc];
}

-(void) loadView {
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 44;
    tableView.allowsSelectionDuringEditing = YES;
    [tableView setEditing:YES animated:NO];
    self.view = tableView;
    [tableView release];
}

-(void) viewWillAppear:(BOOL)a {
    [super viewWillAppear:a];
    self.navigationController.navigationBar.tintColor = TINT_COLOUR;
    self.view.tintColor = TINT_COLOUR;
    [UIApplication sharedApplication].keyWindow.tintColor = TINT_COLOUR;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    self.view.tintColor = nil;
    [UIApplication sharedApplication].keyWindow.tintColor = nil;
}

-(void) setSpecifier:(PSSpecifier*)specifier {
    [super setSpecifier:specifier];
    self.navigationItem.title = @"Fingal";
    UIBarButtonItem *rsButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
    self.navigationItem.rightBarButtonItem = rsButton;

    enabledKey = @"enabledThemes";
    disabledKey =  @"disabledThemes";
    NSDictionary* settings = [NSDictionary dictionaryWithContentsOfFile:PREFS_PATH];

    NSArray* originalEnabled = [settings objectForKey:enabledKey] ? :defEnabled ? :[NSArray array];
    [enabledIdentifiers release];
    enabledIdentifiers = [originalEnabled mutableCopy];
    NSArray* originalDisabled = [settings objectForKey:disabledKey] ? :defDisabled ? :[NSArray array];
    [disabledIdentifiers release];
    disabledIdentifiers = [originalDisabled mutableCopy];

    allIdentifiers = [NSMutableArray array];
	[themeInfoDicts release];
	themeInfoDicts = [[NSMutableDictionary alloc] init];

    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/Fingal" error:nil];
    for (NSString* file in contents) {
        if ([file.pathExtension isEqualToString:@"theme"]) {
			NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/Info.plist",[@"/var/mobile/Library/Fingal/" stringByAppendingPathComponent:file]]];
            [allIdentifiers addObject:file];
			[themeInfoDicts setValue:infoDict forKey:file];
        }
    }

    for (NSString* identifier in originalEnabled) {
        if ([allIdentifiers containsObject:identifier]) {
            [allIdentifiers removeObject:identifier];
            [disabledIdentifiers removeObject:identifier];
        }
        else {
            [enabledIdentifiers removeObject:identifier];
        }
    }
    for (NSString* identifier in originalDisabled) {
        if ([allIdentifiers containsObject:identifier]) {
            [allIdentifiers removeObject:identifier];
        }
        else {
            [disabledIdentifiers removeObject:identifier];
        }
    }

    NSMutableArray* arrayToAddNewIdentifiers = disabledIdentifiers;
    for (NSString* identifier in allIdentifiers) {
        [arrayToAddNewIdentifiers addObject:identifier];
    }

    if ([self isViewLoaded]) {
        [(UITableView*)self.view setEditing:YES animated:NO];
        [(UITableView*)self.view reloadData];
    }
}

-(void) _flushSettings {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:PREFS_PATH] ? :[NSMutableDictionary dictionary];
    if (enabledKey) {
        [dict setObject:enabledIdentifiers forKey:enabledKey];
    }
    if (disabledKey) {
        [dict setObject:disabledIdentifiers forKey:disabledKey];
    }
    [dict writeToFile:PREFS_PATH atomically:YES];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFStringRef)@"me.chewitt.fingal.prefsChanged", NULL, NULL, YES);
}

-(NSInteger) numberOfSectionsInTableView:(UITableView*)table {
    return 4;
}

-(NSString*) tableView:(UITableView*)table titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return @"Enabled Themes";
            break;

        case 2:
            return @"Disabled Themes";
            break;

        default:
            return @"";
            break;
    }
}

-(NSString*) tableView:(UITableView*)table titleForFooterInSection:(NSInteger)section {
    return section == 0 ? @"Respring to fully apply changes." : section == 3 ? @"Fingal 1.0.0 © Charlie Hewitt 2016" : @"";
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.textLabel.textAlignment = NSTextAlignmentCenter;
}

-(NSArray*) arrayForSection:(NSInteger)section {
    switch (section) {

        case 1:
            return enabledIdentifiers;
            break;

        case 2:
            return disabledIdentifiers;
            break;

        default:
            return nil;
            break;
    }
}

-(NSInteger) tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [[self arrayForSection:section] count];
}

-(UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        FingalBannerCell* cell = [[FingalBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FingalBannerCell" specifier:nil];
		return (UITableViewCell*)cell;
    }
    else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ? : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        NSString* identifier = [[self arrayForSection:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = [themeInfoDicts valueForKey:identifier][@"displayName"];
		NSString *iconPath = [themeInfoDicts valueForKey:identifier][@"icon"];
		if([iconPath hasPrefix:@"/"])
        	cell.imageView.image = [UIImage imageWithContentsOfFile:iconPath];
		else
			cell.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Fingal/%@/%@",identifier,iconPath]];
        return cell;
    }
}

-(id) getPreferenceValueForKey:(NSString*)key {
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:PREFS_PATH];
    return [dic valueForKey:key];
}

-(void) setResetsToFirst:(UISwitch*)c {
    [self setPreferenceValue:[NSNumber numberWithBool:c.on] forKey:@"ScrollResetsToFirst"];
}

-(void) setScrollStyle:(UISegmentedControl*)c {
    [self setPreferenceValue:[NSNumber numberWithInt:c.selectedSegmentIndex] forKey:@"ScrollDirection"];
}

-(void) setPreferenceValue:(id)v forKey:(NSString*)key {
    NSMutableDictionary* defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PREFS_PATH]];
    [defaults setObject:v forKey:key];
    [defaults writeToFile:PREFS_PATH atomically:YES];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFStringRef)@"me.chewitt.fingal.prefsChanged", NULL, NULL, YES);
}

-(void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if(indexPath.section != 0)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleNone;
}

-(BOOL) tableView:(UITableView*)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath*)indexPath {
    return NO;
}

-(void) tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath {
    NSMutableArray* fromArray = fromIndexPath.section == 2 ? disabledIdentifiers:enabledIdentifiers;
    NSMutableArray* toArray = toIndexPath.section == 2 ? disabledIdentifiers:enabledIdentifiers;
    NSString* identifier = [[fromArray objectAtIndex:fromIndexPath.row] retain];
    [fromArray removeObjectAtIndex:fromIndexPath.row];
    [toArray insertObject:identifier atIndex:toIndexPath.row];
    [identifier release];
    [self _flushSettings];
}

-(id) table {
    return nil;
}

-(BOOL) tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0 || indexPath.section > 2) return NO;
    return YES;
}

-(NSIndexPath*) tableView:(UITableView*)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath*)sourceIndexPath toProposedIndexPath:(NSIndexPath*)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.section == 0)
        return [NSIndexPath indexPathForRow:0 inSection:1];
    else if(proposedDestinationIndexPath.section > 2)
        return [NSIndexPath indexPathForRow:[self tableView:tableView numberOfRowsInSection:proposedDestinationIndexPath.section] inSection:2];
    return proposedDestinationIndexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0)
        return 130;
    else
        return 44;
}

@end
