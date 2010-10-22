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

#import "PLPopoverController.h"

@implementation PLPopoverController

@synthesize popOverController;

NSMutableArray *listGroups;
NSMutableArray *blocks;

- (id) initWithTitle: (NSString *) title_ {
	self = [super initWithStyle:UITableViewStylePlain];
	if (self) {
		self.title = title_;
		listGroups = [[NSMutableArray alloc] init];
		blocks = [[NSMutableArray alloc] init];
	}
	return self;
}

- (CGSize) contentSizeForViewInPopoverView {
	return CGSizeMake(320.0, 180.0);
}

- (void) addListToTableView: (NSString *) string block: (void (^)(NSInteger row))block {
	[listGroups addObject:string];
	[blocks addObject:[[block copy] autorelease]];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
	// Return the number of rows in the section.
	return [listGroups count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
	
	static NSString *kPopupCellID = @"PopupCellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopupCellID];
	if (cell == nil)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPopupCellID] autorelease];
	
	// Configure the cell...
	cell.textLabel.text = [listGroups objectAtIndex:indexPath.row];
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	/* Run the title's block */
    if (indexPath.row >= 0 && indexPath.row < [blocks count]) {
        void (^b)() = [blocks objectAtIndex:indexPath.row];
        b(indexPath.row);
    }
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		[popOverController dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void) dealloc {
	[listGroups removeAllObjects];
	[listGroups release];
	[blocks release];
	[popOverController release];
	[super dealloc];
}

@end