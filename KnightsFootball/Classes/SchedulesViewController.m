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

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		self.title = LocalizedString(@"Schedules");
		self.tabBarItem.image = [UIImage imageNamed:@"83-calendar.png"];

    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.rowHeight = 60;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// show the action button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Stadium" style:UIBarButtonItemStyleBordered target:self action:@selector(didSelectedStadium)] autorelease];
	
	[JSONParser createJSONRequestWithNetwork:@"http://jonathan.theoks.net/appstuff/knights_schedule.json" completionBlock:^(NSArray *array) {
		_dataSource = [[ScheduleTableViewDataSource alloc] initWithItems:array];
		self.tableView.dataSource = _dataSource;
		[self.tableView reloadData];
	}];
}

- (void)didSelectedStadium {
	StadiumViewController *stadiumViewController = [[StadiumViewController alloc] init];
	[self.navigationController pushViewController:stadiumViewController animated:YES];
	[stadiumViewController release];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_dataSource release]; 
    [super dealloc];
}

@end