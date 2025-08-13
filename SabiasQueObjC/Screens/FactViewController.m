#import "FactViewController.h"
#import "GradientView.h"
#import "CardView.h"
#import "UIColor+App.h"
#import "FactProvider.h"
#import "FactManager.h"

@interface FactViewController ()
@property (nonatomic, copy) NSString *categoryKey;
@property (nonatomic, strong) NSArray<NSString *> *facts;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) GradientView *header;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *counterLabel;

@property (nonatomic, strong) CardView *factCard;
@property (nonatomic, strong) UIImageView *factImageView;
@property (nonatomic, strong) UILabel *factLabel;

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) UIButton *shareButton;

// Diccionario de URLs de imágenes para cada dato
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *factImageURLs;
@end

@implementation FactViewController

- (instancetype)initWithCategory:(NSString *)key {
  if (self = [super init]) {
    _categoryKey = key ?: @"ciencia";
    _facts = [FactProvider factsForCategory:_categoryKey];
    _index = 0;
    [self setupImageURLs];
  }
  return self;
}

- (void)setupImageURLs {
  // URLs de imágenes específicas para cada dato curioso
  // Usando Unsplash API para imágenes relacionadas con cada dato
  
  self.factImageURLs = @{
      @"El corazón de un camarón está en su cabeza":
            @"https://images.unsplash.com/photo-1559737558-2f5a35f4523b?w=400&h=200&fit=crop", // Camarones/Prawns
      
    @"Los pulpos tienen tres corazones y sangre azul":
      @"https://images.unsplash.com/photo-1545671913-b89ac1b4ac10?w=400&h=200&fit=crop", // Pulpo
      
    @"Un día en Venus equivale a 243 días terrestres":
      @"https://images.unsplash.com/photo-1630694093867-4b947d812bf0?w=400&h=200&fit=crop", // Venus (planeta naranja)
      
      @"El bambú puede crecer hasta 91 cm en un solo día":
            @"https://images.unsplash.com/photo-1567225557594-88d73e55f2cb?w=400&h=200&fit=crop", // Bambú verde
      
    @"Las abejas pueden reconocer rostros humanos":
      @"https://images.unsplash.com/photo-1568526381923-caf3fd520382?w=400&h=200&fit=crop", // Abeja
      
    // HISTORIA
    @"Las pirámides de Giza eran blancas y brillantes originalmente":
      @"https://images.unsplash.com/photo-1539650116574-8efeb43e2750?w=400&h=200&fit=crop", // Pirámides
      
    @"Los vikingos llegaron a América 500 años antes que Colón":
      @"https://images.unsplash.com/photo-1599930113854-d6d7fd521f10?w=400&h=200&fit=crop", // Barco vikingo
      
    @"El Imperio Romano duró más de 1000 años":
      @"https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=200&fit=crop", // Coliseo Romano
      
      @"Cleopatra vivió más cerca del iPhone que de la construcción de las pirámides":
            @"https://images.pexels.com/photos/3199399/pexels-photo-3199399.jpeg?auto=compress&cs=tinysrgb&w=400&h=200&fit=crop", // Egipto/Cleopatra
      
    @"La Universidad de Oxford es más antigua que el Imperio Azteca":
      @"https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=400&h=200&fit=crop", // Universidad Oxford
      
    // TECNOLOGÍA
    @"El primer mensaje de texto se envió en 1992":
      @"https://images.unsplash.com/photo-1530319067432-f2a729c03db5?w=400&h=200&fit=crop", // Teléfono móvil antiguo
      
    @"Hay más dispositivos conectados a internet que personas en el mundo":
      @"https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=400&h=200&fit=crop", // Red de dispositivos/Internet
      
    @"El 90% de los datos del mundo se crearon en los últimos 2 años":
      @"https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=200&fit=crop", // Data/Gráficas
      
    @"La primera página web sigue activa desde 1991":
      @"https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=400&h=200&fit=crop", // Código web
      
    @"Un iPhone tiene más poder de procesamiento que las computadoras del Apollo 11":
      @"https://images.unsplash.com/photo-1517976547714-720226b864c1?w=400&h=200&fit=crop"  // Apollo/Espacio
  };
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
  self.navigationController.navigationBarHidden = YES;

  // Header
  self.header = [[GradientView alloc] init];
  self.header.translatesAutoresizingMaskIntoConstraints = NO;
  self.header.colors = [UIColor gradientForCategoryKey:self.categoryKey];
  self.header.startPoint = CGPointMake(0, 0);
  self.header.endPoint   = CGPointMake(1, 0);
  [self.view addSubview:self.header];

  UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
  back.translatesAutoresizingMaskIntoConstraints = NO;
  [back setImage:[UIImage systemImageNamed:@"chevron.backward"] forState:UIControlStateNormal];
  [back setTitle:@" Volver" forState:UIControlStateNormal];
  [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  back.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
  back.tintColor = [UIColor whiteColor];
  [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
  [self.header addSubview:back];

  UILabel *emoji = [UILabel new];
  emoji.translatesAutoresizingMaskIntoConstraints = NO;
  emoji.text = [FactProvider emojiForCategory:self.categoryKey];
  emoji.font = [UIFont systemFontOfSize:28];
  [self.header addSubview:emoji];

  self.categoryLabel = [UILabel new];
  self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.categoryLabel.textColor = [UIColor whiteColor];
  self.categoryLabel.font = [UIFont boldSystemFontOfSize:24];
  self.categoryLabel.text = [self.categoryKey capitalizedString];
  [self.header addSubview:self.categoryLabel];

  self.counterLabel = [UILabel new];
  self.counterLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.counterLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
  self.counterLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
  [self.header addSubview:self.counterLabel];

  // Tarjeta del dato
  self.factCard = [[CardView alloc] init];
  self.factCard.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.factCard];
  
  // Imagen dentro de la tarjeta
  self.factImageView = [[UIImageView alloc] init];
  self.factImageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.factImageView.contentMode = UIViewContentModeScaleAspectFill;
  self.factImageView.layer.cornerRadius = 12;
  self.factImageView.clipsToBounds = YES;
  self.factImageView.backgroundColor = [UIColor systemGray6Color];
  [self.factCard addSubview:self.factImageView];
  
  // Agregar imagen placeholder
  UIImage *placeholderImage = [self createPlaceholderImage];
  self.factImageView.image = placeholderImage;
  
  // Agregar un indicador de carga para la imagen
  UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
  loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
  loadingIndicator.hidesWhenStopped = YES;
  loadingIndicator.tag = 999; // Tag para identificarlo después
  [self.factImageView addSubview:loadingIndicator];
  [NSLayoutConstraint activateConstraints:@[
    [loadingIndicator.centerXAnchor constraintEqualToAnchor:self.factImageView.centerXAnchor],
    [loadingIndicator.centerYAnchor constraintEqualToAnchor:self.factImageView.centerYAnchor]
  ]];

  self.factLabel = [UILabel new];
  self.factLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.factLabel.textColor = [UIColor labelColor];
  self.factLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
  self.factLabel.numberOfLines = 0;
  self.factLabel.textAlignment = NSTextAlignmentCenter;
  [self.factCard addSubview:self.factLabel];

  // Botones de acción
  UIStackView *buttonStack = [[UIStackView alloc] init];
  buttonStack.translatesAutoresizingMaskIntoConstraints = NO;
  buttonStack.axis = UILayoutConstraintAxisHorizontal;
  buttonStack.spacing = 12;
  buttonStack.distribution = UIStackViewDistributionFillEqually;
  [self.view addSubview:buttonStack];
  
  // Botón Favorito
  self.favoriteButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
  [self.favoriteButton setTitle:@" Favorito" forState:UIControlStateNormal];
  self.favoriteButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
  self.favoriteButton.backgroundColor = [UIColor systemGray6Color];
  self.favoriteButton.layer.cornerRadius = 12;
  self.favoriteButton.contentEdgeInsets = UIEdgeInsetsMake(12, 8, 12, 8);
  [self.favoriteButton addTarget:self action:@selector(toggleFavorite) forControlEvents:UIControlEventTouchUpInside];
  [buttonStack addArrangedSubview:self.favoriteButton];
  
  // Botón Compartir
  self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.shareButton setImage:[UIImage systemImageNamed:@"square.and.arrow.up"] forState:UIControlStateNormal];
  [self.shareButton setTitle:@" Compartir" forState:UIControlStateNormal];
  self.shareButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
  self.shareButton.backgroundColor = [UIColor systemGray6Color];
  self.shareButton.layer.cornerRadius = 12;
  self.shareButton.contentEdgeInsets = UIEdgeInsetsMake(12, 8, 12, 8);
  [self.shareButton addTarget:self action:@selector(shareFact) forControlEvents:UIControlEventTouchUpInside];
  [buttonStack addArrangedSubview:self.shareButton];

  // Botón Siguiente
  self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
  self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.nextButton setTitle:@"Siguiente Dato Curioso" forState:UIControlStateNormal];
  self.nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
  [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.nextButton.backgroundColor = [UIColor systemPurpleColor];
  self.nextButton.layer.cornerRadius = 16;
  self.nextButton.contentEdgeInsets = UIEdgeInsetsMake(14, 18, 14, 18);
  [self.nextButton addTarget:self action:@selector(nextFact) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.nextButton];

  // Layout
  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  [NSLayoutConstraint activateConstraints:@[
    [self.header.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.header.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.header.heightAnchor constraintEqualToConstant:160],

    [back.topAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.topAnchor constant:8],
    [back.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:12],

    [emoji.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:16],
    [emoji.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor constant:-16],

    [self.categoryLabel.leadingAnchor constraintEqualToAnchor:emoji.trailingAnchor constant:8],
    [self.categoryLabel.centerYAnchor constraintEqualToAnchor:emoji.centerYAnchor],

    [self.counterLabel.trailingAnchor constraintEqualToAnchor:self.header.trailingAnchor constant:-16],
    [self.counterLabel.centerYAnchor constraintEqualToAnchor:self.categoryLabel.centerYAnchor],

    [self.factCard.topAnchor constraintEqualToAnchor:self.header.bottomAnchor constant:20],
    [self.factCard.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:20],
    [self.factCard.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-20],
    
    [self.factImageView.topAnchor constraintEqualToAnchor:self.factCard.topAnchor constant:16],
    [self.factImageView.leadingAnchor constraintEqualToAnchor:self.factCard.leadingAnchor constant:16],
    [self.factImageView.trailingAnchor constraintEqualToAnchor:self.factCard.trailingAnchor constant:-16],
    [self.factImageView.heightAnchor constraintEqualToConstant:150],

    [self.factLabel.topAnchor constraintEqualToAnchor:self.factImageView.bottomAnchor constant:16],
    [self.factLabel.leadingAnchor constraintEqualToAnchor:self.factCard.leadingAnchor constant:16],
    [self.factLabel.trailingAnchor constraintEqualToAnchor:self.factCard.trailingAnchor constant:-16],
    [self.factLabel.bottomAnchor constraintEqualToAnchor:self.factCard.bottomAnchor constant:-24],
    
    [buttonStack.topAnchor constraintEqualToAnchor:self.factCard.bottomAnchor constant:16],
    [buttonStack.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:20],
    [buttonStack.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-20],
    [buttonStack.heightAnchor constraintEqualToConstant:44],

    [self.nextButton.topAnchor constraintEqualToAnchor:buttonStack.bottomAnchor constant:12],
    [self.nextButton.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:20],
    [self.nextButton.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-20],
    [self.nextButton.heightAnchor constraintEqualToConstant:50]
  ]];

  [self render];
  [self loadFactImage];
}

