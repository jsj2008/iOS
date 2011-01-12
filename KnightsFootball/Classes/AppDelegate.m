//  Copyright 2010 Jonathan Steele
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AppDelegate.h"
#import "NSObject+BlocksAdditions.h"
#import "HeadlinesViewController.h"
#import "SchedulesViewController.h"
#import "LinkViewController.h"
#import "StaffViewController.h"
#import "SettingsViewController.h"

@implementation AppDelegate

@synthesize window, tabBarController, splitViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSMutableArray *tabArray = [NSMutableArray array];
	UINavigationController *navigationController;
	UITabBarItem *newsItem = [[[UITabBarItem alloc] initWithTitle:LocalizedString(@"Headlines") image:[UIImage imageNamed:@"166-newspaper.png"] tag:0] autorelease];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		splitViewController.tabBarItem = newsItem;
		[tabArray addObject:splitViewController];
	} else {
        HeadlinesViewController *headlineViewController = [[HeadlinesViewController alloc] initWithStyle:UITableViewStylePlain];
        headlineViewController.tabBarItem = newsItem;
        navigationController = [[UINavigationController alloc] initWithRootViewController:headlineViewController];
        [tabArray addObject:navigationController];
        [navigationController release];
        [headlineViewController release];
    }
	
	SchedulesViewController *scheduleViewController = [[SchedulesViewController alloc] init];
	navigationController = [[UINavigationController alloc] initWithRootViewController:scheduleViewController];
	[tabArray addObject:navigationController];
	[navigationController release];
	[scheduleViewController release];
	
	LinkViewController *linkViewController = [[LinkViewController alloc] init];
	navigationController = [[UINavigationController alloc] initWithRootViewController:linkViewController];
	[tabArray addObject:navigationController];
	[navigationController release];
	[linkViewController release];
	
	StaffViewController *staffViewController = [[StaffViewController alloc] init];
	navigationController = [[UINavigationController alloc] initWithRootViewController:staffViewController];
	[tabArray addObject:navigationController];
	[navigationController release];
	[staffViewController release];
	
	SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
	navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	[tabArray addObject:navigationController];
	[navigationController release];
	[settingsViewController release];
	
	tabBarController.viewControllers = tabArray;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Add the tab bar controller's view to the window and display.
		[window addSubview:tabBarController.view];
	} else {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		imageView.image = [UIImage imageNamed:@"Default.png"];
		[window addSubview:imageView];
		[imageView release];
		
		UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 240, 100, 20)];
		loadingLabel.backgroundColor = [UIColor clearColor];
		loadingLabel.textColor = [UIColor whiteColor];
		loadingLabel.text = LocalizedString(@"Loading");
		loadingLabel.font = [UIFont boldSystemFontOfSize:16];
		[window addSubview:loadingLabel];
		[loadingLabel release];
		
		UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activity.frame = CGRectMake(96, 240, 20, 20);
		[window addSubview:activity];
		[activity startAnimating];
		
		RunAfterDelay(3, ^{
			[activity stopAnimating];
            // Add the tab bar controller's view to the window and display.
			[window addSubview:tabBarController.view];	
		});
		[activity release];
	}

    [window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
    [splitViewController release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end