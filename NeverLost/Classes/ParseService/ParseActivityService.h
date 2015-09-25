//
//  ParseActivityService.h
//  NeverLost
//
//  Created by Alex Marchis on 25/08/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface ParseActivityService : NSObject

+ (RACSignal *)getActivities;

@end
