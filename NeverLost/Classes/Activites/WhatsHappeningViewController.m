//
//  ActivitiesViewController.m
//  NeverLost
//
//  Created by Alex Marchis on 25/08/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import "WhatsHappeningViewController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <Realm/Realm.h>
#import "TabViewController.h"
#import "ParseActivityService.h"
#import "ActivityCell.h"
#import "MyActivity.h"
#import "Filter.h"
#import "utils.h"

#import "RealmEx.h"

@interface WhatsHappeningViewController () <UITableViewDataSource, UITableViewDelegate, BMLazy>

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong)          UITableView             *tableView;
@property (nonatomic, strong)          UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong, bm_lazy) ActivityCell            *activityCell;
@property (nonatomic, strong)          UILabel                 *noItemsLabel;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *displayArray;
@property (nonatomic, assign) NSInteger nrOfItems;

@end

@implementation WhatsHappeningViewController

@dynamic activityCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TabViewController *parentViewController = (TabViewController *)self.navigationController.parentViewController;
    
    UIBarButtonItem *leftNavigationItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filterBtn60"] style:UIBarButtonItemStylePlain target:parentViewController action:@selector(showFilterView:)];
    leftNavigationItem.tintColor = [UIColor appLightGray];
    self.navigationItem.leftBarButtonItem = leftNavigationItem;
    
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addPerson"] style:UIBarButtonItemStylePlain target:self action:nil];
    rightNavigationItem.tintColor = [UIColor appLightGray];
    self.navigationItem.rightBarButtonItem = rightNavigationItem;
    
    [self.tableView registerClass:[ActivityCell class] forCellReuseIdentifier:NSStringFromClass([ActivityCell class])];
    
    [self setPullToRefresh];
    
    @weakify(self)
    [RACObserve(self.distanceFilter, filter) subscribeNext:^(id x) {
        
        @strongify(self)
        [self showActivites];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self retrieveActivitiesFromLocalDB];
    [self getActivities];
}

- (void)getActivities {
    
    @weakify(self)
    [[ParseActivityService getActivities] subscribeNext:^(NSArray *activities) {
        
        @strongify(self)
        self.dataArray = activities;
        [self showActivites];
        [self.activityIndicator stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
        
        [self persistActivities];
    } error:^(NSError *error) {
        
        @strongify(self)
        [self.activityIndicator stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    } ];
}

- (void)retrieveActivitiesFromLocalDB {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finishTime > %@ OR finishTime = %@",[NSDate date], [NSDate dateWithTimeIntervalSince1970:0]];
    RLMResults *results = [MyActivity objectsWithPredicate:predicate];

    NSMutableArray *arr = [NSMutableArray new];
    
    for (int i = 0; i<results.count; i++) {
        [arr addObject:[results objectAtIndex:i]];
    }
    
    self.dataArray = arr;
    [self showActivites];
}

- (void)persistActivities {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteAllObjects];
    }];
    
    for (MyActivity *act in self.dataArray) {
        
        [realm transactionWithBlock:^{
            [realm addObject:act];
        }];
    }
}

- (void)showActivites {
    
    self.displayArray = [[[self.dataArray rac_sequence] filter:^BOOL(MyActivity *activity) {
        
        return activity.distance<self.distanceFilter.filter;
        
    }] array];
    
    self.noItemsLabel.hidden = ! self.displayArray.count == 0;
    
    [self.tableView reloadData];
}

- (void)setPullToRefresh {
    
    @weakify(self)
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self)
        [self getActivities];
    }];
    
    self.tableView.pullToRefreshView.textColor = [UIColor whiteColor];
    self.tableView.pullToRefreshView.arrowColor = [UIColor whiteColor];
    self.tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}

- (void)loadView {
    
    [super loadView];
    
    self.backgroundImageView = [UIImageView newAutoLayoutView];
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView setImage:[UIImage imageNamed:@"background"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    
    self.tableView                              = [UITableView newAutoLayoutView];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor              = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.tableView.contentOffset                = CGPointMake(0, -15);
    self.tableView.dataSource                   = self;
    self.tableView.delegate                     = self;
    
    self.noItemsLabel           = [UILabel newAutoLayoutView];
    [self.tableView addSubview:self.noItemsLabel];
    self.noItemsLabel.text      = @"No Activities";
    self.noItemsLabel.font      = [UIFont fontOpenSansBoldWithSize:14.0f];
    self.noItemsLabel.textColor = [UIColor whiteColor];
    self.noItemsLabel.hidden    = YES;
    
    self.activityIndicator = [UIActivityIndicatorView newAutoLayoutView];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator startAnimating];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    
    [self.backgroundImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.activityIndicator autoCenterInSuperview];
    
    [self.noItemsLabel autoCenterInSuperview];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityCell class]) forIndexPath:indexPath];
    
    [cell setCellForActivity:[self.displayArray objectAtIndex:indexPath.row]];
    
    return cell;
    
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = self.activityCell;
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    return cell.contentView.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"Salut");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
