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
@property (nonatomic, strong) UIStackView *cardsStack;
@end

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];

  // Header degradado
  self.header = [[GradientView alloc] init];
  self.header.translatesAutoresizingMaskIntoConstraints = NO;
  self.header.colors = @[[UIColor appIndigo], [UIColor appPurple], [UIColor appPink]];
  self.header.startPoint = CGPointMake(0, 0);
  self.header.endPoint   = CGPointMake(1, 1);
  [self.view addSubview:self.header];

  self.helloLabel = [UILabel new];
  self.helloLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.helloLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
  self.helloLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
  self.helloLabel.text = @"Hola";
  [self.header addSubview:self.helloLabel];

  self.titleLabel = [UILabel new];
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.titleLabel.textColor = [UIColor whiteColor];
  self.titleLabel.font = [UIFont boldSystemFontOfSize:32];
  self.titleLabel.text = @"Descubre Hoy";
  [self.header addSubview:self.titleLabel];

  // Contenedor de tarjetas
  self.cardsStack = [[UIStackView alloc] init];
  self.cardsStack.translatesAutoresizingMaskIntoConstraints = NO;
  self.cardsStack.axis = UILayoutConstraintAxisVertical;
  self.cardsStack.spacing = 16;
  [self.view addSubview:self.cardsStack];

  // Crear 3 tarjetas
  for (NSString *key in [FactProvider categories]) {
    [self addCardForCategory:key];
  }

  // Layout
  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  [NSLayoutConstraint activateConstraints:@[
    [self.header.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.header.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.header.heightAnchor constraintEqualToConstant:240],

    [self.helloLabel.topAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.topAnchor constant:16],
    [self.helloLabel.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:20],

    [self.titleLabel.topAnchor constraintEqualToAnchor:self.helloLabel.bottomAnchor constant:8],
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:20],

    [self.cardsStack.topAnchor constraintEqualToAnchor:self.header.bottomAnchor constant:-32],
    [self.cardsStack.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:20],
    [self.cardsStack.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-20]
  ]];
}

- (void)addCardForCategory:(NSString *)key {
  // Contenedor tarjeta
  CardView *card = [[CardView alloc] init];
  card.translatesAutoresizingMaskIntoConstraints = NO;

  // Fondo con borde degradado simulando “chip”
  GradientView *border = [[GradientView alloc] init];
  border.translatesAutoresizingMaskIntoConstraints = NO;
  border.colors = [UIColor gradientForCategoryKey:key];
  border.layer.cornerRadius = 18;
  [card addSubview:border];

  UIView *inner = [[UIView alloc] init];
  inner.translatesAutoresizingMaskIntoConstraints = NO;
  inner.backgroundColor = [UIColor systemBackgroundColor];
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
  subtitle.text = @"Toca para explorar";
  [inner addSubview:subtitle];

  UIButton *action = [UIButton buttonWithType:UIButtonTypeSystem];
  action.translatesAutoresizingMaskIntoConstraints = NO;
  [action setImage:[UIImage systemImageNamed:@"chevron.right"] forState:UIControlStateNormal];
  action.tintColor = [UIColor whiteColor];
  action.backgroundColor = [UIColor systemPurpleColor];
  action.layer.cornerRadius = 20;
  action.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
  action.accessibilityLabel = title.text;
  action.tag = [[FactProvider categories] indexOfObject:key]; // 0/1/2
  [action addTarget:self action:@selector(openCategory:) forControlEvents:UIControlEventTouchUpInside];
  [inner addSubview:action];

  [self.cardsStack addArrangedSubview:card];
  [NSLayoutConstraint activateConstraints:@[
    [card.heightAnchor constraintEqualToConstant:100],

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

    [title.topAnchor constraintEqualToAnchor:inner.topAnchor constant:20],
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
