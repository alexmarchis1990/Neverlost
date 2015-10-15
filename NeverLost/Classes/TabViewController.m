//
//  TabViewController.m
//  NeverLost
//
//  Created by Alex Marchis on 02/09/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import "TabViewController.h"
#import "WhatsHappeningViewController.h"
#import "Filter.h"
#import "utils.h"

static const CGFloat kFilterBtnSize = 35.0f;

@interface TabViewController ()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSArray *btns;
@property (nonatomic, assign) NSInteger selectedTab;

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, assign) NSInteger customTabIndex;

@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UIView *filterOverlayView;
@property (nonatomic, strong) UIView *filterWhiteView;
@property (nonatomic, strong) UIImageView *triangleImageView;
@property (nonatomic, strong) UIButton *filterBtn1;
@property (nonatomic, strong) UIButton *filterBtn2;
@property (nonatomic, strong) UIButton *filterBtn3;

@property (nonatomic, strong) UIButton *activeFilterBtn;
@property (nonatomic, strong) UIBarButtonItem *currentBarBtn;

@property (nonatomic, strong) Filter *distanceFilter;

@end

@implementation TabViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers tabBarImages:(NSArray *)tabBarImages andCustomTabIndex:(NSInteger)customTabIndex {
    
    self = [super init];
    
    if (self) {
        
        NSAssert(viewControllers.count==tabBarImages.count-1, @"Number of view controllers doesn't match the number of TabBar Images");
        NSAssert(customTabIndex >= 0 && customTabIndex<tabBarImages.count , @"Custom Tab Index should be greater than 0 and less then the number of TabBar Images");
        
        self.viewControllers = viewControllers;
        self.customTabIndex  = customTabIndex;
        [self setTabBarWithImages:tabBarImages];
        
        _distanceFilter = [[Filter alloc] init];
        self.distanceFilter.filter = k60KmFilter;

        [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            UINavigationController *navigationController = (UINavigationController *)obj;
            UIViewController *vc = navigationController.viewControllers.firstObject;
            
            if ([vc isKindOfClass:[WhatsHappeningViewController class]]) {
                
                WhatsHappeningViewController *whvc = (WhatsHappeningViewController *)vc;
                whvc.distanceFilter = self.distanceFilter;
            }
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setSelectedTab:!self.customTabIndex];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setTabBarWithImages:(NSArray *)imageNames {
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for (int i =0; i<imageNames.count; i++) {
        
        UIButton *btn;

        if (i != self.customTabIndex) {
            btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.backgroundColor = [UIColor appDarkBlue];
            btn.tintColor       = [UIColor appLightGray];
            
            [btn addTarget:self action:@selector(tapTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor appDarkBlue];
        }
        
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        btn.tag = i;
        [arr addObject:btn];
    }
    
    self.btns = arr;
}

- (void)setupAndConstraintButtons {
    
    for (int i = 0; i<self.btns.count; i++) {
        
        UIButton *btn = self.btns[i];
        
        [self.view addSubview:btn];
        [btn autoSetDimension:ALDimensionHeight toSize:50.0f];
        [btn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
        
        if (i == 0) {
            [btn autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
        }
        else {
            [btn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.btns[i-1]];
            [btn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.btns[i-1]];
        }
        
        if (i == self.btns.count-1) {
            [btn autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
        }
    }
}

- (void)loadView {
    
    [super loadView];
    
    self.lineView = [UIView newAutoLayoutView];
    [self.view addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor appLightBlue];

    [self setupAndConstraintButtons];
    
    [self updateViewConstraints];
}

- (void)tapTabBarButton:(UIButton *)btn {
    
    if (btn.tag != self.selectedTab) {
        
        [self setSelectedTab:btn.tag];
    }
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    
    [self.lineView autoSetDimension:ALDimensionHeight toSize:3.0f];
    [self.lineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 50, 0) excludingEdge:ALEdgeTop];
}

- (void)setSelectedTab:(NSInteger)selectedTab {
    
    UIButton *previousBtn = self.btns[self.selectedTab];
    previousBtn.tintColor = [UIColor appLightGray];
    previousBtn.backgroundColor = [UIColor appDarkBlue];
    
    UIButton *newBtn = self.btns[selectedTab];
    newBtn.tintColor = [UIColor whiteColor];
    newBtn.backgroundColor = [UIColor appDarkestBlue];

    NSInteger workingIndex = selectedTab < self.customTabIndex ? selectedTab : selectedTab - 1;
    
    UINavigationController *activeNavigationController = self.viewControllers[workingIndex];
    
    [self addChildViewController:activeNavigationController];
    [activeNavigationController didMoveToParentViewController:self];
    
    activeNavigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:activeNavigationController.view];
    
    [activeNavigationController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 53.0f, 0)];
    
    _selectedTab = selectedTab;
}

- (UIView *)filterView {
    
    if ( ! _filterView) {
        
        _filterView = [UIView newAutoLayoutView];
        
        _filterOverlayView = [UIView newAutoLayoutView];
        [_filterView addSubview:_filterOverlayView];
        [_filterOverlayView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        _filterOverlayView.backgroundColor = [UIColor blackColor];
        _filterOverlayView.alpha = 0.6;
        
        _filterWhiteView = [UIView newAutoLayoutView];
        [_filterView addSubview:_filterWhiteView];
        [_filterWhiteView autoSetDimension:ALDimensionHeight toSize:50];
        [_filterWhiteView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        _filterWhiteView.backgroundColor = [UIColor whiteColor];
        
        _triangleImageView = [UIImageView newAutoLayoutView];
        [_filterView addSubview:_triangleImageView];
        [_triangleImageView setImage:[UIImage imageNamed:@"triangle"]];
        [_triangleImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_filterView];
        [_triangleImageView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_filterView withOffset:20.0f];
        
        _filterBtn1 = [self filterBtnWithText:@"15\nkm"];
        _filterBtn2 = [self filterBtnWithText:@"60\nkm"];
        _filterBtn3 = [self filterBtnWithText:@"120\nkm"];
        
        self.activeFilterBtn = _filterBtn2;

        [_filterBtn2 autoCenterInSuperview];
        [_filterBtn1 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_filterBtn2];
        [_filterBtn3 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_filterBtn2];
        [_filterBtn1 autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:_filterBtn2 withOffset:-50.0f];
        [_filterBtn3 autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:_filterBtn2 withOffset:50.0f];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
            [_filterView removeFromSuperview];
        }];
        
        [self.filterView addGestureRecognizer:tapGesture];
    }
    
    return _filterView;
}

- (UIButton *)filterBtnWithText:(NSString *)text {
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [filterBtn setBackgroundColor:[UIColor appGray]];
    filterBtn.layer.cornerRadius = kFilterBtnSize/2;
    filterBtn.titleLabel.numberOfLines = 2;
    filterBtn.tintColor = [UIColor whiteColor];
    filterBtn.titleLabel.font = [UIFont fontOpenSansRegularWithSize:11.0f];
    filterBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [filterBtn setTitle:text forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(changeFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    [_filterWhiteView addSubview:filterBtn];
    [filterBtn autoSetDimensionsToSize:CGSizeMake(kFilterBtnSize, kFilterBtnSize)];
    
    return filterBtn;
}

- (void)changeFilter:(UIButton *)btn {
    
    UIImage *iconImage = nil;
    
    if (btn == _filterBtn1) {
        iconImage = [UIImage imageNamed:@"filterBtn15"];
        self.distanceFilter.filter = k15KmFilter;
    }
    else if (btn == _filterBtn2) {
        iconImage = [UIImage imageNamed:@"filterBtn60"];
        self.distanceFilter.filter = k60KmFilter;
    }
    else {
        iconImage = [UIImage imageNamed:@"filterBtn120"];
        self.distanceFilter.filter = k120KmFilter;
    }
    [self.activeFilterBtn setBackgroundColor:[UIColor appDarkGray]];
    self.activeFilterBtn = btn;
    
    [self.currentBarBtn setImage:iconImage];
    [self.filterView removeFromSuperview];
}

- (void)setActiveFilterBtn:(UIButton *)activeFilterBtn {
    
    _activeFilterBtn = activeFilterBtn;
    [_activeFilterBtn setBackgroundColor:[UIColor appYellow]];
}

- (void)showFilterView:(UIBarButtonItem *)barBtn {
    
    [self.view addSubview:self.filterView];
    [self.filterView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 0, 0)];
    
    self.currentBarBtn = barBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
