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

#import "ScheduleTableViewDataSource.h"
#import "ScheduleCell.h"

@implementation ScheduleTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDictionary *schForNow = [_items objectAtIndex:section];
	return [schForNow objectForKey:@"date"];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *kSchedulesCellID = @"SchedulesCellID";
	
	ScheduleCell *cell = [[[ScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSchedulesCellID] autorelease];
	
	// Configure the cell...
	NSDictionary *schForNow = [_items objectAtIndex:indexPath.section];
	cell.schLabel.text = [schForNow objectForKey:@"school"];
	cell.timeLabel.text = [NSString stringWithFormat:@"Local time: %@", [schForNow objectForKey:@"time"]];
	cell.tvLabel.text = [NSString stringWithFormat:@"TV/Result: %@", [schForNow objectForKey:@"tv"]];

	return cell;
}

@end