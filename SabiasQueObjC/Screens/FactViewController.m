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
@end

@implementation FactViewController

- (instancetype)initWithCategory:(NSString *)key {
  if (self = [super init]) {
    _categoryKey = key ?: @"ciencia";
    _facts = [FactProvider factsForCategory:_categoryKey];
    _index = 0;
  }
  return self;
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
  // Cargar imagen relacionada con la categoría desde URL
  NSArray *scienceImages = @[
    @"https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=400&h=200&fit=crop"
  ];
  
  NSArray *historyImages = @[
    @"https://images.unsplash.com/photo-1461360228754-6e81c478b882?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1529651737248-dad5e287768e?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1447069387593-a5de0862481e?w=400&h=200&fit=crop"
  ];
  
  NSArray *techImages = @[
    @"https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1488590528505-98d2b5aba04b?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400&h=200&fit=crop",
    @"https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=200&fit=crop"
  ];
  
  NSArray *images;
  if ([self.categoryKey isEqualToString:@"ciencia"]) {
    images = scienceImages;
  } else if ([self.categoryKey isEqualToString:@"historia"]) {
    images = historyImages;
  } else {
    images = techImages;
  }
  
  NSString *imageURL = images[self.index % images.count];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    if (imageData) {
      UIImage *image = [UIImage imageWithData:imageData];
      dispatch_async(dispatch_get_main_queue(), ^{
        self.factImageView.image = image;
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
    [self loadFactImage];
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
