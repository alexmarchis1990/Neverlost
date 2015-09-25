//
//  Activity.h
//  NeverLost
//
//  Created by Alex Marchis on 25/08/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import <Parse/Parse.h>


@interface Activity : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSNumber *commentsCounter;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFGeoPoint *place;
@property (nonatomic, strong) NSString *providerName;
@property (nonatomic, strong) NSString *title;



@end
