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

#import "LinkViewController.h"
#import "LinkTableViewDataSource.h"

@implementation LinkViewController

@synthesize dataSource;

- (id)init {
	if ((self = [super initWithStyle:UITableViewStyleGrouped]) == nil)
		return nil;
	self.title = LocalizedString(@"Link");
	self.tabBarItem.image = [UIImage imageNamed:@"link.png"];
	
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	dataSource = [[LinkTableViewDataSource alloc] initWithItems:[NSArray arrayWithObjects:
	[NSDictionary dictionaryWithObjectsAndKeys:@"Tickets", @"name", @"http://ucfathletics.cstv.com/tickets/ucf-tickets.html", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"UCF Gameday", @"name", @"http://ucfathletics.cstv.com/brighthouse/", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"UCFAlumni.com", @"name", @"http://www.ucfalumni.com/", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"Alumni Tracker", @"name", @"http://cbs.sportsline.com/collegefootball/alumni-tracker/school/5233", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"Golden Knights Club", @"name", @"http://www.ucfathleticfund.com/", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"Radio Network", @"name", @"http://ucfathletics.cstv.com/multimedia/ucf-isp-radio-network.html", @"url", nil], nil]];
	self.tableView.dataSource = dataSource;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id linkIndexPath = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
	NSString *url = [linkIndexPath objectForKey:@"url"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[dataSource release];
	[super dealloc];
}

@end