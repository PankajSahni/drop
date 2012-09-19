//
//  LoginViewController.h
//  droptwo
//
//  Created by Mac on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController


@property(strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (IBAction)performLogin:(id)sender;
- (void)loginFailed;
@end
