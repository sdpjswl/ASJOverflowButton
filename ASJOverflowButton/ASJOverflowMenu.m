//
//  ASJOverflowMenu.m
//  ASJOverflowButtonExample
//
//  Created by sudeep on 21/12/15.
//  Copyright © 2015 sudeep. All rights reserved.
//

#import "ASJOverflowMenu.h"
#import "ASJOverflowButton.h"

static NSString *const kCellIdentifier = @"cell";

@interface ASJOverflowMenu () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (void)setupTable;
- (UITableViewCell *)customisedCellFromCell:(UITableViewCell *)cell;
- (void)reloadTable;

@end

@implementation ASJOverflowMenu

- (void)awakeFromNib
{
  [self setupTable];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self setupShadow];
}

#pragma mark - Setup

- (void)setupTable
{
  _contentView.backgroundColor = [UIColor clearColor];
  _itemsTableView.backgroundColor = [UIColor clearColor];
  _itemsTableView.tableFooterView = [[UIView alloc] init];
  _itemsTableView.delaysContentTouches = NO;
  _itemsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  Class cellClass = [UITableViewCell class];
  [_itemsTableView registerClass:cellClass forCellReuseIdentifier:kCellIdentifier];
}

#pragma mark - Property setters

- (void)setItems:(NSArray *)items
{
  _items = items;
  [self layoutIfNeeded];
}

- (void)setupShadow
{
  CGRect frame = _itemsTableView.bounds;
  frame.size.height = 44 * _items.count;
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:frame];
  _itemsTableView.layer.masksToBounds = NO;
  _itemsTableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
  _itemsTableView.layer.shadowOffset = CGSizeMake(0, 0);
  _itemsTableView.layer.shadowOpacity = 0.5;
  _itemsTableView.layer.shadowRadius = 2.0;
  _itemsTableView.layer.shadowPath = shadowPath.CGPath;
}

- (void)setMenuBackgroundColor:(UIColor *)menuBackgroundColor
{
  _menuBackgroundColor = menuBackgroundColor;
  [self reloadTable];
}

- (void)setItemTextColor:(UIColor *)itemTextColor
{
  _itemTextColor = itemTextColor;
  [self reloadTable];
}

- (void)setItemFont:(UIFont *)itemFont
{
  _itemFont = itemFont;
  [self reloadTable];
}

- (void)setShouldDimBackground:(BOOL)shouldDimBackground
{
  if (shouldDimBackground) {
    _contentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
  }
}

- (void)reloadTable
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [_itemsTableView reloadData];
  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  cell = [self customisedCellFromCell:cell];
  
  ASJOverflowItem *item = _items[indexPath.row];
  cell.textLabel.text = item.name;
  if (item.imageName) {
    cell.imageView.image = [UIImage imageNamed:item.imageName];
  }
  return cell;
}

- (UITableViewCell *)customisedCellFromCell:(UITableViewCell *)cell
{
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }
  if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    [cell setPreservesSuperviewLayoutMargins:NO];
  }
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
  
  if (_menuBackgroundColor) {
    cell.backgroundColor = _menuBackgroundColor;
  }
  else {
    cell.backgroundColor = [UIColor whiteColor];
  }
  
  if (_itemTextColor) {
    cell.textLabel.textColor = _itemTextColor;
  }
  else {
    cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
  }
  
  if (_itemFont) {
    cell.textLabel.font = _itemFont;
  }
  else {
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
  }
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (_itemTapBlock) {
    _itemTapBlock(_items[indexPath.row], indexPath.row);
  }
  [self removeView];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Touch handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesBegan:touches withEvent:event];
  [self removeView];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  // check if a row was hit
  CGPoint newPoint = [self convertPoint:point toView:_itemsTableView];
  NSIndexPath *indexPath = [_itemsTableView indexPathForRowAtPoint:newPoint];
  if (!indexPath)
  {
#warning called twice on tapping outside cells
    NSLog(@"here");
    [self removeView];
    return nil;
  }
  return [super hitTest:point withEvent:event];
}

#pragma mark - Removal

- (void)removeView
{
  [UIView animateWithDuration:0.4
                        delay:0.0
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     self.alpha = 0.0;
                   } completion:^(BOOL finished) {
                     [self removeFromSuperview];
                   }];
}

@end
