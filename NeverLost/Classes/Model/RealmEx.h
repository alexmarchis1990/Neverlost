//
//  RealmEx.h
//  NeverLost
//
//  Created by Alex Marchis on 18/09/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import <Realm/Realm.h>

@interface RealmEx : RLMObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RealmEx>
RLM_ARRAY_TYPE(RealmEx)
