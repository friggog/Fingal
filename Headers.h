@interface SBIcon : NSObject
- (NSString *)nodeIdentifier;
@end

@interface SBIconImageView : UIView
- (id)contentsImage;
// new
@property (nonatomic,retain) UIImageView *fingalAnimatedIconView;
@end
