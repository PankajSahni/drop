//
//  AppDelegate.m
//  droptwo
//
//  Created by Mac on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//str

#import "AppDelegate.h"

#import "ViewController.h"
#import "LoginViewController.h"
#import "GlobalSingleton.h"
#import "ViewModel.h"
NSString *const SCSessionStateChangedNotification = @"com.facebook.Scrumptious:SCSessionStateChangedNotification";
@interface AppDelegate ()

@property (readonly) GlobalUtility *globalUtilityObject;

@property (strong, nonatomic) UINavigationController* navController;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize fb_access_token = _fb_access_token;
@synthesize navController = _navController;

- (GlobalUtility *) globalUtilityObject{
    if(!globalUtilityObject){
        globalUtilityObject = [[GlobalUtility alloc] init];
        globalUtilityObject.delegate_refresh_my_data = self;
        
    }
    return globalUtilityObject;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    
    
    [FBProfilePictureView class];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self openSession];
        [[self.viewController viewModelObject] updateMyUserIdInTheAppSingleton];
        // To-do, show logged in view
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    [[UIApplication sharedApplication] 
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | 
      UIRemoteNotificationTypeBadge | 
      UIRemoteNotificationTypeSound)];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // this means the user switched back to this app without completing 
    // a login in Safari/Facebook App
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {    
        [FBSession.activeSession close]; // so we close our session and start over  
    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*- (void)showLoginView 
{
    UIViewController *topViewController = [self.navController topViewController];
    
    LoginViewController* loginViewController = 
    [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [topViewController presentModalViewController:loginViewController animated:NO];
}*/

- (void)showLoginView 
{
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = [topViewController modalViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is 
    // displayed, then getting back here means the login in progress did not successfully 
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController* loginViewController = [[LoginViewController alloc]
                                                      initWithNibName:@"LoginViewController" 
                                                      bundle:nil];
        [topViewController presentModalViewController:loginViewController animated:NO];
    } else {
        LoginViewController* loginViewController = 
        (LoginViewController*)modalViewController;
        [loginViewController loginFailed];
    }
}


- (void)sessionStateChanged:(FBSession *)session 
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    //NSLog(@"%@login info",session);
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController = 
            [self.navController topViewController];
            if ([[topViewController modalViewController] 
                 isKindOfClass:[LoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }
        }
            //self.fb_access_token = FBSession.activeSession.accessToken;
            //NSLog(@"%@",self.fb_access_token) ;
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to 
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            
            [self showLoginView];
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:SCSessionStateChangedNotification 
     object:session];

    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

- (void)openSession
{

    NSArray *array_permissions = [[NSArray alloc] initWithObjects:@"user_photos",@"publish_stream", nil];
    [FBSession openActiveSessionWithPermissions:array_permissions
                                   allowLoginUI:YES
                              completionHandler:
     ^(FBSession *session, 
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];    
}
- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation 
{
    //NSLog(@"%@",FBSession.activeSession);
    return [FBSession.activeSession handleOpenURL:url]; 
}



- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken { 
    
    NSString *string_device_token = [NSString 
                     stringWithFormat:@"Device Token=%@",deviceToken];
    NSArray *array_remove_staring_part = [string_device_token componentsSeparatedByString: @"<"];
    string_device_token = [array_remove_staring_part objectAtIndex: 1];
    NSArray *array_remove_ending_part = [string_device_token componentsSeparatedByString: @">"];
    string_device_token = [array_remove_ending_part objectAtIndex: 0];
    [GlobalSingleton sharedManager].string_my_device_token = string_device_token;
    NSLog(@"remote notification str: %@",string_device_token);
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"remote notification error: %@",str);  
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    for (id key in userInfo) {
        NSLog(@"remote notification key: %@, value: %@", key, [userInfo objectForKey:key]);
    }    
    
}



@end
