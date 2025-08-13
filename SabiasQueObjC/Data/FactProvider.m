#import "FactProvider.h"

@implementation FactProvider

+ (NSArray<NSString *> *)categories {
  return @[@"ciencia", @"historia", @"tecnologia"];
}

+ (NSDictionary<NSString *, NSArray<NSString *> *> *)factsMap {
  return @{
    @"ciencia": @[
      @"El corazón de un camarón está en su cabeza",
      @"Los pulpos tienen tres corazones y sangre azul",
      @"Un día en Venus equivale a 243 días terrestres",
      @"El bambú puede crecer hasta 91 cm en un solo día",
      @"Las abejas pueden reconocer rostros humanos"
    ],
    @"historia": @[
      @"Las pirámides de Giza eran blancas y brillantes originalmente",
      @"Los vikingos llegaron a América 500 años antes que Colón",
      @"El Imperio Romano duró más de 1000 años",
      @"Cleopatra vivió más cerca del iPhone que de la construcción de las pirámides",
      @"La Universidad de Oxford es más antigua que el Imperio Azteca"
    ],
    @"tecnologia": @[
      @"El primer mensaje de texto se envió en 1992",
      @"Hay más dispositivos conectados a internet que personas en el mundo",
      @"El 90% de los datos del mundo se crearon en los últimos 2 años",
      @"La primera página web sigue activa desde 1991",
      @"Un iPhone tiene más poder que las computadoras del Apollo 11"
    ]
  };
}

+ (NSArray<NSString *> *)factsForCategory:(NSString *)key {
  NSArray *arr = [self factsMap][key];
  return arr ?: @[];
}

+ (NSString *)emojiForCategory:(NSString *)key {
  if ([key isEqualToString:@"ciencia"]) return @"🧬";
  if ([key isEqualToString:@"historia"]) return @"📜";
  return @"🚀";
}

@end
