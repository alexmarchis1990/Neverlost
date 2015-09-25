//
//  TabViewController.h
//  NeverLost
//
//  Created by Alex Marchis on 02/09/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabViewController : UIViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers tabBarImages:(NSArray *)tabBarImages andCustomTabIndex:(NSInteger)customTabIndex;

- (void)showFilterView:(UIBarButtonItem *)barBtn;

@end
