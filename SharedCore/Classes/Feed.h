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

#import <Foundation/Foundation.h>

@interface Feed : NSObject {
@private
	NSString *title;
	NSString *link;
	NSString *pubDate;
	NSString *imageString;
	UIImage *storyIcon;
	NSDate *published;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *pubDate;
@property (nonatomic, retain) NSDate *published;
@property (nonatomic, retain) NSString *imageString;
@property (nonatomic, retain) UIImage *storyIcon;

@end