//
//  ParseUserService.m
//  NeverLost
//
//  Created by Alex Marchis on 04/09/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import "ParseUserService.h"
#import <ReactiveCocoa.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

static NSString *PERMISSION_EMAIL         = @"email";
static NSString *PERMISSION_USER_HOMETOWN = @"user_hometown";
static NSString *PERMISSION_USER_LOCATION = @"user_location";

static NSString *FACEBOOK_FIELD_HOMETOWN   = @"hometown";
static NSString *FACEBOOK_FIELD_LOCATION   = @"location";
static NSString *FACEBOOK_FIELD_BIRTHDAY   = @"birthday";
static NSString *FACEBOOK_FIELD_GENDER     = @"gender";
static NSString *FACEBOOK_FIELD_EMAIL      = @"email";
static NSString *FACEBOOK_FIELD_NAME       = @"name";
static NSString *FACEBOOK_FIELD_FIRST_NAME = @"first_name";
static NSString *FACEBOOK_FIELD_ID         = @"id";

static NSString *PROPERTY_USER_APP_VERSION = @"AppVersion";
static NSString *PROPERTY_USER_FACEBOOK_ID = @"FacebookId";
static NSString *PROPERTY_USER_NAME        = @"Name";
static NSString *PROPERTY_USER_FIRST_NAME  = @"FirstName";
static NSString *PROPERTY_USER_EMAIL       = @"Email";
static NSString *PROPERTY_USER_GENDER      = @"Gender";
static NSString *PROPERTY_USER_BIRTHDAY    = @"Birthday";
static NSString *PROPERTY_USER_HOMETOWN    = @"Hometown";
static NSString *PROPERTY_USER_LIVINGCITY  = @"LivingCity";
static NSString *PROPERTY_USER_COUNTRY     = @"Country";

@implementation ParseUserService

+ (RACSignal *)loginSignal {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // Set permissions required from the facebook user account
        NSArray *permissionsArray = @[ PERMISSION_EMAIL, PERMISSION_USER_HOMETOWN, PERMISSION_USER_LOCATION];
        [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                [subscriber sendError:error];
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            } else {
                NSLog(@"User logged in through Facebook!");
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

+ (RACSignal *)fetchUserDataSignal {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me?fields=id,name,email,gender,hometown,first_name,location" parameters:nil];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSLog(@"Fetched User Data");
                [subscriber sendNext:userData];
                [subscriber sendCompleted];
            }
            else {
                NSLog(@"Error = %@", [error localizedDescription]);
                [subscriber sendError:error];
            }
        }];
        
        return nil;
    }];
}

+ (RACSignal *)saveUserSignalWithData:(NSDictionary *)userData {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
#warning TEST FOR EXISTENCE FIRST
        [[PFUser currentUser] setObject:version forKey:PROPERTY_USER_APP_VERSION];
        [[PFUser currentUser] setObject:userData[FACEBOOK_FIELD_EMAIL] forKey:PROPERTY_USER_EMAIL];
        [[PFUser currentUser] setObject:userData[FACEBOOK_FIELD_NAME] forKey:PROPERTY_USER_NAME];
        [[PFUser currentUser] setObject:userData[FACEBOOK_FIELD_ID] forKey:PROPERTY_USER_FACEBOOK_ID];
        [[PFUser currentUser] setObject:userData[FACEBOOK_FIELD_HOMETOWN][FACEBOOK_FIELD_NAME] forKey:PROPERTY_USER_HOMETOWN];
        [[PFUser currentUser] setObject:userData[FACEBOOK_FIELD_LOCATION][FACEBOOK_FIELD_NAME] forKey:PROPERTY_USER_LIVINGCITY];
        [[PFUser currentUser] setObject:userData[FACEBOOK_FIELD_GENDER] forKey:PROPERTY_USER_GENDER];
        [[PFUser currentUser] setObject:userData[FACEBOOK_FIELD_FIRST_NAME] forKey:PROPERTY_USER_FIRST_NAME];
        
        PFACL *acl = [PFACL ACL];
        [[PFUser currentUser] setACL:acl];
        
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL success, NSError *err) {
            
            if (!err) {
                NSLog(@"Saved User Data");
                [subscriber sendNext:@(YES)];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:err];
            }
        }];
        
        return nil;
    }];
}

@end
