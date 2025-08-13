#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FactProvider : NSObject
+ (NSArray<NSString *> *)categories; // @"ciencia", @"historia", @"tecnologia"
+ (NSArray<NSString *> *)factsForCategory:(NSString *)key;
+ (NSString *)emojiForCategory:(NSString *)key; // 🧬 📜 🚀
@end

NS_ASSUME_NONNULL_END
