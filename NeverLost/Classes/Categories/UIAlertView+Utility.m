//
//  UIAlertView+Utility.m
//  ChallengeMe
//
//  Created by Alex Marchis on 20/02/15.
//  Copyright (c) 2015 Alex Marchis. All rights reserved.
//

#import "UIAlertView+Utility.h"
#import "utils.h"

@implementation UIAlertView (Utility)

+ (void)alertViewWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:appName() message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)alertViewWithError:(NSError *)error
{
    NSString *message   = [[error userInfo] objectForKey:@"error"];
    
    NSString *firstChar = [message substringToIndex:1];
    firstChar           = [firstChar uppercaseString];
    
    NSMutableString *finalMessage = [[NSMutableString alloc] initWithString:firstChar];
    [finalMessage appendString:[message substringFromIndex:1]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:appName() message:finalMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)alertViewWithMessage:(NSString *)message andDelegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:appName() message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
