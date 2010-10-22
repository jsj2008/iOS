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

#import "Utilities.h"
#import <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation Utilities

+ (void) showAlertView: (NSString *) title message: (NSString *) message {
#ifdef DEBUG
	NSAssert([NSThread mainThread], @"Not on the main thread");
#endif
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:title
														 message:message
														delegate:nil
											   cancelButtonTitle:LocalizedString(@"OK")
											   otherButtonTitles:nil] autorelease];
	[alertView show];
}

+ (BOOL) isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags) flags {
	// kSCNetworkReachabilityFlagsReachable indicates that the specified nodename or address can
	// be reached using the current network configuration.
	BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
	
	// This flag indicates that the specified nodename or address can
	// be reached using the current network configuration, but a
	// connection must first be established.
	//
	// If the flag is false, we don't have a connection. But because CFNetwork
	// automatically attempts to bring up a WWAN connection, if the WWAN reachability
	// flag is present, a connection is not required.
	BOOL noConnectionRequired = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN))
		noConnectionRequired = YES;
	
	return (isReachable && noConnectionRequired) ? YES : NO;
}

+ (BOOL) isNetworkAvailable {
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	SCNetworkReachabilityRef networkReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	BOOL gotFlags = SCNetworkReachabilityGetFlags(networkReachability, &flags);
	CFRelease(networkReachability);
	
	return (!gotFlags) ? NO : [self isReachableWithoutRequiringConnection:flags];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRed:green:blue:alpha
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum])
		return nil;
	int r = (hexNum >> 16) & 0xFF;
	int g = (hexNum >> 8) & 0xFF;
	int b = (hexNum) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

@end