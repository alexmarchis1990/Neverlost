//
//  ActivityCell.h
//  NeverLost
//
//  Created by Alex Marchis on 02/09/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyActivity;

@interface ActivityCell : UITableViewCell

- (void)setCellForActivity:(MyActivity *)activity;

@end
