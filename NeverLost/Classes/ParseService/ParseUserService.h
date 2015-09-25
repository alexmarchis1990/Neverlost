//
//  ParseUserService.h
//  NeverLost
//
//  Created by Alex Marchis on 04/09/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface ParseUserService : NSObject

+ (RACSignal *)loginSignal;

+ (RACSignal *)fetchUserDataSignal;

+ (RACSignal *)saveUserSignalWithData:(NSDictionary *)userData;

@end
