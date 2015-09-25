//
//  MyActivity.m
//  NeverLost
//
//  Created by Alex Marchis on 04/09/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import "MyActivity.h"

@implementation MyActivity

// Specify properties to ignore (Realm won't persist these)

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"finishTime" : [NSDate dateWithTimeIntervalSince1970:0],
             @"lastCommentOwnerFacebookId" : @"",
             @"lastCommentOwnerFirstName" : @"",
             @"lastCommentOwnerFlagUrl" : @"",
             @"lastCommentText": @"",
             @"lastCommentTime": [NSDate dateWithTimeIntervalSince1970:0],
             @"distance" : [NSNumber numberWithDouble:0]};
}

@end
