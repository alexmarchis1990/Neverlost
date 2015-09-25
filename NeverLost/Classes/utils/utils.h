//
//  utils.h
//  ChallengeMe3.0
//
//  Created by Alex Marchis on 14/07/15.
//  Copyright (c) 2015 ChallengeMe. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <PureLayout/PureLayout.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <BloodMagic/Lazy.h>
#import <Parse/Parse.h>

#import "UIColor+AppColors.h"
#import "UIImage+Utils.h"
#import "UIFont+AppFonts.h"
#import "UIAlertView+Utility.h"
#import "NSString+Utils.h"
#import "constants.h"

#ifndef ChallengeMe3_0_utils_h
#define ChallengeMe3_0_utils_h

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define PO(x) NSLog(@"" #x " = %@", (x));

#endif

static const CGFloat kIphone6Height = 667.0;

static inline NSString* appName() {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
}

static inline CGFloat screenWidth() {
    
    return [[UIScreen mainScreen] bounds].size.width;
}

static inline CGFloat screenHeight() {
    
    return [[UIScreen mainScreen] bounds].size.height;
}

static inline CGFloat adjustValue(CGFloat iPhone6Value) {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    //NSLog(@"%f", iPhone6Value * view.frame.size.height / kIphone6Height * 0.75);
    
    if (screenHeight == kIphone6Height) {
        return iPhone6Value;
    }
    else
        return iPhone6Value * screenHeight / kIphone6Height * 0.75;
}