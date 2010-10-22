//
//  UITableAlert.m
//  UIAlert-EmbeddedTable
//
//  Created by Skylar Cantu on 10/10/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "UITableAlert.h"

@implementation UITableAlert

- (id) initWithTitle:(NSString *) _title {
	self = [super initWithTitle:_title message:nil delegate:self cancelButtonTitle:LocalizedString(@"Cancel") otherButtonTitles:nil];
	if (self) {
		array = [[NSMutableArray alloc] init];
		_blocks = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		table.delegate = self;
		table.dataSource = self;

		CALayer *tableLayer = [table layer];
		[tableLayer setMasksToBounds:YES];
		[tableLayer setCornerRadius:7];
		
    }
    return self;
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:CGRectMake(0, 0, rect.size.width, 310)];
	self.center = CGPointMake(320/2, 480/2);
}

- (void)layoutSubviews {
	CGFloat buttonTop = 0;
	for (UIView *view in self.subviews) {
		if ([[[view class] description] isEqualToString:@"UIThreePartButton"]) {
			view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height - view.frame.size.height - 15, view.frame.size.width, view.frame.size.height);
			buttonTop = view.frame.origin.y;
		}
	}
	
	buttonTop -= 7;
	buttonTop -= 200;
	
	UIView *container = [[UIView alloc] initWithFrame:CGRectMake(12, buttonTop, self.frame.size.width - 53, 200)];
	container.backgroundColor = [UIColor clearColor];
	container.clipsToBounds = YES;
	[self addSubview:container];
	
	table.frame = container.bounds;
	[container addSubview:table];
	
	UIGraphicsBeginImageContext(container.frame.size);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
	CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(0, -3), 3.0);
	CGFloat radius = 7;	
	CGFloat minx = CGRectGetMinX(container.bounds), midx = CGRectGetMidX(container.bounds), maxx = CGRectGetMaxX(container.bounds);
	CGFloat miny = CGRectGetMinY(container.bounds), midy = CGRectGetMidY(container.bounds), maxy = CGRectGetMaxY(container.bounds);		
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), minx, midy);
	CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), minx, maxy, minx, midy, radius);
	CGContextClosePath(UIGraphicsGetCurrentContext());	
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
	[container addSubview:imageView];
	[imageView release];
	UIGraphicsEndImageContext();
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void) addListToTableView:(NSString *) string block: (void (^)(NSInteger row))block {
	[_blocks addObject: [[block copy] autorelease]];
	[array addObject:string];
}

// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = [array objectAtIndex:indexPath.row];                      
			break;
		default:
			break;
	}
	
	return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	/* Run the title's block */
    if (indexPath.row >= 0 && indexPath.row < [_blocks count]) {
        void (^b)() = [_blocks objectAtIndex:indexPath.row];
        b(indexPath.row);
    }
	[super dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dealloc {
	[array removeAllObjects];
	[array release];
	[_blocks release];
	[table release];
    [super dealloc];
}

@end