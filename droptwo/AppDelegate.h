//
//  AppDelegate.h
//  droptwo
//
//  Created by Mac on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"
#import "GlobalUtility.h"
extern NSString *const SCSessionStateChangedNotification;
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    ViewModel *viewModelObject;
    GlobalUtility *globalUtilityObject;
}
    
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) NSString *fb_access_token;

- (void)openSession;
@end
