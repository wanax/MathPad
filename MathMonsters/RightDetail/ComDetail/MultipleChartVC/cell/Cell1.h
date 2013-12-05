
#import <UIKit/UIKit.h>

@interface Cell1 : UITableViewCell


@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic,retain)IBOutlet UIImageView *arrowImageView;
@property (nonatomic,retain)IBOutlet UIImageView *classIcon;

- (void)changeArrowWithUp:(BOOL)up;
@end
