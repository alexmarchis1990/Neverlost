//
//  AppDelegate.m
//  NeverLost
//
//  Created by Alex Marchis on 21/08/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WhatsHappeningViewController.h"

#import <CoreLocation/CoreLocation.h>

#import <Realm/Realm.h>

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "TabViewController.h"

#import "Activity.h"

#import "UIFont+AppFonts.h"
#import "UIColor+AppColors.h"
#import "constants.h"


@interface AppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

static const NSInteger schemaVersion = 8;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Parse enableLocalDatastore];
    
    [Activity registerSubclass];
    
    // Initialize Parse.
    [Parse setApplicationId:@"ezzrmeZLpkVunKrXYef7BjYbVbKTvYYCp9hjJe0b"
                  clientKey:@"IaciEST2GHIzgGgHii6fEfgiM7BWzyjlaX6Fd1Si"];
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = schemaVersion;
    
    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < schemaVersion) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
    };
    
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    [RLMRealm defaultRealm];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor appBlue]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontOpenSansRegularWithSize:15]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    BOOL shouldShowLogin = ![PFUser currentUser] || ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]];
    
    //shouldShowLogin = YES;
    
    UIViewController *rootViewController = shouldShowLogin ? [[LoginViewController alloc] initWithDelegate:self] : [self tabBarController];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    [self.window makeKeyAndVisible];
    
    [self setupLocationManager];
    
    [Fabric with:@[[Crashlytics class]]];

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    
    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Went to Background");
    // Need to stop regular updates first
    [self.locationManager stopUpdatingLocation];
    // Only monitor significant changes
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)setupLocationManager {
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (UIViewController *)tabBarController {
    
    WhatsHappeningViewController *act = [WhatsHappeningViewController new];
    act.title = @"WHAT'S HAPPENING";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:act];
    
    TabViewController *tabViewController = [[TabViewController alloc] initWithViewControllers:@[navigationController, navigationController,navigationController,navigationController] tabBarImages:@[@"whatsHappening", @"messageBoard", @"addSign", @"hostelsNearby", @"myProfile"] andCustomTabIndex:2];
    
    return tabViewController;
}

#pragma mark - CLLocationManager 

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:currentLocation.coordinate.latitude] forKey:kCurrentLatitudeKey];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:currentLocation.coordinate.longitude] forKey:kCurrentLongitudeKey];
    }
}

@end
