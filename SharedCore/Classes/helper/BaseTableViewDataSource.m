//  Copyright 2010 Jonathan Steele.
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

#import "BaseTableViewDataSource.h"

@implementation BaseTableViewDataSource

@synthesize items = _items;

- (id)initWithItems:(NSArray *)items
{
	if (self = [self init]) {
		_items = [items mutableCopy];
	}
	
	return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    // Configure the cell...
	
    return cell;
}

- (NSDictionary *)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < _items.count)
		return [_items objectAtIndex:indexPath.row];
	return nil;
}

- (void)dealloc
{
	[_items removeAllObjects];
	[_items release];
	[super dealloc];
}

@end