- (UIImage *)createPlaceholderImage {
  // Crear una imagen placeholder con gradiente y ícono
  CGSize size = CGSizeMake(400, 200);
  UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // Crear gradiente basado en la categoría
  NSArray<UIColor *> *gradientColors = [UIColor gradientForCategoryKey:self.categoryKey];
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  NSMutableArray *cgColors = [NSMutableArray array];
  for (UIColor *color in gradientColors) {
    // Hacer los colores más suaves para el placeholder
    UIColor *softColor = [color colorWithAlphaComponent:0.3];
    [cgColors addObject:(id)softColor.CGColor];
  }
  
  CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)cgColors, NULL);
  CGPoint startPoint = CGPointMake(0, 0);
  CGPoint endPoint = CGPointMake(size.width, size.height);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  
  // Añadir ícono SF Symbol en el centro
  NSString *iconName = @"photo";
  if ([self.categoryKey isEqualToString:@"ciencia"]) {
    iconName = @"sparkles";
  } else if ([self.categoryKey isEqualToString:@"historia"]) {
    iconName = @"clock";
  } else if ([self.categoryKey isEqualToString:@"tecnologia"]) {
    iconName = @"cpu";
  }
  
  UIImage *icon = [UIImage systemImageNamed:iconName];
  UIImage *tintedIcon = [icon imageWithTintColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
  CGRect iconRect = CGRectMake((size.width - 60) / 2, (size.height - 60) / 2, 60, 60);
  [tintedIcon drawInRect:iconRect];
  
  UIImage *placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
  
  return placeholderImage;
}

