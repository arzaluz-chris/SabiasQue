#import "FactManager.h"
#import "FactProvider.h"

@interface FactManager ()
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *favorites;
@end

@implementation FactManager

+ (instancetype)sharedManager {
  static FactManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (instancetype)init {
  if (self = [super init]) {
    _favorites = [NSMutableArray array];
    [self loadFavorites];
  }
  return self;
}

- (void)loadFavorites {
  // En una app real, cargarías desde UserDefaults o Core Data
  // Por ahora solo inicializamos vacío
  self.favorites = [NSMutableArray array];
}

- (void)saveFavorites {
  // En una app real, guardarías en UserDefaults o Core Data
  [[NSNotificationCenter defaultCenter] postNotificationName:@"FavoritesUpdated" object:nil];
}

- (void)addFavorite:(NSString *)fact category:(NSString *)category {
  if ([self isFavorite:fact]) return;
  
  NSDictionary *favorite = @{
    @"fact": fact,
    @"category": category,
    @"emoji": [FactProvider emojiForCategory:category],
    @"date": [NSDate date]
  };
  
  [self.favorites addObject:favorite];
  [self saveFavorites];
}

- (void)removeFavorite:(NSDictionary *)favorite {
  NSString *fact = favorite[@"fact"];
  NSUInteger index = [self.favorites indexOfObjectPassingTest:^BOOL(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
    return [obj[@"fact"] isEqualToString:fact];
  }];
  
  if (index != NSNotFound) {
    [self.favorites removeObjectAtIndex:index];
    [self saveFavorites];
  }
}

- (NSMutableArray<NSDictionary *> *)getFavorites {
  return [self.favorites mutableCopy];
}

- (BOOL)isFavorite:(NSString *)fact {
  for (NSDictionary *fav in self.favorites) {
    if ([fav[@"fact"] isEqualToString:fact]) {
      return YES;
    }
  }
  return NO;
}

@end
