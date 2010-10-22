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

#import "SettingsViewController.h"
#import "Model.h"
#import "InstapaperRequest.h"
#import "PLPopoverController.h"

@interface SettingsViewController (PrivateMethod)
- (void)didSelectAction:(PLPopoverController *)class;
@end

@implementation SettingsViewController

@synthesize username, password;

typedef enum {
	NewsSection,
	UpcoInstapaperSection,
	LastSection = UpcoInstapaperSection
} SettingsSection;

- (id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.title = LocalizedString(@"Settings");
		self.tabBarItem.image = [UIImage imageNamed:@"20-gear2.png"];
	}
	return self;
}

- (Model *)model {
	return [Model model];
}

- (InstapaperRequest *)request {
	return [InstapaperRequest account];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == NewsSection)
		return 1;
	else if (section == UpcoInstapaperSection)
		return (self.request.enabled) ? 3 : 1;
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Return the title of footer in the table view.
	if (section == UpcoInstapaperSection)
		return @"Instapaper";
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	// Return the title of footer in the table view.
	if (section == LastSection)
		return LocalizedString(@"CopyRightMsg");
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *kScheduleCellID = @"ScheduleCellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleCellID];
	if (cell == nil)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kScheduleCellID] autorelease];
	
	// Configure the cell...
	switch (indexPath.section) {
		case NewsSection:
			cell.textLabel.text = LocalizedString(@"Headlines");
			cell.detailTextLabel.text = self.model.newsTitle;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		break;
		case UpcoInstapaperSection:
			if (indexPath.row == 0) {
				cell.textLabel.text = @"Enabled";
				UISwitch *requestSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 0, 0)];
				[requestSwitch addTarget:self action:@selector(requestButton:) forControlEvents:UIControlEventValueChanged];
				requestSwitch.on = self.request.enabled;
				cell.accessoryView = requestSwitch;
				[requestSwitch release];
			} else if (indexPath.row == 1) {
				cell.textLabel.text = @"Username";
				username = [[UITextField alloc] initWithFrame:CGRectMake(300, 34, 185, 22)];
				username.delegate = self;
				username.text = self.request.username;
				username.placeholder = @"Instapaper Username";
				cell.accessoryView = username;				
			} else if (indexPath.row == 2) {
				cell.textLabel.text = @"Password";
				password = [[UITextField alloc] initWithFrame:CGRectMake(300, 34, 185, 22)];
				password.delegate = self;
				password.text = self.request.password;
				password.returnKeyType = UIReturnKeyDone;
				password.secureTextEntry = YES;
				password.placeholder = @"Instapaper Password";
				cell.accessoryView = password;				
			}
		break;
		default:
		break;
	}
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == NewsSection) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			Class popoverControllerClass = NSClassFromString(@"UIPopoverController");
			if (popoverControllerClass && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				PLPopoverController *listController = [[PLPopoverController alloc] initWithTitle:LocalizedString(@"News Source")];
				// Create a navigation controller to contain the list controller, and create the popover controller to contain the navigation controller.
				UINavigationController *listNavigationController = [[UINavigationController alloc] initWithRootViewController:listController];
				[self didSelectAction:listController];
				UIPopoverController *listPopoverController = [[popoverControllerClass alloc] initWithContentViewController:listNavigationController];
				[listNavigationController release];
				listController.popOverController = listPopoverController;
				[listPopoverController presentPopoverFromRect:CGRectMake(120,15,50,40)
													   inView:self.view
									 permittedArrowDirections:UIPopoverArrowDirectionUp
													 animated:YES];
				[listPopoverController release];
				[listController release];
			}
		} else {
			NewsSourceSettingsController *newsSource = [[NewsSourceSettingsController alloc] initWithStyle:UITableViewStyleGrouped];
			newsSource.delegate = self;
			[self.navigationController pushViewController:newsSource animated:YES];
			[newsSource release];
		}
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Helper method to add String to PLPopoverController
- (void)didSelectAction:(PLPopoverController *)class {
	for (NSString *string in self.model.settingsForNews) {
		[class addListToTableView:string block:^(NSInteger row) {
			[self.model setNewsIndex:row];
			[self.tableView reloadData];
		}];
	}
}

- (void)didSelectedNewsSourceFromSettings {
	[self.tableView reloadData];
}

- (void)requestButton:(UISwitch *)sender {
	[self.request setEnabled:sender.isOn];
	[self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	if (textField == password) {
		[self.request setUserName:username.text password:password.text];
		[self.request loadDataFromURLForcingBasicAuth:[NSURL URLWithString:@"https://www.instapaper.com/api/authenticate"]];
	}
	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[username release];
	[password release];
	[super dealloc];
}

@end