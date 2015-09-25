//
//  UIAlertView+Utility.h
//  ChallengeMe
//
//  Created by Alex Marchis on 20/02/15.
//  Copyright (c) 2015 Alex Marchis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Utility)

//Displays a default alert view (title: ChallengeMeClub, message, delegate: nil, "Ok")
+ (void)alertViewWithMessage:(NSString *)message;

+ (void)alertViewWithError:(NSError *)error;

//Displays a default alert view (title: ChallengeMeClub, message, DELEGATE, "Ok")
+ (void)alertViewWithMessage:(NSString *)message andDelegate:(id<UIAlertViewDelegate>)delegate;

@end
