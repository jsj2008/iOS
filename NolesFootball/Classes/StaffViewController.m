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

#import "StaffViewController.h"
#import "JSONParser.h"
#import "StaffTableViewDataSource.h"

@implementation StaffViewController

@synthesize dataSource = _dataSource;

- (id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.title = LocalizedString(@"Staff");
		self.tabBarItem.image = [UIImage imageNamed:@"28-star.png"];
	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[JSONParser createJSONRequestWithNetwork:@"http://jonathan.theoks.net/appstuff/noles_staff.json" completionBlock:^(NSArray *array) {
		_dataSource = [[StaffTableViewDataSource alloc] initWithItems:array];
		self.tableView.dataSource = _dataSource;
		[self.tableView reloadData];
	}];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_dataSource release];
	[super dealloc];
}

@end