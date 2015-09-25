//
//  UIFont+AppFonts.m
//  ChallengeMe3.0
//
//  Created by Alex Marchis on 14/07/15.
//  Copyright (c) 2015 ChallengeMe. All rights reserved.
//

#import "UIFont+AppFonts.h"

@implementation UIFont (AppFonts)

+ (UIFont *)fontOpenSansRegularWithSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"OpenSans" size:size];
}

+ (UIFont *)fontOpenSansBoldWithSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"OpenSans-Bold" size:size];
}

+ (UIFont *)fontBebasRegularWithSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"BebasNeueRegular" size:size];
}

@end
