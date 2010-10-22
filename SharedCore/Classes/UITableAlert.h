//
//  UITableAlert.h
//  UIAlert-EmbeddedTable
//
//  Created by Skylar Cantu on 10/10/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UITableAlert : UIAlertView <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *array;
	NSMutableArray *_blocks;
@private
	UITableView *table;
}

- (id) initWithTitle:(NSString *) _title;
- (void) addListToTableView:(NSString *) string block: (void (^)(NSInteger row))block;

@end