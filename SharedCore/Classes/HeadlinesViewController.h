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

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"
#import "IconDownloader.h"

@class WebViewController;

@interface HeadlinesViewController : AbstractTableViewController <IconDownloaderDelegate> {
	NSMutableArray *newsGroup; // the main data model for our UITableView
	WebViewController *webViewController;
	NSMutableDictionary *imageDownload;
	// This date formatter is used to convert NSDate objects to NSString objects, using the user's preferred formats.
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) NSMutableArray *newsGroup;
@property (nonatomic, retain) NSMutableDictionary *imageDownload;
@property (nonatomic, retain) IBOutlet WebViewController *webViewController;
@property (nonatomic, retain, readonly) NSDateFormatter *dateFormatter;

@end