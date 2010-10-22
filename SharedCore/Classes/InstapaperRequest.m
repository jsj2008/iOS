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

#import "InstapaperRequest.h"
#import "Base64.h"
#import "Utilities.h"
#import "GDataHTTPFetcher.h"

@implementation InstapaperRequest

@synthesize urlString, isPost, title;

setting_definition(INSTAPAPER_ENABLED);
setting_definition(INSTAPAPER_USERNAME);
setting_definition(INSTAPAPER_PASSWORD);

static InstapaperRequest *account;

+ (void) initialize {
	if (self == [InstapaperRequest class]) {
		account = [[InstapaperRequest alloc] init];
	}
}

+ (InstapaperRequest *) account
{
	return account;
}

- (NSString *) username
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:INSTAPAPER_USERNAME];
}

- (NSString *) password
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:INSTAPAPER_PASSWORD];
}

- (BOOL) enabled
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:INSTAPAPER_ENABLED];
}

- (void) setEnabled:(BOOL)enable {
	[[NSUserDefaults standardUserDefaults] setBool:enable forKey:INSTAPAPER_ENABLED];
}

- (void) setUserName:(NSString *) username password:(NSString *) password
{
	if (!self.enabled) {
		username = @"";
		password = @"";
	}
	[[NSUserDefaults standardUserDefaults] setObject:username forKey:INSTAPAPER_USERNAME];
	[[NSUserDefaults standardUserDefaults] setObject:password forKey:INSTAPAPER_PASSWORD];
}

- (BOOL) instapaperReady
{
	return self.enabled && self.username.length > 0 && self.password.length > 0;
}

- (void)loadDataFromURLForcingBasicAuth:(NSURL *)url
{
	if (!self.instapaperReady)
		return;

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	if (isPost) {
		[request setHTTPMethod:@"POST"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		NSString *setURLParm = [NSString stringWithFormat:@"url=%@,title=%@", urlString, title];
		[request setHTTPBody:[setURLParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
	}

	NSString *authString = [Base64 encode:[[NSString stringWithFormat:@"%@:%@", self.username, self.password] dataUsingEncoding:NSUTF8StringEncoding]]; 
	[request setValue:[NSString stringWithFormat:@"Basic %@", authString] forHTTPHeaderField:@"Authorization"];
	GDataHTTPFetcher *gFetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
	[gFetcher setCookieStorageMethod:kGDataHTTPFetcherCookieStorageMethodNone];
	[gFetcher beginFetchWithCompletionHandler:^(NSData *retrievedData, NSError *error) {
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)[gFetcher response];
		NSString *message = nil;
		switch ([httpResponse statusCode]) {
			case 201:
				message = @"URL has been successfully added to your account";
				break;
			case 400:
				message = @"Bad request";
				break;
			case 403:
				message = @"Invalid username and Password";
				break;
			case 500:
				message = @"The service encountered an error. Please try again later.";
				break;
			default:
				message = @"OK";
				break;
		}
		[Utilities showAlertView:@"Instapaper Result" message:message];
	}];
}

@end