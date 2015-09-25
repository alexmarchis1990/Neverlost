//
//  NSString+Utils.m
//  ChallengeMe3.0
//
//  Created by Alex Marchis on 20/07/15.
//  Copyright (c) 2015 ChallengeMe. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

+ (NSString *)stringWithDate:(NSDate *)date {
    
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"MMMM d, yyyy"];
    NSMutableString *prefixDateString =  [NSMutableString stringWithString: [prefixDateFormatter stringFromDate:date]];
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"d"];
    int date_day = [[monthDayFormatter stringFromDate:date] intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    
    [prefixDateString insertString:suffix atIndex:[prefixDateString rangeOfString:@","].location];

    return prefixDateString;
}

- (BOOL)isValidEmail {
    
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)containsOnlyAlphanumericCharacters {
    
    NSCharacterSet *charactersToBlock = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    return ([self rangeOfCharacterFromSet:charactersToBlock].location == NSNotFound);
}

@end
