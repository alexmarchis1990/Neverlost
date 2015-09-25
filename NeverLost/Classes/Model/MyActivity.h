//
//  MyActivity.h
//  NeverLost
//
//  Created by Alex Marchis on 04/09/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
@class CLLocation;

@interface MyActivity :RLMObject

@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, strong) NSString *activityDescription;
@property (nonatomic, strong) NSDate *finishTime;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSDate *joinMaxTime;
@property (nonatomic, strong) NSString *lastCommentOwnerFacebookId;
@property (nonatomic, strong) NSString *lastCommentOwnerFirstName;
@property (nonatomic, strong) NSString *lastCommentOwnerFlagUrl;
@property (nonatomic, strong) NSString *lastCommentText;
@property (nonatomic, strong) NSDate *lastCommentTime;
@property (nonatomic, strong) NSString *photoFileUrl;
@property (nonatomic, assign) double placeLatitude;
@property (nonatomic, assign) double placeLongitude;
@property (nonatomic, strong) NSString *providerInitials;
@property (nonatomic, strong) NSString *providerName;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *updateTime;

@property (nonatomic, assign) double distance;

@end
