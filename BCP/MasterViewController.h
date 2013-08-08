//
//  MasterViewController.h
//  BCP
//
//  Created by Jon Holloway on 30/07/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

- (IBAction)PushThisOne:(id)sender;


@end
