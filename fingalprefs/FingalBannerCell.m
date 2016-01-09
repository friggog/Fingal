#import "FingalBannerCell.h"

@implementation FingalBannerCell

- (id)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:arg2 specifier:arg3];
    if (self) {
        CGRect frame = [self frame];
        frame.size.height = 130;
        self.backgroundColor = TINT_COLOUR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *containerView = [[UIView alloc] initWithFrame:frame];
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        containerView.clipsToBounds = YES;

        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/FingalPrefs.bundle/Logo.png"]];
        logo.frame = CGRectMake(0, 0, frame.size.width, 130);
        logo.contentMode = UIViewContentModeScaleAspectFit;
        logo.autoresizingMask =   UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

        [containerView addSubview:logo];
        [logo release];

        [self.contentView addSubview:containerView];
        [containerView release];
    }
    return self;
}

-(void)setBackgroundColor:(UIColor*)c {
    [super setBackgroundColor:TINT_COLOUR];
}

@end
