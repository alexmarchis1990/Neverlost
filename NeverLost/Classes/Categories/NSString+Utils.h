//
//  NSString+Utils.h
//  ChallengeMe3.0
//
//  Created by Alex Marchis on 20/07/15.
//  Copyright (c) 2015 ChallengeMe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

+ (NSString *)stringWithDate:(NSDate *)date;

- (BOOL)isValidEmail;

- (BOOL)containsOnlyAlphanumericCharacters;

@end
