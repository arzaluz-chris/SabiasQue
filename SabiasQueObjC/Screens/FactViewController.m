#import "FactViewController.h"
#import "GradientView.h"
#import "CardView.h"
#import "UIColor+App.h"
#import "FactProvider.h"

@interface FactViewController ()
@property (nonatomic, copy) NSString *categoryKey;
@property (nonatomic, strong) NSArray<NSString *> *facts;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) GradientView *header;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *counterLabel;

@property (nonatomic, strong) CardView *factCard;
@property (nonatomic, strong) UILabel *factLabel;

@property (nonatomic, strong) UIButton *nextButton;
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

  self.factLabel = [UILabel new];
  self.factLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.factLabel.textColor = [UIColor labelColor];
  self.factLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
  self.factLabel.numberOfLines = 0;
  self.factLabel.textAlignment = NSTextAlignmentCenter;
  [self.factCard addSubview:self.factLabel];

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

    [self.factLabel.topAnchor constraintEqualToAnchor:self.factCard.topAnchor constant:24],
    [self.factLabel.leadingAnchor constraintEqualToAnchor:self.factCard.leadingAnchor constant:16],
    [self.factLabel.trailingAnchor constraintEqualToAnchor:self.factCard.trailingAnchor constant:-16],
    [self.factLabel.bottomAnchor constraintEqualToAnchor:self.factCard.bottomAnchor constant:-24],

    [self.nextButton.topAnchor constraintEqualToAnchor:self.factCard.bottomAnchor constant:16],
    [self.nextButton.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:20],
    [self.nextButton.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-20]
  ]];

  [self render];
}

- (void)goBack {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)render {
  if (self.facts.count == 0) { self.factLabel.text = @"Sin datos disponibles"; return; }
  self.factLabel.text = self.facts[self.index];
  self.counterLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)(self.index+1), (unsigned long)self.facts.count];
}

- (void)nextFact {
  // Animación sutil: “tap to refresh”
  [UIView animateWithDuration:0.15 animations:^{
    self.factCard.transform = CGAffineTransformMakeScale(0.98, 0.98);
    self.factCard.alpha = 0.8;
  } completion:^(BOOL finished) {
    self.index = (self.index + 1) % self.facts.count;
    [self render];
    [UIView animateWithDuration:0.2 animations:^{
      self.factCard.transform = CGAffineTransformIdentity;
      self.factCard.alpha = 1.0;
    }];
  }];
}

@end
