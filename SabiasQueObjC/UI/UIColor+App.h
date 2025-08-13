#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (App)

+ (UIColor *)appIndigo;
+ (UIColor *)appPurple;
+ (UIColor *)appPink;

+ (NSArray<UIColor *> *)gradientForCategoryKey:(NSString *)key; // ciencia/historia/tecnologia

@end

NS_ASSUME_NONNULL_END
