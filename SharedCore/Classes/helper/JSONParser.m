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

#import "JSONParser.h"
#import "SBJsonParser.h"
#import "GDataHTTPFetcher.h"
#import "Utilities.h"

@implementation JSONParser

+ (void)createJSONRequestWithNetwork: (NSString *)urlString completionBlock: (void (^)(NSArray *))block
{
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	GDataHTTPFetcher *gFetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
	[gFetcher setCookieStorageMethod:kGDataHTTPFetcherCookieStorageMethodNone];
	[gFetcher beginFetchWithCompletionHandler:^(NSData *retrievedData, NSError *error) {
		if (error != nil)
			[Utilities showAlertView:LocalizedString(@"Error Title") message:[error localizedDescription]];
		else {
			NSString *jsonData = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
			SBJsonParser *parser = [[SBJsonParser alloc] init];
			NSArray *jsonArray = [parser objectWithString:jsonData];
			[parser release];
			[jsonData release];
			block(jsonArray);
		}
	}];
}

@end