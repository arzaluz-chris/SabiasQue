#import "GradientView.h"
@import QuartzCore;

@interface GradientView ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation GradientView

+ (Class)layerClass {
  return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _gradientLayer = (CAGradientLayer *)self.layer;
    _startPoint = CGPointMake(0, 0.5);
    _endPoint   = CGPointMake(1, 0.5);
    self.layer.masksToBounds = YES;
  }
  return self;
}

- (void)setColors:(NSArray<UIColor *> *)colors {
  _colors = colors;
  NSMutableArray *cgColors = [NSMutableArray array];
  for (UIColor *c in colors) { [cgColors addObject:(id)c.CGColor]; }
  self.gradientLayer.colors = cgColors;
}

- (void)setStartPoint:(CGPoint)startPoint {
  _startPoint = startPoint;
  self.gradientLayer.startPoint = startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint {
  _endPoint = endPoint;
  self.gradientLayer.endPoint = endPoint;
}

@end
