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

#import "TouchXMLReader.h"
#import "GDataHTTPFetcher.h"
#import "CXMLDocument.h"
#import "CXMLElement.h"
#import "CXMLNode.h"
#import "Utilities.h"

@implementation TouchXMLReader

@synthesize parsedFeeds;

- (void) dealloc {
	[parsedFeeds removeAllObjects];
	[parsedFeeds release];
	[dateFormatter release];
	[super dealloc];
}

// On-demand initializer for read-only property.
- (NSDateFormatter *)dateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z"];
    }
    return dateFormatter;
}

// Constants for the XML element names that will be considered during the parse. 
// Declaring these as static constants reduces the number of objects created during the run
// and is less prone to programmer error.

static NSString *kXPath_Item = @"//item";
static NSString *kXPath_Entry = @"//*[local-name()='entry']";
static NSString *kName_Title = @"title";
static NSString *kName_Link = @"link";
static NSString *kName_PubDate = @"pubDate";
static NSString *kName_Published = @"published";
static NSString *kName_Encol = @"enclosure";

- (void) start: (NSString *) urlString block: (void (^)(NSArray *)) block
{
	// start the network activity indicator
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	GDataHTTPFetcher *gFetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
	[gFetcher setCookieStorageMethod:kGDataHTTPFetcherCookieStorageMethodNone];
	[gFetcher beginFetchWithCompletionHandler:^(NSData *retrievedData, NSError *error) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		if (error != nil)
			[Utilities showAlertView:LocalizedString(@"Error Title") message:[error localizedDescription]];
		else {
			self.parsedFeeds = [NSMutableArray array];
			CXMLDocument *doc = [[CXMLDocument alloc] initWithData:retrievedData options:0 error:nil];
			NSArray *items = [doc nodesForXPath:kXPath_Item error:nil];
			if ([items count] <= 0)
				items = [doc nodesForXPath:kXPath_Entry error:nil];

			for (CXMLElement *item in items) {
				Feed *feed = [[Feed alloc] init];
				NSArray *titles = [item elementsForName:kName_Title];
				for(CXMLElement *title in titles) {
					feed.title = title.stringValue;
					break;
				}
				NSArray *links = [item elementsForName:kName_Link];
				for(CXMLElement *link in links) {
					NSString *hrefAttribute = [[link attributeForName:@"href"] stringValue];
					feed.link = (hrefAttribute != nil) ? hrefAttribute : link.stringValue;
					break;
				}
				NSArray *publishes = [item elementsForName:kName_Published];
				if ([publishes count] > 0) {
					for (CXMLElement *published in publishes) {
						feed.published = [self.dateFormatter dateFromString:published.stringValue];
						break;
					}
				}
				NSArray *pubDates = [item elementsForName:kName_PubDate];
				if ([pubDates count] > 0) {
					for(CXMLElement *pubDate in pubDates) {
						feed.pubDate = pubDate.stringValue;
						break;
					}
				}
				NSArray *encols = [item elementsForName:kName_Encol];
				if ([encols count] > 0) {
					for(CXMLElement *encol in encols) {
						feed.imageString = [[encol attributeForName:@"url"] stringValue];
						break;
					}
				}
				[parsedFeeds addObject:feed];
				[feed release];
			}
			[doc release];
			block(parsedFeeds);
		}
	}];
}

@end