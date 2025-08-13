#import "CardView.h"

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor systemBackgroundColor];
    self.layer.cornerRadius = 20.0;
    self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0, 6);
  }
  return self;
}

@end