- (void)goBack {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)render {
  if (self.facts.count == 0) {
    self.factLabel.text = @"Sin datos disponibles";
    return;
  }
  
  self.factLabel.text = self.facts[self.index];
  self.counterLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)(self.index+1), (unsigned long)self.facts.count];
  
  // Actualizar estado del botón de favorito
  [self updateFavoriteButton];
}

- (void)updateFavoriteButton {
  NSString *currentFact = self.facts[self.index];
  BOOL isFavorite = [[FactManager sharedManager] isFavorite:currentFact];
  
  if (isFavorite) {
    [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    self.favoriteButton.tintColor = [UIColor systemPinkColor];
  } else {
    [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    self.favoriteButton.tintColor = [UIColor systemBlueColor];
  }
}

- (void)loadFactImage {
  // Obtener el dato actual
  NSString *currentFact = self.facts[self.index];
  
  // Buscar la URL de imagen correspondiente
  NSString *imageURL = self.factImageURLs[currentFact];
  
  // Si no hay URL específica, usar una imagen genérica para la categoría
  if (!imageURL) {
    if ([self.categoryKey isEqualToString:@"ciencia"]) {
      imageURL = @"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=200&fit=crop"; // Ciencia genérica
    } else if ([self.categoryKey isEqualToString:@"historia"]) {
      imageURL = @"https://images.unsplash.com/photo-1461360228754-6e81c478b882?w=400&h=200&fit=crop"; // Historia genérica
    } else {
      imageURL = @"https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&h=200&fit=crop"; // Tecnología genérica
    }
  }
  
  // Mostrar placeholder inmediatamente
  self.factImageView.image = [self createPlaceholderImage];
  
  // Mostrar indicador de carga
  UIActivityIndicatorView *loadingIndicator = (UIActivityIndicatorView *)[self.factImageView viewWithTag:999];
  [loadingIndicator startAnimating];
  
  // Cargar imagen de forma asíncrona
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    if (imageData) {
      UIImage *image = [UIImage imageWithData:imageData];
      dispatch_async(dispatch_get_main_queue(), ^{
        // Detener indicador de carga
        [loadingIndicator stopAnimating];
        
        // Mostrar imagen con animación suave de fade-in
        [UIView transitionWithView:self.factImageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                          self.factImageView.image = image;
                        } completion:nil];
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        [loadingIndicator stopAnimating];
        // En caso de error, mantener el placeholder
        NSLog(@"Error cargando imagen desde: %@", imageURL);
      });
    }
  });
}

