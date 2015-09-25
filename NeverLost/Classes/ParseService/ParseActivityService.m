//
//  ParseActivityService.m
//  NeverLost
//
//  Created by Alex Marchis on 25/08/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import "ParseActivityService.h"
#import "MyActivity.h"
#import "ErrorCoordinator.h"
#import "utils.h"

static NSString *kGetActivitiesMethod = @"getActivities";

@implementation ParseActivityService

+ (RACSignal *)getActivities {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [PFCloud callFunctionInBackground:kGetActivitiesMethod withParameters:@{@"maxResults" : @(kLimit),
                                                                                @"skipResults": @(0)} block:^(id result, NSError *error){
                                                                                
                                                                                    if (!error) {
                                                                                        [subscriber sendNext: [ParseActivityService activitiesFromDictionary:result]];
                                                                                        [subscriber sendCompleted];
                                                                                    }
                                                                                    else {
                                                                                        [ErrorCoordinator handleError:error];
                                                                                        [subscriber sendError:error];
                                                                                    }
                                                                                }];
        
        
        return nil;
    }];
}

static const NSString *ACTIVITY_COMMENTS_COUNT                = @"commentsCount";
static const NSString *ACTIVITY_DESCRIPTION                   = @"description";
static const NSString *ACTIVITY_FINISH_TIME                   = @"finishTime";
static const NSString *ACTIVITY_ID                            = @"id";
static const NSString *ACTIVITY_JOIN_MAX_TIME                 = @"joinMaxTime";
static const NSString *ACTIVITY_LAST_COMMENT_OWNER_FACEBOOKID = @"lastCommentOwnerFacebookId";
static const NSString *ACTIVITY_LAST_COMMENT_OWNER_FIRST_NAME = @"lastCommentOwnerFirstName";
static const NSString *ACTIVITY_LAST_COMMENT_OWNER_FLAG_URL   = @"lastCommentOwnerFlagUrl";
static const NSString *ACTIVITY_LAST_COMMENT_TEXT             = @"lastCommentText";
static const NSString *ACTIVITY_LAST_COMMENT_TIME             = @"lastCommentTime";
static const NSString *ACTIVITY_PHOTO_FILE_URL                = @"photoFileUrl";
static const NSString *ACTIVITY_PLACE                         = @"place";
static const NSString *ACTIVITY_PROVIDER_INITIALS             = @"providerInitials";
static const NSString *ACTIVITY_PROVIDER_NAME                 = @"providerName";
static const NSString *ACTIVITY_START_TIME                    = @"startTime";
static const NSString *ACTIVITY_TITLE                         = @"title";
static const NSString *ACTIVITY_UPDATE_TIME                   = @"updateTime";


+ (NSArray *)activitiesFromDictionary:(NSDictionary *)activitiesDict {
    
    NSMutableArray *activities = [NSMutableArray new];
    
    NSArray *arrDicts = activitiesDict[@"activities"];
    
    for (NSString *activityString in arrDicts) {
        
        NSError *e = nil;
        NSDictionary *activityDict = [NSJSONSerialization JSONObjectWithData: [activityString dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
        
        MyActivity *a = [MyActivity new];
        
        a.commentsCount              = [activityDict[ACTIVITY_COMMENTS_COUNT] integerValue];
        a.activityDescription        = activityDict[ACTIVITY_DESCRIPTION];

        if ([activityDict[ACTIVITY_FINISH_TIME] class] != [NSNull class]) {
        a.finishTime                 = [NSDate dateWithTimeIntervalSince1970:[activityDict[ACTIVITY_FINISH_TIME] doubleValue]/1000] ;
        }
        
        a.objectId                   = activityDict[ACTIVITY_ID];
        a.joinMaxTime                = [NSDate dateWithTimeIntervalSince1970:[activityDict[ACTIVITY_JOIN_MAX_TIME] doubleValue]/1000];
        
//        a.lastCommentOwnerFacebookId = activityDict[ACTIVITY_LAST_COMMENT_OWNER_FACEBOOKID];
//        a.lastCommentOwnerFirstName  = activityDict[ACTIVITY_LAST_COMMENT_OWNER_FIRST_NAME];
//        a.lastCommentOwnerFlagUrl    = activityDict[ACTIVITY_LAST_COMMENT_OWNER_FLAG_URL];
//        a.lastCommentText            = activityDict[ACTIVITY_LAST_COMMENT_TEXT];
//        a.lastCommentTime            = activityDict[ACTIVITY_LAST_COMMENT_TIME];
        
        a.photoFileUrl               = activityDict[ACTIVITY_PHOTO_FILE_URL];
        
        double latitude = [activityDict[ACTIVITY_PLACE][@"latitude"] doubleValue];
        double longitude = [activityDict[ACTIVITY_PLACE][@"longitude"] doubleValue];
        
        a.placeLatitude              = latitude;
        a.placeLongitude             = longitude;
        a.providerInitials           = activityDict[ACTIVITY_PROVIDER_INITIALS];
        a.providerName               = activityDict[ACTIVITY_PROVIDER_NAME];
        
        a.startTime                  = [NSDate dateWithTimeIntervalSince1970:[activityDict[ACTIVITY_START_TIME] doubleValue]/1000] ;
        a.title                      = activityDict[ACTIVITY_TITLE];
        a.updateTime                 = [NSDate dateWithTimeIntervalSince1970:[activityDict[ACTIVITY_UPDATE_TIME] doubleValue]/1000];

        //Compute distance
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLatitudeKey] doubleValue] longitude:[[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLongitudeKey] doubleValue]];
        CLLocation *place = [[CLLocation alloc] initWithLatitude:a.placeLatitude longitude:a.placeLongitude];
        
        a.distance = [place distanceFromLocation:locB]/1000.0;
        
        [activities addObject:a];
        
        //PO(a)
    }
    
    return activities;
}

@end
