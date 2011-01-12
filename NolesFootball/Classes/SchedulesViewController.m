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

#import "SchedulesViewController.h"
#import "JSONParser.h"
#import "ScheduleTableViewDataSource.h"
#import "StadiumViewController.h"

@implementation SchedulesViewController

@synthesize dataSource = _dataSource;

- (id)init {
	self = [super initWithStyle:UITableViewStylePlain];
	if (self) {
		self.title = LocalizedString(@"Schedules");
		self.tabBarItem.image = [UIImage imageNamed:@"83-calendar.png"];
	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.rowHeight = 57;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// show the stadium button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Stadium") style:UIBarButtonItemStyleBordered target:self action:@selector(didSelectedStadium)] autorelease];
	
	[JSONParser createJSONRequestWithNetwork:@"http://jonathan.theoks.net/appstuff/noles_schedule.json" completionBlock:^(NSArray *array) {
		_dataSource = [[ScheduleTableViewDataSource alloc] initWithItems:array];
		self.tableView.dataSource = _dataSource;
		[self.tableView reloadData];
	}];
}

- (void)didSelectedStadium {
	StadiumViewController *stadium = [[StadiumViewController alloc] init];
	[self.navigationController pushViewController:stadium animated:YES];
	[stadium release];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_dataSource release];
	[super dealloc];
}

@end