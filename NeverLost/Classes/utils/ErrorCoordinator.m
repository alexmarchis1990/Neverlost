//
//  ErrorCoordinator.m
//  ToptalDemoProject
//
//  Created by Alex Marchis on 07/07/15.
//  Copyright (c) 2015 AlexMarchis. All rights reserved.
//

#import "ErrorCoordinator.h"
#import "constants.h"
#import "UIAlertView+Utility.h"

@implementation ErrorCoordinator

+ (void)handleError:(NSError *)error
{
    NSInteger errorCode = error.code;
    
    switch (errorCode) {
        case InvalidSessionErrorCode:
            [[NSNotificationCenter defaultCenter] postNotificationName:InvalidSessionNotification object:nil];
            [UIAlertView alertViewWithMessage:@"Invalid account. Please login or sign up."];
            break;
        case ObjectNotFoundErrorCode:
            //No Op
            break;
        case UsernameAlreadyTaken:
            [UIAlertView alertViewWithMessage:@"Username already taken."];
            break;
        default:
            [UIAlertView alertViewWithError:error];
            break;
    }
}

@end
