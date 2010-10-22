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

#import "StaffTableViewDataSource.h"

@implementation StaffTableViewDataSource

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *kStaffCellID = @"StaffCellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStaffCellID];
	if (cell == nil)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kStaffCellID] autorelease];
	
	// Configure the cell...
	NSDictionary *staffRow = [_items objectAtIndex:indexPath.row];
	cell.textLabel.text = [staffRow objectForKey:@"name"];
	cell.detailTextLabel.text = [staffRow objectForKey:@"positions"];
	
	return cell;
}

@end