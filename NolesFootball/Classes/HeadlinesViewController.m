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

#import "HeadlinesViewController.h"
#import "Model.h"
#import "TouchXMLReader.h"
#import "WebViewController.h"

@interface HeadlinesViewController ()
- (void)startIconDownload:(Feed *)feed forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation HeadlinesViewController

- (Model *)model {
	return [Model model];
}

@synthesize newsGroup, imageDownload, webViewController;

#pragma mark -
#pragma mark View lifecycle

// On-demand initializer for read-only property.
- (NSDateFormatter *)dateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return dateFormatter;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.newsGroup = [NSMutableArray array];
	self.imageDownload = [NSMutableDictionary dictionary];
	
	// Set the navigation title for News Source
	self.navigationItem.title = self.model.newsTitle;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// Parsing the XML Data
	TouchXMLReader *parser = [[TouchXMLReader alloc] init];
	[parser start:self.model.newsHostWithIndex block:^(NSArray *array) {
		[newsGroup addObjectsFromArray:array];
		[self.tableView reloadData];
	}];
	[parser release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return [newsGroup count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *kHeadlinesCellID = @"HeadlinesCellID";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHeadlinesCellID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kHeadlinesCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	// Set up the cell...
	Feed *newsForNow = [self.newsGroup objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
	cell.textLabel.text = newsForNow.title;
	cell.detailTextLabel.text = newsForNow.published ? [self.dateFormatter stringFromDate:newsForNow.published] : newsForNow.pubDate;
	
	if (!newsForNow.storyIcon && newsForNow.imageString) {
		if (!tableView.dragging && !tableView.decelerating)
			[self startIconDownload:newsForNow forIndexPath:indexPath];
		cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
	} else
		cell.imageView.image = newsForNow.storyIcon;

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

// If imageString is not nil, it supposed to set table view row height to 72.
// If imageString is nil, it supposed to set table view row height to 40.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[newsGroup objectAtIndex:indexPath.row] imageString] ? 72.0f : 40.0f;
}

// When the user taps a row in the table, display the web page that displays articles of the news they selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Feed *newsForNow = [newsGroup objectAtIndex:indexPath.row];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		webViewController = [[WebViewController alloc] init];
		[webViewController setUrl:newsForNow.link];
		[self.navigationController pushViewController:webViewController animated:YES];
		[webViewController release];
	} else {
		[webViewController setUrl:newsForNow.link];
		webViewController.title = newsForNow.title;
	}
}
		 
- (void)startIconDownload:(Feed *)feed forIndexPath:(NSIndexPath *)indexPath {
	IconDownloader *iconDownloader = [imageDownload objectForKey:indexPath];
	if (iconDownloader == nil) {
		iconDownloader = [[IconDownloader alloc] init];
		iconDownloader.feed = feed;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownload setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
	}
}

// this method is used in case the user scrolled into a set of cells that don't have their story icons yet
- (void)loadImagesForOnscreenRows {
    if ([self.newsGroup count] > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            Feed *feed = [self.newsGroup objectAtIndex:indexPath.row];
            if (!feed.storyIcon && feed.imageString) // avoid the story icon download if the story already has an icon
                [self startIconDownload:feed forIndexPath:indexPath];
        }
    }
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath {
	IconDownloader *iconDownloader = [imageDownload objectForKey:indexPath];
    if (iconDownloader != nil) {
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		// Display the newly loaded image
		cell.imageView.image = iconDownloader.feed.storyIcon;
    }
}

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
	// terminate all pending download connections
	NSArray *allDownloads = [self.imageDownload allValues];
	[allDownloads performSelector:@selector(cancelDownload)];
}

- (void)dealloc {
	[newsGroup removeAllObjects];
	[newsGroup release];
	[dateFormatter release];
	[imageDownload release];
	[webViewController release];
	[super dealloc];
}

@end