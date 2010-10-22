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

#import "WebViewController.h"
#import "InstapaperRequest.h"
#import "Utilities.h"
#import "PLPopoverController.h"
#import "UITableAlert.h"

@interface WebViewController ()
@property (nonatomic, retain) UIPopoverController *splitPopoverController;
- (void)didSelectAction:(id)class;
@end

@implementation WebViewController

@synthesize splitPopoverController;

- (id)init {
	self = [super init];
	if (self)
		self.hidesBottomBarWhenPushed = YES;
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (InstapaperRequest *)request {
	return [InstapaperRequest account];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// show the action button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																							target:self
																							action:@selector(didSelectAction)] autorelease];
}

- (void)setUrl:(NSString *)urlString
{
	// Store urlString into instance variable for url
	_url = urlString;

	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
	self.view = webView;
	webView.delegate = self;
	webView.scalesPageToFit = YES;

	// load URL
	NSURL *webUrl = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:webUrl];
	[webView loadRequest:request];
	webView.delegate = nil;
	[webView release];
	
	// dismiss popover
	if (splitPopoverController && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		[splitPopoverController dismissPopoverAnimated:YES];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
	return YES;
}

// When the users click on the Action Button, this method will called.
- (void) didSelectAction {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		Class popoverControllerClass = NSClassFromString(@"UIPopoverController");
		if (popoverControllerClass && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			PLPopoverController *listController = [[PLPopoverController alloc] initWithTitle:LocalizedString(@"Options")];
			// Create a navigation controller to contain the list controller, and create the popover controller to contain the navigation controller.
			UINavigationController *listNavigationController = [[UINavigationController alloc] initWithRootViewController:listController];
			[self didSelectAction:listController];
			UIPopoverController *listPopoverController = [[popoverControllerClass alloc] initWithContentViewController:listNavigationController];
			[listNavigationController release];
			listController.popOverController = listPopoverController;
			[listPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
										  permittedArrowDirections:UIPopoverArrowDirectionUp
														  animated:YES];
			
			[listPopoverController release];
			[listController release];
		}
	} else {
		UITableAlert *alert = [[UITableAlert alloc] initWithTitle:LocalizedString(@"Options")];
		[self didSelectAction:alert];
		[alert show];
		[alert release];
	}
}

- (void)didSelectAction:(id)class {
	if (self.request.enabled && _url != nil) {
		[class addListToTableView:@"Send to Instapaper" block:^(NSInteger row) {
			self.request.urlString = _url;
			self.request.isPost = YES;
			[self.request loadDataFromURLForcingBasicAuth:[NSURL URLWithString:@"https://www.instapaper.com/api/add"]];
		}];
	}

	[class addListToTableView:@"Open In Browser" block:^(NSInteger row) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
	}];
}

// When UIWebView has error message is exists, this method will call.
// I have seen the error code is -999 usually happen so it wouldn't display the alert view.
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	if ([error code] == -999)
		return;
	[Utilities showAlertView:LocalizedString(@"Error Title") message:[error localizedDescription]];
}

#pragma mark -
#pragma mark UISplitViewController delegate

- (void)splitViewController: (UISplitViewController *) svc willHideViewController: (UIViewController *) aViewController withBarButtonItem: (UIBarButtonItem *) barButtonItem forPopoverController: (UIPopoverController *) pc {
    barButtonItem.title = LocalizedString(@"Headlines");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
	self.splitPopoverController = pc;
}

- (void)splitViewController: (UISplitViewController *)svc willShowViewController: (UIViewController *) aViewController invalidatingBarButtonItem: (UIBarButtonItem *) barButtonItem {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.splitPopoverController = nil;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void) dealloc {
	[splitPopoverController release];
	[super dealloc];
}

@end