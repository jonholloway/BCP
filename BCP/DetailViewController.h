//
//  DetailViewController.h
//  BCP
//
//  Created by Jon Holloway on 30/07/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)PushIt:(id)sender;



@end
