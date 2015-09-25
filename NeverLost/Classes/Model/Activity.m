//
//  Activity.m
//  NeverLost
//
//  Created by Alex Marchis on 25/08/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import "Activity.h"
#import <Parse/PFObject+Subclass.h>

@implementation Activity

+ (NSString *)parseClassName {
    return @"Activity";
}

@dynamic title;
@dynamic description;
@dynamic place;
@dynamic photoFile;
@dynamic providerName;
@dynamic commentsCounter;

@end
