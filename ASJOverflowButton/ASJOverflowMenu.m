//
// ASJOverflowMenu.m
//
// Copyright (c) 2015-2016 Sudeep Jaiswal
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

@interface UITableViewCell (Separators)

- (void)setInsets:(SeparatorInsets)insets;

@end

@implementation UITableViewCell (Separators)

- (void)setInsets:(SeparatorInsets)insets
{
  if ([self respondsToSelector:@selector(setSeparatorInset:)])
  {
    self.separatorInset = UIEdgeInsetsMake(0.0f, insets.left, 0.0f, insets.right);
  }
  if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
  {
    self.preservesSuperviewLayoutMargins = NO;
  }
  if ([self respondsToSelector:@selector(setLayoutMargins:)])
  {
    self.layoutMargins = UIEdgeInsetsMake(0.0f, insets.left, 0.0f, insets.right);
  }
}

@end

@interface ASJOverflowMenu () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) IBOutlet UIView *tableContainerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) NSLayoutConstraint *widthConstraintForMultiplier;
@property (assign, nonatomic) BOOL hasAnimatedMenu;
@property (readonly, nonatomic) CGSize screenSize;

- (void)setupTable;
- (void)setupContentView;
- (void)setupShadow;
- (void)animateMenu;
- (void)reloadTable;
- (void)customizeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)idxPath;

@end

@implementation ASJOverflowMenu

- (void)awakeFromNib
{
  // menu us animated in layoutSubviews. since it should only happen once, a BOOL.
  _hasAnimatedMenu = NO;
  
  [self setupTable];
  [self setupContentView];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  /**
   *  Fix for Issue #2: https://github.com/sudeepjaiswal/ASJOverflowButton/issues/2
   *  Thanks: http://stackoverflow.com/a/39647683
   *  Weirdly, iOS 10 requires this stuff to be done on the main queue, else the menu position and shadow bounds don't set correctly, even though there is a call to focefully layout the view if needed. This was done earlier to fix shadow bounds in iOS 9
   */
  [[NSOperationQueue mainQueue] addOperationWithBlock:^
   {
     // fixes shadow being drawn incorrectly. worked for iOS 9
     [self layoutIfNeeded];
     
     [self setupShadow];
     [self animateMenu];
   }];
}

- (void)setupShadow
{
  if (_hidesShadow == YES)
  {
    _tableContainerView.layer.shadowPath = nil;
    return;
  }
  _tableContainerView.layer.masksToBounds = NO;
  _tableContainerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
  _tableContainerView.layer.shadowOffset = CGSizeMake(1.0f, -1.0f);
  _tableContainerView.layer.shadowOpacity = 1.0f;
  
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_tableContainerView.bounds];
  _tableContainerView.layer.shadowPath = shadowPath.CGPath;
}

#pragma mark - Animate menu

- (void)animateMenu
{
  // fade in happens by default
  if (_menuAnimation == MenuAnimationTypeFadeIn) {
    return;
  }
  
  // don't allow it twice
  if (_hasAnimatedMenu == YES) {
    return;
  }
  
  // thanks Shashank
  CGAffineTransform scale = CGAffineTransformMakeScale(0.0f, 0.0f);
  _tableContainerView.transform = CGAffineTransformConcat(scale, scale);
  
  _tableContainerView.layer.anchorPoint = CGPointMake(1.0f, 0.0f);
  _tableContainerView.layer.position = CGPointMake(self.screenSize.width - _rightConstraint.constant, _topConstraint.constant);
  _tableContainerView.alpha = 0.0f;
  
  [UIView animateWithDuration:0.4f animations:^
   {
     _tableContainerView.alpha = 1.0f;
     _tableContainerView.transform = CGAffineTransformIdentity;
   } completion:^(BOOL finished)
   {
     _hasAnimatedMenu = YES;
   }];
}

#pragma mark - Setup

- (void)setupTable
{
  _itemsTableView.bounces = NO;
  _itemsTableView.opaque = YES;
  _itemsTableView.clipsToBounds = YES;
  _itemsTableView.delaysContentTouches = NO;
  _itemsTableView.tableFooterView = [[UIView alloc] init];
  
  Class cellClass = [UITableViewCell class];
  [_itemsTableView registerClass:cellClass forCellReuseIdentifier:kCellIdentifier];
}

#pragma mark - Content view

- (void)setupContentView
{
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapped:)];
  tap.delegate = self;
  [_contentView addGestureRecognizer:tap];
}

- (void)contentViewTapped:(UITapGestureRecognizer *)tap
{
  [self hideMenu];
}

- (void)hideMenu
{
  if (_hideMenuBlock) {
    _hideMenuBlock();
  }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  return [touch.view isDescendantOfView:_itemsTableView] != YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  [self customizeCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)customizeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)idxPath
{
  if (_hidesSeparator) {
    _itemsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
  else {
    [cell setInsets:_separatorInsets];
  }
  
  cell.backgroundColor = _menuBackgroundColor;
  cell.textLabel.textColor = _itemTextColor;
  cell.textLabel.font = _itemFont;
  
  UIView *background = [[UIView alloc] initWithFrame:cell.contentView.bounds];
  background.backgroundColor = _itemHighlightedColor;
  cell.selectedBackgroundView = background;
  
  ASJOverflowItem *item = _items[idxPath.row];
  cell.textLabel.text = item.name;
  cell.textLabel.backgroundColor = [UIColor clearColor];
  
  if (item.image != nil) {
    cell.imageView.image = item.image;
  }
  else {
    cell.imageView.image = nil;
  }
  
  if (item.backgroundColor != nil) {
    cell.contentView.backgroundColor = item.backgroundColor;
  }
  else {
    cell.contentView.backgroundColor = nil;
  }
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
  [self hideMenu];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Property setters

- (void)setItems:(NSArray *)items
{
  _items = items;
  [self reloadTable];
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

- (void)setItemHighlightedColor:(UIColor *)itemHighlightedColor
{
  _itemHighlightedColor = itemHighlightedColor;
  [self reloadTable];
}

- (void)setItemFont:(UIFont *)itemFont
{
  _itemFont = itemFont;
  [self reloadTable];
}

- (void)setHidesShadow:(BOOL)hidesShadow
{
  _hidesShadow = hidesShadow;
  [self layoutIfNeeded];
}

- (void)setDimsBackground:(BOOL)dimsBackground
{
  _dimsBackground = dimsBackground;
  [self dimBackground];
}

- (void)setDimmingLevel:(CGFloat)dimmingLevel
{
  NSAssert(dimmingLevel >= 0.0f && dimmingLevel <= 1.0f, @"Dimming level must range from 0 to 1.");
  _dimmingLevel = dimmingLevel;
  [self dimBackground];
}

- (void)dimBackground
{
  UIColor *color = [UIColor colorWithWhite:0.0f alpha:_dimmingLevel];
  
  if (!_dimsBackground) {
    color = [UIColor clearColor];
  }
  _contentView.backgroundColor = color;
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
  _widthConstraint = self.widthConstraintForMultiplier;
  _widthConstraint.active = YES;
}

- (NSLayoutConstraint *)widthConstraintForMultiplier
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
  CGFloat screenHeight =  self.screenSize.height;
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

#pragma mark - Property getter

- (CGSize)screenSize
{
  return [UIScreen mainScreen].bounds.size;
}

@end