- (void)nextFact {
  // Animación sutil
  [UIView animateWithDuration:0.15 animations:^{
    self.factCard.transform = CGAffineTransformMakeScale(0.98, 0.98);
    self.factCard.alpha = 0.8;
  } completion:^(BOOL finished) {
    self.index = (self.index + 1) % self.facts.count;
    [self render];
    [self loadFactImage]; // Cargar la imagen correspondiente al nuevo dato
    [UIView animateWithDuration:0.2 animations:^{
      self.factCard.transform = CGAffineTransformIdentity;
      self.factCard.alpha = 1.0;
    }];
  }];
}

- (void)toggleFavorite {
  NSString *currentFact = self.facts[self.index];
  
  if ([[FactManager sharedManager] isFavorite:currentFact]) {
    // Remover de favoritos
    NSDictionary *favorite = @{@"fact": currentFact, @"category": self.categoryKey};
    [[FactManager sharedManager] removeFavorite:favorite];
    
    // Animación
    [UIView animateWithDuration:0.2 animations:^{
      self.favoriteButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.2 animations:^{
        self.favoriteButton.transform = CGAffineTransformIdentity;
      }];
    }];
  } else {
    // Agregar a favoritos
    [[FactManager sharedManager] addFavorite:currentFact category:self.categoryKey];
    
    // Animación
    [UIView animateWithDuration:0.2 animations:^{
      self.favoriteButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.2 animations:^{
        self.favoriteButton.transform = CGAffineTransformIdentity;
      }];
    }];
  }
  
  [self updateFavoriteButton];
}

- (void)shareFact {
  NSString *currentFact = self.facts[self.index];
  NSString *shareText = [NSString stringWithFormat:@"¿Sabías qué? %@", currentFact];
  
  UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                          initWithActivityItems:@[shareText]
                                          applicationActivities:nil];
  
  // Para iPad
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    activityVC.popoverPresentationController.sourceView = self.shareButton;
    activityVC.popoverPresentationController.sourceRect = self.shareButton.bounds;
  }
  
  [self presentViewController:activityVC animated:YES completion:nil];
}

@end
