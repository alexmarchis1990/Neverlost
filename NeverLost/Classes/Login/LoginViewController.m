//
//  LoginViewController.m
//  NeverLost
//
//  Created by Alex Marchis on 21/08/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import "LoginViewController.h"
#import "ParseUserService.h"
#import "AppDelegate.h"
#import "utils.h"

static const NSInteger kVerticalDistance = 25.0f;
static const NSInteger kSeparatorOffset  = 5.0f;

static NSString *LABEL_PRIVACY = @"By logging in you agree to the";
static NSString *LABEL_TERMS   = @"and";

static NSString *URL_PRIVACY_POLICY = @"http://www.google.com";
static NSString *URL_TERMS          = @"http://www.yahoo.com";


@interface LoginViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *appLogo;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UILabel  *privacyLabel;
@property (nonatomic, strong) UIButton *privacyPolicyBtn;
@property (nonatomic, strong) UIView   *privacyPolicySupportingView;

@property (nonatomic, strong) UILabel  *termsLabel;
@property (nonatomic, strong) UIButton *termsAndCondBtn;
@property (nonatomic, strong) UIView   *termsSupportingView;

@end

@implementation LoginViewController

- (instancetype)initWithDelegate:(AppDelegate *)delegate {
    
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    self.loginBtn.rac_command = [self loginCommand];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)loadView {
    
    [super loadView];
    
    self.backgroundImageView = [UIImageView newAutoLayoutView];
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView setImage:[UIImage imageNamed:@"loginBackground"]];
    
    self.appLogo = [UIImageView newAutoLayoutView];
    [self.view addSubview:self.appLogo];
    [self.appLogo setImage:[UIImage imageNamed:@"appLogo"]];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn setImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
    
    self.activityIndicator = [UIActivityIndicatorView new];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicator.hidesWhenStopped = YES;
    
    self.privacyPolicySupportingView = [UIView newAutoLayoutView];
    [self.view addSubview:self.privacyPolicySupportingView];
    
    self.privacyLabel = [UILabel newAutoLayoutView];
    [self.privacyPolicySupportingView addSubview:self.privacyLabel];
    self.privacyLabel.text = LABEL_PRIVACY;
    self.privacyLabel.textColor = [UIColor appGray];
    self.privacyLabel.font = [UIFont fontOpenSansRegularWithSize:11.0f];
    
    self.privacyPolicyBtn                    = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.privacyPolicySupportingView addSubview:self.privacyPolicyBtn];
    NSMutableAttributedString *privacyString = [[NSMutableAttributedString alloc] initWithString:@"Privacy Policy"];
    [privacyString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [privacyString length])];
    [privacyString addAttribute:NSForegroundColorAttributeName value:[UIColor appGray] range:NSMakeRange(0, [privacyString length])];
    [privacyString addAttribute:NSFontAttributeName value:[UIFont fontOpenSansRegularWithSize:11.0f] range:NSMakeRange(0, [privacyString length])];
    [self.privacyPolicyBtn setAttributedTitle:privacyString forState:UIControlStateNormal];
    [self.privacyPolicyBtn addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    self.termsSupportingView = [UIView newAutoLayoutView];
    [self.view addSubview:self.termsSupportingView];
    
    self.termsLabel = [UILabel newAutoLayoutView];
    [self.termsSupportingView addSubview:self.termsLabel];
    self.termsLabel.text = LABEL_TERMS;
    self.termsLabel.textColor = [UIColor appGray];
    self.termsLabel.font = [UIFont fontOpenSansRegularWithSize:11.0f];
    
    self.termsAndCondBtn                   = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.termsSupportingView addSubview:self.termsAndCondBtn];
    NSMutableAttributedString *termsString = [[NSMutableAttributedString alloc] initWithString:@"Terms and Conditions"];
    [termsString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [termsString length])];
    [termsString addAttribute:NSForegroundColorAttributeName value:[UIColor appGray] range:NSMakeRange(0, [termsString length])];
    [termsString addAttribute:NSFontAttributeName value:[UIFont fontOpenSansRegularWithSize:11.0f] range:NSMakeRange(0, [termsString length])];
    [self.termsAndCondBtn setAttributedTitle:termsString forState:UIControlStateNormal];
    [self.termsAndCondBtn addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    
    [self.backgroundImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.appLogo autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.appLogo autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:adjustValue(-4*kVerticalDistance)];
    
    [self.termsLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.termsSupportingView];
    [self.termsAndCondBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.termsLabel];
    [self.termsAndCondBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.termsLabel withOffset:kSeparatorOffset];
    [self.termsAndCondBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeading];
    
    [self.termsSupportingView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.termsSupportingView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-kVerticalDistance];
    
    [self.privacyLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.privacyPolicySupportingView];
    [self.privacyPolicyBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.privacyLabel];
    [self.privacyPolicyBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.privacyLabel withOffset:kSeparatorOffset];
    [self.privacyPolicyBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeading];
    
    [self.privacyPolicySupportingView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.privacyPolicySupportingView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.termsSupportingView];
    
    [self.loginBtn autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.loginBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.privacyPolicySupportingView withOffset:adjustValue(-3*kVerticalDistance)];
    
    [self.activityIndicator autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.loginBtn];
    [self.activityIndicator autoAlignAxis:ALAxisVertical toSameAxisOfView:self.loginBtn];
}

- (RACCommand *)loginCommand {
    
    @weakify(self)
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        @strongify(self)
        [self.activityIndicator startAnimating];
        
        return [ParseUserService loginSignal];
    }];
    
    
    [[[[command.executionSignals flatten] flattenMap:^RACStream *(id value) {
         
         return [ParseUserService fetchUserDataSignal];
     }] flattenMap:^RACStream *(NSDictionary *userData) {
         
         return [ParseUserService saveUserSignalWithData:userData];
     }] subscribeNext:^(NSNumber *success) {
         
         @strongify(self)
         if (success.boolValue) {
             [self.activityIndicator stopAnimating];
             [self loadTabBar];
         }
     }];
      
    [[command errors] subscribeNext:^(id x) {
        
        @strongify(self)
        [self.activityIndicator stopAnimating];
        NSLog(@"Error: %@", x);
    }];
    
    return command;
}


- (void)openURL:(UIButton *)btn {
    
    NSString *urlString = ( btn == self.privacyPolicyBtn ) ? URL_PRIVACY_POLICY : URL_TERMS;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)loadTabBar {
    
    [self.navigationController setViewControllers:@[[self.delegate tabBarController]] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
