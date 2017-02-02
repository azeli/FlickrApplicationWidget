//
//  TodayViewController.m
//  widgetFlickrTopTags
//
//  Created by Анна  Зелинская on 02.02.17.
//  Copyright © 2017 Анна  Зелинская. All rights reserved.
//

#import "FlickrTopTagsTodayViewController.h"
#import "FlickrURL.h"
#import "TableViewCell.h"
#import <NotificationCenter/NotificationCenter.h>

@interface FlickrTopTagsTodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>

@end

@implementation FlickrTopTagsTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTopTags];
    tagsArray = [NSMutableArray new];
}

-(IBAction)getTopTags{
    NSURL *url = [FlickrURL URLforTopTags];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url
                                                completionHandler:
                                      ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                          if (!error) {
                                              NSData *jsonResults = [NSData dataWithContentsOfURL:url];
                                              NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                                                      options:0
                                                                                                        error:NULL];
                                              NSArray *tags = [results valueForKeyPath:@"hottags.tag"];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  self.tags = tags;
                                              });
                                          }
                                      }];
    [task resume];
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    [self createTag:self.tags];
    [tableViewTopTags reloadData];
}


-(void)createTag:(NSArray *)tags {
    for (NSDictionary *tag in tags) {
        [tagsArray addObject: tag [@"_content"]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tagsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    cell.cellLabel.text = [tagsArray objectAtIndex:indexPath.row];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}

@end
