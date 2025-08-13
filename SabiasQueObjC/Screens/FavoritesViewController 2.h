#import "FavoritesViewController.h"
#import "GradientView.h"
#import "UIColor+App.h"
#import "FactManager.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) GradientView *header;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *favorites;
@end

@implementation FavoritesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
  
  // Inicializar favoritos
  self.favorites = [[FactManager sharedManager] getFavorites];
  
  // Header
  self.header = [[GradientView alloc] init];
  self.header.translatesAutoresizingMaskIntoConstraints = NO;
  self.header.colors = @[[UIColor systemPinkColor], [UIColor systemPurpleColor]];
  self.header.startPoint = CGPointMake(0, 0);
  self.header.endPoint = CGPointMake(1, 1);
  [self.view addSubview:self.header];
  
  self.titleLabel = [UILabel new];
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.titleLabel.text = @"Favoritos";
  self.titleLabel.font = [UIFont boldSystemFontOfSize:32];
  self.titleLabel.textColor = [UIColor whiteColor];
  [self.header addSubview:self.titleLabel];
  
  UILabel *subtitleLabel = [UILabel new];
  subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  subtitleLabel.text = @"Tus datos curiosos guardados";
  subtitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
  subtitleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
  [self.header addSubview:subtitleLabel];
  
  // TableView
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
  self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 100;
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FactCell"];
  [self.view addSubview:self.tableView];
  
  // Empty state
  self.emptyLabel = [UILabel new];
  self.emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.emptyLabel.text = @"No tienes favoritos aún\n❤️\nGuarda tus datos curiosos favoritos";
  self.emptyLabel.numberOfLines = 0;
  self.emptyLabel.textAlignment = NSTextAlignmentCenter;
  self.emptyLabel.font = [UIFont systemFontOfSize:16];
  self.emptyLabel.textColor = [UIColor secondaryLabelColor];
  self.emptyLabel.hidden = self.favorites.count > 0;
  [self.view addSubview:self.emptyLabel];
  
  // Layout
  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  [NSLayoutConstraint activateConstraints:@[
    [self.header.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.header.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.header.heightAnchor constraintEqualToConstant:140],
    
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:20],
    [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor constant:-30],
    
    [subtitleLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
    [subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:4],
    
    [self.tableView.topAnchor constraintEqualToAnchor:self.header.bottomAnchor],
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.tableView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor],
    
    [self.emptyLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [self.emptyLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
  ]];
  
  // Notificación para actualizar favoritos
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(updateFavorites) 
                                               name:@"FavoritesUpdated" 
                                             object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateFavorites];
}

- (void)updateFavorites {
  self.favorites = [[FactManager sharedManager] getFavorites];
  self.emptyLabel.hidden = self.favorites.count > 0;
  [self.tableView reloadData];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.favorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FactCell" forIndexPath:indexPath];
  
  NSDictionary *favorite = self.favorites[indexPath.row];
  NSString *fact = favorite[@"fact"];
  NSString *category = favorite[@"category"];
  NSString *emoji = favorite[@"emoji"];
  
  // Configurar celda personalizada
  cell.textLabel.text = fact;
  cell.textLabel.numberOfLines = 0;
  cell.textLabel.font = [UIFont systemFontOfSize:15];
  
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", emoji, [category capitalizedString]];
  cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
  cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  // Mostrar alerta con el dato completo
  NSDictionary *favorite = self.favorites[indexPath.row];
  NSString *fact = favorite[@"fact"];
  NSString *category = favorite[@"category"];
  
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:[category capitalizedString]
                                                                 message:fact
                                                          preferredStyle:UIAlertControllerStyleAlert];
  
  [alert addAction:[UIAlertAction actionWithTitle:@"Compartir" 
                                             style:UIAlertActionStyleDefault 
                                           handler:^(UIAlertAction *action) {
    [self shareFact:fact];
  }]];
  
  [alert addAction:[UIAlertAction actionWithTitle:@"Eliminar" 
                                             style:UIAlertActionStyleDestructive 
                                           handler:^(UIAlertAction *action) {
    [[FactManager sharedManager] removeFavorite:favorite];
    [self updateFavorites];
  }]];
  
  [alert addAction:[UIAlertAction actionWithTitle:@"Cerrar" 
                                             style:UIAlertActionStyleCancel 
                                           handler:nil]];
  
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)shareFact:(NSString *)fact {
  NSString *shareText = [NSString stringWithFormat:@"¿Sabías qué? %@", fact];
  UIActivityViewController *activityVC = [[UIActivityViewController alloc] 
                                          initWithActivityItems:@[shareText] 
                                          applicationActivities:nil];
  [self presentViewController:activityVC animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSDictionary *favorite = self.favorites[indexPath.row];
    [[FactManager sharedManager] removeFavorite:favorite];
    [self updateFavorites];
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
