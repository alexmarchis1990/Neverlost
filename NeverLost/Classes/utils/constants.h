//
//  constants.h
//  ChallengeMe3.0
//
//  Created by Alex Marchis on 14/07/15.
//  Copyright (c) 2015 ChallengeMe. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger kLimit = 100;

extern NSString *const InvalidSessionNotification;
extern NSString *const kCurrentLatitudeKey;
extern NSString *const kCurrentLongitudeKey;

static const NSInteger  InvalidSessionErrorCode = 209;
static const NSInteger  ObjectNotFoundErrorCode = 101;
static const NSInteger  UsernameAlreadyTaken    = 141;

#warning STOP! CHANGE THIS IF AD HOC
//typedef NS_ENUM(NSUInteger, DistanceFilter) {
//    k15KmFilter  = 15,
//    k60KmFilter  = 60,
//    k120KmFilter = 120
//};

typedef NS_ENUM(NSUInteger, DistanceFilter) {
    k15KmFilter  = 1900,
    k60KmFilter  = 2000,
    k120KmFilter = 2500
};
