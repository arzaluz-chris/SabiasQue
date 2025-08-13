#import "SceneDelegate.h"
#import "SplashViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
  if (![scene isKindOfClass:[UIWindowScene class]]) return;
  UIWindowScene *windowScene = (UIWindowScene *)scene;
  self.window = [[UIWindow alloc] initWithWindowScene:windowScene];

  // Root: UINavigationController con Splash inicial
  UIViewController *splash = [[SplashViewController alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:splash];
  nav.navigationBarHidden = YES;

  self.window.rootViewController = nav;
  [self.window makeKeyAndVisible];
}

@end
