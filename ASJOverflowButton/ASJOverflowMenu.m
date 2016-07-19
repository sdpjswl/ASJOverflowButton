//
// ASJOverflowMenu.m
//
// Copyright (c) 2015 Sudeep Jaiswal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ASJOverflowMenu.h"
#import "ASJOverflowButton.h"
#import <QuartzCore/CALayer.h>
#import <UIKit/UIBezierPath.h>
#import <UIKit/UIImageView.h>
#import <UIKit/UILabel.h>
#import <UIKit/UIScreen.h>
#import <UIKit/UITableView.h>
#import <UIKit/UITapGestureRecognizer.h>

static NSString *const kCellIdentifier = @"cell";

#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

@interface ASJOverflowMenu () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) IBOutlet UIView *tableContainerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) NSLayoutConstraint *widthConstraintForNewMultiplier;

- (void)setupTable;
- (void)setupContentView;
- (UITableViewCell *)customisedCellFromCell:(UITableViewCell *)cell;
- (void)reloadTable;

@end

@implementation ASJOverflowMenu

- (void)awakeFromNib
{
  [self setupTable];
  [self setupContentView];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self layoutIfNeeded];
  
  if (_hidesShadow == NO) {
    [self setupShadow];
  }
  else {
    _tableContainerView.layer.shadowPath = nil;
  }
}

#pragma mark - Setup

- (void)setupTable
{
  _itemsTableView.bounces = NO;
  _itemsTableView.clipsToBounds = YES;
  _itemsTableView.delaysContentTouches = NO;
  _itemsTableView.backgroundColor = [UIColor clearColor];
  _itemsTableView.tableFooterView = [[UIView alloc] init];
  _itemsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  Class cellClass = [UITableViewCell class];
  [_itemsTableView registerClass:cellClass forCellReuseIdentifier:kCellIdentifier];
}

- (void)setupContentView
{
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapped:)];
  tap.delegate = self;
  [_contentView addGestureRecognizer:tap];
}

#pragma mark - Touch handling

- (void)contentViewTapped:(UITapGestureRecognizer *)tap
{
  [self removeView];
}

/**
 *  Thanks: http://stackoverflow.com/questions/11570160/uitableview-passes-touch-events-to-superview-when-it-shouldnt
 *  don't allow content view's tap gesture to be detected inside table view
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  CGPoint location = [touch locationInView:self];
  UIView *view = [self hitTest:location withEvent:nil];
  if ([view isDescendantOfView:_itemsTableView])
  {
    CGPoint tapPoint = [self convertPoint:location toView:_itemsTableView];
    NSIndexPath *idxPath = [_itemsTableView indexPathForRowAtPoint:tapPoint];
    if (!idxPath) {
      [self removeView];
    }
    return NO;
  }
  return YES;
}

#pragma mark - Property setters

- (void)setItems:(NSArray *)items
{
  _items = items;
  [self layoutIfNeeded];
}

- (void)setupShadow
{
  _tableContainerView.layer.masksToBounds = NO;
  _tableContainerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
  _tableContainerView.layer.shadowOffset = CGSizeMake(1.0f, -1.0f);
  _tableContainerView.layer.shadowOpacity = 1.0f;
  
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_tableContainerView.bounds];
  _tableContainerView.layer.shadowPath = shadowPath.CGPath;
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

- (void)setDimsBackground:(BOOL)dimsBackground
{
  _dimsBackground = dimsBackground;
  UIColor *color = [UIColor colorWithWhite:0.0f alpha:0.6f];
  
  if (!dimsBackground) {
    color = [UIColor clearColor];
  }
  
  _contentView.backgroundColor = color;
}

- (void)setHidesShadow:(BOOL)hidesShadow
{
  _hidesShadow = hidesShadow;
  [self layoutIfNeeded];
}

- (void)setMenuItemHeight:(CGFloat)menuItemHeight
{
  _menuItemHeight = menuItemHeight;
  [self reloadTable];
}

/**
 *  Since 'multiplier' property is readonly, I am creating a new width constraint with the same properties as the current one but assigning the new multiplier to it. Only after setting it active does it work.
 */
- (void)setWidthMultiplier:(CGFloat)widthMultiplier
{
  NSAssert(widthMultiplier >= 0.0f && widthMultiplier <= 1.0f, @"Width multiplier must range from 0 to 1.");
  _widthMultiplier = widthMultiplier;
  _widthConstraint = self.widthConstraintForNewMultiplier;
  _widthConstraint.active = YES;
}

- (NSLayoutConstraint *)widthConstraintForNewMultiplier
{
  return [NSLayoutConstraint
          constraintWithItem:_widthConstraint.firstItem
          attribute:_widthConstraint.firstAttribute
          relatedBy:_widthConstraint.relation
          toItem:_widthConstraint.secondItem
          attribute:_widthConstraint.secondAttribute
          multiplier:_widthMultiplier
          constant:0.0f];
}

- (void)setMenuMargins:(MenuMargins)menuMargins
{
  _menuMargins = menuMargins;
  _topConstraint.constant = menuMargins.top + kStatusBarHeight;
  _bottomConstraint.constant = menuMargins.bottom;
  _rightConstraint.constant = menuMargins.right;
  
  CGFloat menuSize = _menuItemHeight * _items.count;
  CGFloat screenHeight =  [UIScreen mainScreen].bounds.size.height;
  CGFloat bottomConstant = screenHeight - menuSize - _topConstraint.constant;
  
  if (bottomConstant < menuMargins.bottom) {
    bottomConstant = menuMargins.bottom;
  }
  
  _bottomConstraint.constant = bottomConstant;
  [self layoutIfNeeded];
}

- (void)reloadTable
{
  [_itemsTableView reloadData];
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
  if (item.image) {
    cell.imageView.image = item.image;
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
    cell.textLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
  }
  
  if (_itemFont) {
    cell.textLabel.font = _itemFont;
  }
  else {
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
  }
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return _menuItemHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (_itemTapBlock) {
    _itemTapBlock(_items[indexPath.row], indexPath.row);
  }
  [self removeView];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Removal

- (void)removeView
{
  if (_menuRemoveBlock) {
    _menuRemoveBlock();
  }
}

@end
