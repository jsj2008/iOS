//
//  NewsSourceSettingsController.m
//  SharedCore
//
//  Created by Jonathan Steele on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewsSourceSettingsController.h"
#import "Model.h"

@implementation NewsSourceSettingsController

@synthesize delegate;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
       self.title = @"News Source";
    }
    return self;
}

- (Model *)model {
	return [Model model];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.model.settingsForNews count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.accessoryType = (indexPath.row == self.model.newsIndex) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	cell.textLabel.text = [self.model.settingsForNews objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	for (UITableViewCell *cell in tableView.visibleCells)
		cell.accessoryType = UITableViewCellAccessoryNone;
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	[self.model setNewsIndex:indexPath.row];
	[delegate didSelectedNewsSourceFromSettings];
}

- (void)dealloc {
    [super dealloc];
}

@end