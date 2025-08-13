#import "UIColor+App.h"

@implementation UIColor (App)

+ (UIColor *)appIndigo { return [UIColor colorWithRed:0.31 green:0.36 blue:0.86 alpha:1.0]; }
+ (UIColor *)appPurple { return [UIColor colorWithRed:0.59 green:0.35 blue:0.86 alpha:1.0]; }
+ (UIColor *)appPink   { return [UIColor colorWithRed:0.96 green:0.37 blue:0.67 alpha:1.0]; }

+ (NSArray<UIColor *> *)gradientForCategoryKey:(NSString *)key {
  if ([key isEqualToString:@"ciencia"]) {
    return @[[UIColor colorWithRed:0.0 green:0.77 blue:0.58 alpha:1.0], // emerald
             [UIColor colorWithRed:0.27 green:0.82 blue:0.87 alpha:1.0]]; // cyan
  } else if ([key isEqualToString:@"historia"]) {
    return @[[UIColor colorWithRed:1.00 green:0.73 blue:0.24 alpha:1.0], // amber
             [UIColor colorWithRed:1.00 green:0.58 blue:0.20 alpha:1.0]]; // orange
  } else {
    return @[[UIColor colorWithRed:0.56 green:0.27 blue:0.96 alpha:1.0], // violet
             [UIColor colorWithRed:0.64 green:0.27 blue:0.96 alpha:1.0]]; // purple
  }
}

@end
