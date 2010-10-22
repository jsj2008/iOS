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

#import "ScheduleCell.h"

@implementation ScheduleCell

@synthesize timeLabel = _timeLabel, schLabel = _schLabel, dateLabel = _dateLabel , tvLabel = _tvLabel;

- (id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString *) reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.schLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 30)] autorelease];
		_schLabel.font = [UIFont boldSystemFontOfSize:14.0];
		_schLabel.textAlignment = UITextAlignmentCenter;
		[self.contentView addSubview:_schLabel];
		
		self.timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 25, 0, 16)] autorelease];
		_timeLabel.font = [UIFont systemFontOfSize:13.0];
		[self.contentView addSubview:_timeLabel];
		
		self.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 40, 0, 16)] autorelease];
		_dateLabel.font = [UIFont systemFontOfSize:13.0];
		[self.contentView addSubview:_dateLabel];
		
		self.tvLabel = [[[UILabel alloc] initWithFrame:CGRectMake(230, 25, 0, 16)] autorelease];
		_tvLabel.font = [UIFont systemFontOfSize:14.0];
		_tvLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[self.contentView addSubview:_tvLabel];
	}
	return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
	
    for (UILabel *label in [NSArray arrayWithObjects:_timeLabel, _schLabel, _tvLabel, _dateLabel, nil]) {
        CGRect frame = label.frame;
        frame.size.width = self.contentView.frame.size.width - frame.origin.x;
        label.frame = frame;
    }
}

- (void) dealloc {
	self.timeLabel = nil;
	self.schLabel = nil;
	self.dateLabel = nil;
	self.tvLabel = nil;
	[super dealloc];
}

@end