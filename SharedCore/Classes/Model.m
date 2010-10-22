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

#import "Model.h"

@interface Model()
@property NSInteger cachedNewsIndex;
@end

@implementation Model

@synthesize cachedNewsIndex = _cachedNewsIndex;

setting_definition(NEWS_INDEX);

static Model *model = nil;
static NSDictionary *newsSourcePlist = nil;

+ (void)initialize {
	if (self == [Model class]) {
		model = [[self alloc] init];
		NSString *newsSourcePath = [[NSBundle mainBundle] pathForResource:@"NewsSource" ofType:@"plist"];
		newsSourcePlist = [[NSDictionary alloc] initWithContentsOfFile:newsSourcePath];
	}
}

- (id)init {
	self = [super init];
	if (self)
		self.cachedNewsIndex = -1;
	return self;
}

+ (Model *) model {
	return model;
}

- (NSArray *) settingsForNews {
	return [newsSourcePlist objectForKey:@"Titles"];
}

- (NSString *) newsHostWithIndex {
	return [[newsSourcePlist objectForKey:@"Values"] objectAtIndex:self.newsIndex];
}

- (NSString *) newsTitle {
	return [self.settingsForNews objectAtIndex:self.newsIndex];
}

- (NSInteger) newsIndex {
	if (self.cachedNewsIndex == -1)
		self.cachedNewsIndex = [[NSUserDefaults standardUserDefaults] integerForKey:NEWS_INDEX];
	return self.cachedNewsIndex;
}

- (void) setNewsIndex: (NSInteger) integer {
	self.cachedNewsIndex = integer;
	[[NSUserDefaults standardUserDefaults] setInteger:integer forKey:NEWS_INDEX];
}

@end
