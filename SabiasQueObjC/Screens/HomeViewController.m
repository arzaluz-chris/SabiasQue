#import "HomeViewController.h"
#import "GradientView.h"
#import "CardView.h"
#import "UIColor+App.h"
#import "FactProvider.h"
#import "FactViewController.h"

@interface HomeViewController ()
@property (nonatomic, strong) GradientView *header;
@property (nonatomic, strong) UILabel *helloLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *factOfDayLabel;
@property (nonatomic, strong) UIView *factOfDayCard;
@property (nonatomic, strong) UIStackView *cardsStack;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
  
  // ScrollView para contenido
  self.scrollView = [[UIScrollView alloc] init];
  self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.scrollView];
  
  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.scrollView addSubview:contentView];

  // Header degradado
  self.header = [[GradientView alloc] init];
  self.header.translatesAutoresizingMaskIntoConstraints = NO;
  self.header.colors = @[[UIColor appIndigo], [UIColor appPurple], [UIColor appPink]];
  self.header.startPoint = CGPointMake(0, 0);
  self.header.endPoint   = CGPointMake(1, 1);
  [contentView addSubview:self.header];

  self.helloLabel = [UILabel new];
  self.helloLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.helloLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
  self.helloLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
  self.helloLabel.text = @"Hola 👋";
  [self.header addSubview:self.helloLabel];

  self.titleLabel = [UILabel new];
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.titleLabel.textColor = [UIColor whiteColor];
  self.titleLabel.font = [UIFont boldSystemFontOfSize:32];
  self.titleLabel.text = @"Descubre Hoy";
  [self.header addSubview:self.titleLabel];
  
  // Dato del día
  self.factOfDayCard = [[UIView alloc] init];
  self.factOfDayCard.translatesAutoresizingMaskIntoConstraints = NO;
  self.factOfDayCard.backgroundColor = [UIColor systemBackgroundColor];
  self.factOfDayCard.layer.cornerRadius = 16;
  self.factOfDayCard.layer.shadowColor = [UIColor blackColor].CGColor;
  self.factOfDayCard.layer.shadowOpacity = 0.1;
  self.factOfDayCard.layer.shadowRadius = 10;
  self.factOfDayCard.layer.shadowOffset = CGSizeMake(0, 4);
  [contentView addSubview:self.factOfDayCard];
  
  UILabel *dailyIcon = [UILabel new];
  dailyIcon.translatesAutoresizingMaskIntoConstraints = NO;
  dailyIcon.text = @"💡";
  dailyIcon.font = [UIFont systemFontOfSize:24];
  [self.factOfDayCard addSubview:dailyIcon];
  
  UILabel *dailyTitle = [UILabel new];
  dailyTitle.translatesAutoresizingMaskIntoConstraints = NO;
  dailyTitle.text = @"Dato del día";
  dailyTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
  dailyTitle.textColor = [UIColor secondaryLabelColor];
  [self.factOfDayCard addSubview:dailyTitle];
  
  self.factOfDayLabel = [UILabel new];
  self.factOfDayLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.factOfDayLabel.text = @"El Sol es 400 veces más grande que la Luna";
  self.factOfDayLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
  self.factOfDayLabel.textColor = [UIColor labelColor];
  self.factOfDayLabel.numberOfLines = 2;
  [self.factOfDayCard addSubview:self.factOfDayLabel];

  // Título de categorías
  UILabel *catTitle = [UILabel new];
  catTitle.translatesAutoresizingMaskIntoConstraints = NO;
  catTitle.text = @"Categorías Populares";
  catTitle.font = [UIFont boldSystemFontOfSize:20];
  catTitle.textColor = [UIColor labelColor];
  [contentView addSubview:catTitle];

  // Contenedor de tarjetas
  self.cardsStack = [[UIStackView alloc] init];
  self.cardsStack.translatesAutoresizingMaskIntoConstraints = NO;
  self.cardsStack.axis = UILayoutConstraintAxisVertical;
  self.cardsStack.spacing = 16;
  [contentView addSubview:self.cardsStack];

  // Crear 3 tarjetas
  for (NSString *key in [FactProvider categories]) {
    [self addCardForCategory:key];
  }

  // Layout
  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  [NSLayoutConstraint activateConstraints:@[
    // ScrollView
    [self.scrollView.topAnchor constraintEqualToAnchor:guide.topAnchor],
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.scrollView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor],
    
    // ContentView
    [contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
    [contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
    [contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
    [contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
    [contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],
    
    // Header
    [self.header.topAnchor constraintEqualToAnchor:contentView.topAnchor],
    [self.header.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
    [self.header.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
    [self.header.heightAnchor constraintEqualToConstant:200],

    [self.helloLabel.topAnchor constraintEqualToAnchor:self.header.topAnchor constant:50],
    [self.helloLabel.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:20],

    [self.titleLabel.topAnchor constraintEqualToAnchor:self.helloLabel.bottomAnchor constant:8],
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:20],
    
    // Dato del día
    [self.factOfDayCard.topAnchor constraintEqualToAnchor:self.header.bottomAnchor constant:-30],
    [self.factOfDayCard.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
    [self.factOfDayCard.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
    [self.factOfDayCard.heightAnchor constraintEqualToConstant:80],
    
    [dailyIcon.leadingAnchor constraintEqualToAnchor:self.factOfDayCard.leadingAnchor constant:16],
    [dailyIcon.centerYAnchor constraintEqualToAnchor:self.factOfDayCard.centerYAnchor],
    
    [dailyTitle.topAnchor constraintEqualToAnchor:self.factOfDayCard.topAnchor constant:16],
    [dailyTitle.leadingAnchor constraintEqualToAnchor:dailyIcon.trailingAnchor constant:12],
    
    [self.factOfDayLabel.topAnchor constraintEqualToAnchor:dailyTitle.bottomAnchor constant:4],
    [self.factOfDayLabel.leadingAnchor constraintEqualToAnchor:dailyTitle.leadingAnchor],
    [self.factOfDayLabel.trailingAnchor constraintEqualToAnchor:self.factOfDayCard.trailingAnchor constant:-16],
    
    // Categorías
    [catTitle.topAnchor constraintEqualToAnchor:self.factOfDayCard.bottomAnchor constant:24],
    [catTitle.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],

    [self.cardsStack.topAnchor constraintEqualToAnchor:catTitle.bottomAnchor constant:16],
    [self.cardsStack.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
    [self.cardsStack.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
    [self.cardsStack.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-20]
  ]];
}

- (void)addCardForCategory:(NSString *)key {
  // Contenedor tarjeta
  CardView *card = [[CardView alloc] init];
  card.translatesAutoresizingMaskIntoConstraints = NO;

  // Imagen de fondo (usando URLs de imágenes de Unsplash)
  UIImageView *bgImage = [[UIImageView alloc] init];
  bgImage.translatesAutoresizingMaskIntoConstraints = NO;
  bgImage.contentMode = UIViewContentModeScaleAspectFill;
  bgImage.layer.cornerRadius = 20;
  bgImage.clipsToBounds = YES;
  bgImage.alpha = 0.3;
  
  // Cargar imagen desde URL según categoría
  NSString *imageURL = @"";
  if ([key isEqualToString:@"ciencia"]) {
    imageURL = @"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=150&fit=crop";
  } else if ([key isEqualToString:@"historia"]) {
    imageURL = @"https://images.unsplash.com/photo-1461360228754-6e81c478b882?w=400&h=150&fit=crop";
  } else {
    imageURL = @"https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&h=150&fit=crop";
  }
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    if (imageData) {
      UIImage *image = [UIImage imageWithData:imageData];
      dispatch_async(dispatch_get_main_queue(), ^{
        bgImage.image = image;
      });
    }
  });
  
  [card addSubview:bgImage];

  // Fondo con borde degradado
  GradientView *border = [[GradientView alloc] init];
  border.translatesAutoresizingMaskIntoConstraints = NO;
  border.colors = [UIColor gradientForCategoryKey:key];
  border.layer.cornerRadius = 18;
  [card addSubview:border];

  UIView *inner = [[UIView alloc] init];
  inner.translatesAutoresizingMaskIntoConstraints = NO;
  inner.backgroundColor = [[UIColor systemBackgroundColor] colorWithAlphaComponent:0.95];
  inner.layer.cornerRadius = 16;
  [card addSubview:inner];

  UILabel *emoji = [UILabel new];
  emoji.translatesAutoresizingMaskIntoConstraints = NO;
  emoji.text = [FactProvider emojiForCategory:key];
  emoji.font = [UIFont systemFontOfSize:36];
  [inner addSubview:emoji];

  UILabel *title = [UILabel new];
  title.translatesAutoresizingMaskIntoConstraints = NO;
  title.font = [UIFont boldSystemFontOfSize:18];
  if ([key isEqualToString:@"ciencia"]) title.text = @"Ciencia y Naturaleza";
  else if ([key isEqualToString:@"historia"]) title.text = @"Historia y Cultura";
  else title.text = @"Tecnología y Futuro";
  [inner addSubview:title];

  UILabel *subtitle = [UILabel new];
  subtitle.translatesAutoresizingMaskIntoConstraints = NO;
  subtitle.textColor = [UIColor secondaryLabelColor];
  subtitle.font = [UIFont systemFontOfSize:14];
  NSInteger count = [FactProvider factsForCategory:key].count;
  subtitle.text = [NSString stringWithFormat:@"%ld datos curiosos", (long)count];
  [inner addSubview:subtitle];

  UIButton *action = [UIButton buttonWithType:UIButtonTypeSystem];
  action.translatesAutoresizingMaskIntoConstraints = NO;
  [action setImage:[UIImage systemImageNamed:@"chevron.right"] forState:UIControlStateNormal];
  action.tintColor = [UIColor whiteColor];
  action.backgroundColor = [UIColor systemPurpleColor];
  action.layer.cornerRadius = 20;
  action.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
  action.accessibilityLabel = title.text;
  action.tag = [[FactProvider categories] indexOfObject:key];
  [action addTarget:self action:@selector(openCategory:) forControlEvents:UIControlEventTouchUpInside];
  [inner addSubview:action];

  [self.cardsStack addArrangedSubview:card];
  [NSLayoutConstraint activateConstraints:@[
    [card.heightAnchor constraintEqualToConstant:120],
    
    [bgImage.topAnchor constraintEqualToAnchor:card.topAnchor],
    [bgImage.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
    [bgImage.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
    [bgImage.bottomAnchor constraintEqualToAnchor:card.bottomAnchor],

    [border.topAnchor constraintEqualToAnchor:card.topAnchor],
    [border.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
    [border.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
    [border.bottomAnchor constraintEqualToAnchor:card.bottomAnchor],

    [inner.topAnchor constraintEqualToAnchor:card.topAnchor constant:2],
    [inner.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:2],
    [inner.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-2],
    [inner.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-2],

    [emoji.centerYAnchor constraintEqualToAnchor:inner.centerYAnchor],
    [emoji.leadingAnchor constraintEqualToAnchor:inner.leadingAnchor constant:16],

    [title.topAnchor constraintEqualToAnchor:inner.topAnchor constant:28],
    [title.leadingAnchor constraintEqualToAnchor:emoji.trailingAnchor constant:12],
    [title.trailingAnchor constraintLessThanOrEqualToAnchor:action.leadingAnchor constant:-12],

    [subtitle.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:4],
    [subtitle.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
    [subtitle.trailingAnchor constraintLessThanOrEqualToAnchor:action.leadingAnchor constant:-12],

    [action.centerYAnchor constraintEqualToAnchor:inner.centerYAnchor],
    [action.trailingAnchor constraintEqualToAnchor:inner.trailingAnchor constant:-12],
    [action.widthAnchor constraintEqualToConstant:40],
    [action.heightAnchor constraintEqualToConstant:40]
  ]];
}

- (void)openCategory:(UIButton *)sender {
  NSArray *cats = [FactProvider categories];
  NSString *key = (sender.tag >= 0 && sender.tag < (NSInteger)cats.count) ? cats[sender.tag] : @"ciencia";
  FactViewController *vc = [[FactViewController alloc] initWithCategory:key];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
