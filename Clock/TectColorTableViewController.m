//
//  TectColorTableViewController.m
//  Clock
//
//  Created by Andrew on 10/1/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TectColorTableViewController.h"

@interface TectColorTableViewController ()

@end

@implementation TectColorTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (NSIndexPath * indexpath in [self.tableView indexPathsForSelectedRows]) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",(long)indexpath.row] forKey:@"colorText"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
