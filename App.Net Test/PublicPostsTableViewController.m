//
//  MasterViewController.m
//  App.Net Test
//
//  Created by Gayle Dunham on 6/26/13.
//  Copyright (c) 2013 Gayle Dunham. All rights reserved.
//

#import "PublicPostsTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Post.h"
#import "AppDotNetSocialNetwork.h"

static CGFloat const MinimumTableRowHeight   = 66.0;
static CGFloat const MaximumDetailTextWidth  = 237.0;
static CGFloat const MaximumDetailTextHeight = 400.0;
static CGFloat const DetailTextPadding       = 2.0;
static CGFloat const DetailTextOriginY       = 27.0;

@interface PublicPostsTableViewController () {
    NSMutableArray *_posts;
}
@end

@implementation PublicPostsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(_refresh:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self _refresh:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    _posts = nil;
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Calculate the height of the table view cell based on how many lines of text in the message
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize maximumSize = CGSizeMake(MaximumDetailTextWidth, MaximumDetailTextHeight);
    
    Post *object = _posts[indexPath.row];

    CGSize messageHeighSize = [object.message sizeWithFont:[UIFont systemFontOfSize:14.0]
                                         constrainedToSize:maximumSize
                                             lineBreakMode:NSLineBreakByWordWrapping];
                               
    CGFloat tableHeight = DetailTextOriginY + DetailTextPadding + messageHeighSize.height;
    
    return MAX(tableHeight, MinimumTableRowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];

    Post *object = _posts[indexPath.row];
    cell.imageView.image      = object.avatar;
    cell.textLabel.text       = object.userName;
    cell.detailTextLabel.text = object.message;
    
    // Debug code to see the time and date stamp
    // cell.detailTextLabel.text       = [NSString stringWithFormat:@"%@\n%@", object.datePosted, cell.detailTextLabel.text];

    // Make the message multi line
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;

    // Round the corners of the image
    cell.imageView.layer.cornerRadius = 9.0;
    cell.imageView.layer.masksToBounds = YES;
    
    return cell;
}

- (void)_refresh:(id)sender
{
    UIRefreshControl *spinner = self.refreshControl;
    
    [AppDotNetSocialNetwork downloadLatestPostsWithCompletionHandler:^(NSMutableArray *newPosts) {
        _posts = newPosts;
        
        // Sort post newest first
        [_posts sortUsingComparator:^(id obj1, id obj2){
             return [[obj2 datePosted] caseInsensitiveCompare:[obj1 datePosted]];
        }];
        
        [spinner endRefreshing];
        // Scroll tableView to hide refresh controll
        [self.tableView setContentOffset:CGPointMake(0.0, 44.0)];
        [self.tableView reloadData];
    }];
}

@end












