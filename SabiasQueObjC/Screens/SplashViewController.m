#import "SplashViewController.h"
#import "GradientView.h"
#import "HomeViewController.h"
#import "UIColor+App.h"

@interface SplashViewController ()
@property (nonatomic, strong) GradientView *bg;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *ctaButton;
@end

@implementation SplashViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor systemBackgroundColor];

  // Fondo degradado
  self.bg = [[GradientView alloc] init];
  self.bg.translatesAutoresizingMaskIntoConstraints = NO;
  self.bg.colors = @[[UIColor appIndigo], [UIColor appPurple], [UIColor appPink]];
  self.bg.startPoint = CGPointMake(0, 0);
  self.bg.endPoint   = CGPointMake(1, 1);
  self.bg.layer.cornerRadius = 0;
  [self.view addSubview:self.bg];

  // Icono (SF Symbol sparkles)
  self.iconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"sparkles"]];
  self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
  self.iconView.tintColor = [UIColor whiteColor];
  self.iconView.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:self.iconView];

  // Título
  self.titleLabel = [[UILabel alloc] init];
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.titleLabel.text = @"¿Sabías qué?";
  self.titleLabel.font = [UIFont boldSystemFontOfSize:36];
  self.titleLabel.textColor = [UIColor whiteColor];
  [self.view addSubview:self.titleLabel];

  // Botón “Explorar” (por si el usuario no quiere esperar)
  self.ctaButton = [UIButton buttonWithType:UIButtonTypeSystem];
  self.ctaButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.ctaButton setTitle:@"Explorar" forState:UIControlStateNormal];
  self.ctaButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
  [self.ctaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.ctaButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
  self.ctaButton.layer.cornerRadius = 22;
  self.ctaButton.contentEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 24);
  [self.ctaButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.ctaButton];

  // Auto Layout
  [NSLayoutConstraint activateConstraints:@[
    [self.bg.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.bg.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.bg.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.bg.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

    [self.iconView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [self.iconView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-60],
    [self.iconView.widthAnchor constraintEqualToConstant:120],
    [self.iconView.heightAnchor constraintEqualToConstant:120],

    [self.titleLabel.topAnchor constraintEqualToAnchor:self.iconView.bottomAnchor constant:16],
    [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],

    [self.ctaButton.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:24],
    [self.ctaButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
  ]];

  // Animación simple y paso automático a Home
  self.iconView.alpha = 0.0;
  self.titleLabel.alpha = 0.0;
  [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.iconView.alpha = 1.0;
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.5 animations:^{
      self.titleLabel.alpha = 1.0;
    }];
  }];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self goHome];
  });
}

- (void)goHome {
  if (self.navigationController.viewControllers.count > 1) return;
  HomeViewController *home = [[HomeViewController alloc] init];
  self.navigationController.navigationBarHidden = YES;
  [self.navigationController setViewControllers:@[home] animated:YES];
}

@end
