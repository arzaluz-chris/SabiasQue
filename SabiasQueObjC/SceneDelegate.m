#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "FavoritesViewController.h"
#import "ProfileViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
  if (![scene isKindOfClass:[UIWindowScene class]]) return;
  UIWindowScene *windowScene = (UIWindowScene *)scene;
  self.window = [[UIWindow alloc] initWithWindowScene:windowScene];

  // Tab 1: Home con NavigationController
  HomeViewController *home = [[HomeViewController alloc] init];
  UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
  homeNav.navigationBarHidden = YES;
  homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Inicio"
                                                      image:[UIImage systemImageNamed:@"house.fill"]
                                                        tag:0];

  // Tab 2: Favoritos
  FavoritesViewController *favorites = [[FavoritesViewController alloc] init];
  UINavigationController *favNav = [[UINavigationController alloc] initWithRootViewController:favorites];
  favNav.navigationBarHidden = YES;
  favNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favoritos"
                                                     image:[UIImage systemImageNamed:@"heart.fill"]
                                                       tag:1];

  // Tab 3: Perfil
  ProfileViewController *profile = [[ProfileViewController alloc] init];
  UINavigationController *profNav = [[UINavigationController alloc] initWithRootViewController:profile];
  profNav.navigationBarHidden = YES;
  profNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Perfil"
                                                      image:[UIImage systemImageNamed:@"person.fill"]
                                                        tag:2];

  // TabBarController
  UITabBarController *tabBarController = [[UITabBarController alloc] init];
  tabBarController.viewControllers = @[homeNav, favNav, profNav];
  
  // Estilo del TabBar
  tabBarController.tabBar.tintColor = [UIColor systemPurpleColor];
  tabBarController.tabBar.backgroundColor = [UIColor systemBackgroundColor];
  
  self.window.rootViewController = tabBarController;
  [self.window makeKeyAndVisible];
}

@end
