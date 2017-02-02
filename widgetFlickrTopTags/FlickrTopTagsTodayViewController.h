//
//  TodayViewController.h
//  widgetFlickrTopTags
//
//  Created by Анна  Зелинская on 02.02.17.
//  Copyright © 2017 Анна  Зелинская. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrTopTagsTodayViewController : UIViewController {
    @private
        IBOutlet UITableView *tableViewTopTags;
        NSMutableArray *tagsArray;
}

@property (nonatomic,strong) NSArray *tags;

@end
