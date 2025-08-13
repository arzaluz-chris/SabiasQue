#import <UIKit/UIKit.h>

@interface GradientView : UIView
@property (nonatomic, strong) NSArray<UIColor *> *colors; // 2 o más colores
@property (nonatomic, assign) CGPoint startPoint; // 0..1
@property (nonatomic, assign) CGPoint endPoint;   // 0..1
@end
