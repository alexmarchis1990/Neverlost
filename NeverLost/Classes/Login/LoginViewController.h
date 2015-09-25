//
//  LoginViewController.h
//  NeverLost
//
//  Created by Alex Marchis on 21/08/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface LoginViewController : UIViewController

-(instancetype)initWithDelegate:(AppDelegate *)delegate;

@property (nonatomic, assign) AppDelegate *delegate;

@end
