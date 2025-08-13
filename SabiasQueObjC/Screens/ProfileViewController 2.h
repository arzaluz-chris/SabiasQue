#import "ProfileViewController.h"
#import "GradientView.h"
#import "UIColor+App.h"
#import "FactManager.h"

@interface ProfileViewController ()
@property (nonatomic, strong) GradientView *header;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UIStackView *statsStack;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
  
  // ScrollView
  self.scrollView = [[UIScrollView alloc] init];
  self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.scrollView];
  
  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.scrollView addSubview:contentView];
  
  // Header
  self.header = [[GradientView alloc] init];
  self.header.translatesAutoresizingMaskIntoConstraints = NO;
  self.header.colors = @[[UIColor systemTealColor], [UIColor systemBlueColor]];
  self.header.startPoint = CGPointMake(0, 0);
  self.header.endPoint = CGPointMake(1, 1);
  [contentView addSubview:self.header];
  
  // Imagen de perfil con URL
  self.profileImageView = [[UIImageView alloc] init];
  self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
  self.profileImageView.layer.cornerRadius = 50;
  self.profileImageView.clipsToBounds = YES;
  self.profileImageView.backgroundColor = [UIColor systemGray5Color];
  self.profileImageView.layer.borderWidth = 3;
  self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
  [contentView addSubview:self.profileImageView];
  
  // Cargar imagen de perfil desde URL
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *avatarURL = @"https://ui-avatars.com/api/?name=Usuario&size=200&background=7c3aed&color=fff";
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:avatarURL]];
    if (imageData) {
      UIImage *image = [UIImage imageWithData:imageData];
      dispatch_async(dispatch_get_main_queue(), ^{
        self.profileImageView.image = image;
      });
    }
  });
  
  self.nameLabel = [UILabel new];
  self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.nameLabel.text = @"Usuario Demo";
  self.nameLabel.font = [UIFont boldSystemFontOfSize:24];
  self.nameLabel.textColor = [UIColor labelColor];
  self.nameLabel.textAlignment = NSTextAlignmentCenter;
  [contentView addSubview:self.nameLabel];
  
  self.emailLabel = [UILabel new];
  self.emailLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.emailLabel.text = @"usuario@ejemplo.com";
  self.emailLabel.font = [UIFont systemFontOfSize:14];
  self.emailLabel.textColor = [UIColor secondaryLabelColor];
  self.emailLabel.textAlignment = NSTextAlignmentCenter;
  [contentView addSubview:self.emailLabel];
  
  // Estadísticas
  UILabel *statsTitle = [UILabel new];
  statsTitle.translatesAutoresizingMaskIntoConstraints = NO;
  statsTitle.text = @"Estadísticas";
  statsTitle.font = [UIFont boldSystemFontOfSize:20];
  statsTitle.textColor = [UIColor labelColor];
  [contentView addSubview:statsTitle];
  
  self.statsStack = [[UIStackView alloc] init];
  self.statsStack.translatesAutoresizingMaskIntoConstraints = NO;
  self.statsStack.axis = UILayoutConstraintAxisVertical;
  self.statsStack.spacing = 12;
  self.statsStack.distribution = UIStackViewDistributionFillEqually;
  [contentView addSubview:self.statsStack];
  
  // Crear tarjetas de estadísticas
  [self createStatCard:@"📚" title:@"Datos Leídos" value:@"247"];
  [self createStatCard:@"❤️" title:@"Favoritos" value:[NSString stringWithFormat:@"%lu", (unsigned long)[[FactManager sharedManager] getFavorites].count]];
  [self createStatCard:@"🔥" title:@"Racha" value:@"7 días"];
  [self createStatCard:@"⭐" title:@"Categoría Favorita" value:@"Ciencia"];
  
  // Configuración
  UILabel *settingsTitle = [UILabel new];
  settingsTitle.translatesAutoresizingMaskIntoConstraints = NO;
  settingsTitle.text = @"Configuración";
  settingsTitle.font = [UIFont boldSystemFontOfSize:20];
  settingsTitle.textColor = [UIColor labelColor];
  [contentView addSubview:settingsTitle];
  
  // Botones de configuración
  UIStackView *settingsStack = [[UIStackView alloc] init];
  settingsStack.translatesAutoresizingMaskIntoConstraints = NO;
  settingsStack.axis = UILayoutConstraintAxisVertical;
  settingsStack.spacing = 12;
  [contentView addSubview:settingsStack];
  
  [self createSettingButton:@"🔔" title:@"Notificaciones" stack:settingsStack];
  [self createSettingButton:@"🌙" title:@"Modo Oscuro" stack:settingsStack];
  [self createSettingButton:@"ℹ️" title:@"Acerca de" stack:settingsStack];
  [self createSettingButton:@"⭐" title:@"Calificar App" stack:settingsStack];
  
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
    [self.header.heightAnchor constraintEqualToConstant:150],
    
    // Profile Image
    [self.profileImageView.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
    [self.profileImageView.centerYAnchor constraintEqualToAnchor:self.header.bottomAnchor],
    [self.profileImageView.widthAnchor constraintEqualToConstant:100],
    [self.profileImageView.heightAnchor constraintEqualToConstant:100],
    
    // Name & Email
    [self.nameLabel.topAnchor constraintEqualToAnchor:self.profileImageView.bottomAnchor constant:16],
    [self.nameLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
    [self.nameLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
    
    [self.emailLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:4],
    [self.emailLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
    [self.emailLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
    
    // Stats
    [statsTitle.topAnchor constraintEqualToAnchor:self.emailLabel.bottomAnchor constant:32],
    [statsTitle.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
    
    [self.statsStack.topAnchor constraintEqualToAnchor:statsTitle.bottomAnchor constant:16],
    [self.statsStack.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
    [self.statsStack.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
    
    // Settings
    [settingsTitle.topAnchor constraintEqualToAnchor:self.statsStack.bottomAnchor constant:32],
    [settingsTitle.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
    
    [settingsStack.topAnchor constraintEqualToAnchor:settingsTitle.bottomAnchor constant:16],
    [settingsStack.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
    [settingsStack.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
    [settingsStack.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-30]
  ]];
}

- (void)createStatCard:(NSString *)emoji title:(NSString *)title value:(NSString *)value {
  UIView *card = [[UIView alloc] init];
  card.backgroundColor = [UIColor systemBackgroundColor];
  card.layer.cornerRadius = 12;
  card.layer.shadowColor = [UIColor blackColor].CGColor;
  card.layer.shadowOpacity = 0.05;
  card.layer.shadowRadius = 8;
  card.layer.shadowOffset = CGSizeMake(0, 2);
  
  UILabel *emojiLabel = [UILabel new];
  emojiLabel.translatesAutoresizingMaskIntoConstraints = NO;
  emojiLabel.text = emoji;
  emojiLabel.font = [UIFont systemFontOfSize:24];
  [card addSubview:emojiLabel];
  
  UILabel *titleLabel = [UILabel new];
  titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  titleLabel.text = title;
  titleLabel.font = [UIFont systemFontOfSize:14];
  titleLabel.textColor = [UIColor secondaryLabelColor];
  [card addSubview:titleLabel];
  
  UILabel *valueLabel = [UILabel new];
  valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
  valueLabel.text = value;
  valueLabel.font = [UIFont boldSystemFontOfSize:20];
  valueLabel.textColor = [UIColor labelColor];
  [card addSubview:valueLabel];
  
  [self.statsStack addArrangedSubview:card];
  
  [NSLayoutConstraint activateConstraints:@[
    [card.heightAnchor constraintEqualToConstant:70],
    
    [emojiLabel.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16],
    [emojiLabel.centerYAnchor constraintEqualToAnchor:card.centerYAnchor],
    
    [titleLabel.leadingAnchor constraintEqualToAnchor:emojiLabel.trailingAnchor constant:12],
    [titleLabel.topAnchor constraintEqualToAnchor:card.topAnchor constant:16],
    
    [valueLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
    [valueLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:4]
  ]];
}

- (void)createSettingButton:(NSString *)emoji title:(NSString *)title stack:(UIStackView *)stack {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  button.backgroundColor = [UIColor systemBackgroundColor];
  button.layer.cornerRadius = 12;
  button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  button.contentEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16);
  
  NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] init];
  [attributedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", emoji] 
                                                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]}]];
  [attributedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:title 
                                                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], 
                                                                                      NSForegroundColorAttributeName: [UIColor labelColor]}]];
  [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
  
  [button addTarget:self action:@selector(settingTapped:) forControlEvents:UIControlEventTouchUpInside];
  button.tag = stack.arrangedSubviews.count;
  
  [stack addArrangedSubview:button];
  
  [NSLayoutConstraint activateConstraints:@[
    [button.heightAnchor constraintEqualToConstant:56]
  ]];
}

- (void)settingTapped:(UIButton *)sender {
  NSString *message = @"Esta función estará disponible próximamente";
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Configuración" 
                                                                 message:message 
                                                          preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  // Actualizar contador de favoritos
  NSUInteger favCount = [[FactManager sharedManager] getFavorites].count;
  // Actualizar la tarjeta de favoritos si es necesario
}

@end
