//
//  TableViewController.m
//  DTouchPeekDemo
//
//  Created by ljb48229 on 2017/12/26.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import "TableViewController.h"
#import "PreViewController.h"

@interface TableViewController ()<UIViewControllerPreviewingDelegate>

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"test%ld",indexPath.row];
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    return cell;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self showViewController:viewControllerToCommit sender:self];
}
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)previewingContext.sourceView];
    NSLog(@"%ld",indexPath.row);
    PreViewController *pv = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"previewId"];
    pv.preferredContentSize = CGSizeMake(0, 500);
    pv.text = [NSString stringWithFormat:@"第%ld个",indexPath.row];
    
    return pv;
}

@end
