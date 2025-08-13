#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FactManager : NSObject

+ (instancetype)sharedManager;

- (void)addFavorite:(NSString *)fact category:(NSString *)category;
- (void)removeFavorite:(NSDictionary *)favorite;
- (NSMutableArray<NSDictionary *> *)getFavorites;
- (BOOL)isFavorite:(NSString *)fact;

@end

NS_ASSUME_NONNULL_END
