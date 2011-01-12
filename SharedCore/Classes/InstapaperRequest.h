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

#import <Foundation/Foundation.h>

@class KeychainItemWrapper;

@interface InstapaperRequest : NSObject {
@private
	BOOL isPost;
	NSString *urlString, *title;
	KeychainItemWrapper *keyChainItem;
}

@property (nonatomic) BOOL isPost;
@property (nonatomic, assign) NSString *urlString, *title;

- (NSString *) username;
- (NSString *) password;
- (BOOL) enabled;
- (void) setEnabled:(BOOL)enable;
- (void) setUserName:(NSString *) username password:(NSString *) password;
- (void) loadDataFromURLForcingBasicAuth:(NSURL *)url;
- (BOOL) instapaperReady;
+ (InstapaperRequest *) account;

@end