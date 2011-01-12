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
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.title = LocalizedString(@"Link");
		self.tabBarItem.image = [UIImage imageNamed:@"58-bookmark.png"];
	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	dataSource = [[LinkTableViewDataSource alloc] initWithItems:[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Tickets", @"name", @"http://www.seminoles.com/tickets/fsu-tickets.html", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"Upcoming Events and Promo", @"name", @"http://www.seminoles.com/genrel/nole-zone.html", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"Seminoles Booster", @"name", @"http://seminole-boosters.fsu.edu/Community/Page.aspx?pid=520&srcid=223", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"Radio Affilate", @"name", @"http://www.seminoles.com/multimedia/broadcast.html", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"Traditions", @"name", @"http://www.seminoles.com/trads/fsu-trads.html", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"Team Ranking", @"name", @"http://www.seminoles.com/genrel/rankings.html", @"url", nil],
	[NSDictionary dictionaryWithObjectsAndKeys:@"Seminoles Podcast (iTunes)", @"name", @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewPodcast?id=191160703", @"url", nil], nil]];
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