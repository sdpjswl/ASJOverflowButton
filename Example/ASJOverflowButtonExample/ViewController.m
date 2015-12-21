//
//  ViewController.m
//  ASJOverflowButtonExample
//
//  Created by sudeep on 21/12/15.
//  Copyright © 2015 sudeep. All rights reserved.
//

#import "ViewController.h"
#import "ASJOverflowButton.h"

@interface ViewController () {
  ASJOverflowButton *overflowButton;
}

- (void)setup;
- (void)setupOverflowButton;
- (void)handleOverflowTap;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self setup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setup
{
  self.title = @"Tap me -->";
  [self setupOverflowButton];
}

- (void)setupOverflowButton
{
  ASJOverflowItem *item1 = [ASJOverflowItem itemWithName:@"Item 1" imageName:nil];
  ASJOverflowItem *item2 = [ASJOverflowItem itemWithName:@"Item 2" imageName:nil];
  ASJOverflowItem *item3 = [ASJOverflowItem itemWithName:@"Item 3" imageName:nil];
  ASJOverflowItem *item4 = [ASJOverflowItem itemWithName:@"Item 4" imageName:nil];
  NSArray *items = @[item1, item2, item3, item4];
  
  overflowButton = [[ASJOverflowButton alloc] initWithTarget:self.navigationController image:[UIImage imageNamed:@"overflow_icon"] items:items];
  overflowButton.shouldDimBackground = YES;
  overflowButton.menuBackgroundColor = [UIColor whiteColor];
  overflowButton.itemTextColor = [UIColor blackColor];
  overflowButton.itemFont = [UIFont fontWithName:@"Verdana" size:13.0];
  self.navigationItem.rightBarButtonItem = overflowButton;
  
  [self handleOverflowTap];
}

- (void)handleOverflowTap
{
  [overflowButton setItemTapBlock:^(ASJOverflowItem *item, NSInteger idx)
   {
     NSString *message = [NSString stringWithFormat:@"You tapped: %@", item.name];
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tapped" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];
   }];
}

@end
