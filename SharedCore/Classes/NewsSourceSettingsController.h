//
//  NewsSourceSettingsController.h
//  SharedCore
//
//  Created by Jonathan Steele on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@protocol NewsSourceSettingDelegate
- (void)didSelectedNewsSourceFromSettings;
@end

@interface NewsSourceSettingsController : AbstractTableViewController {
	id <NewsSourceSettingDelegate> delegate;
}

@property (nonatomic, assign) id <NewsSourceSettingDelegate> delegate;

@end