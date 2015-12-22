//  ASJOverflowMenu.m
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

static NSString *const kCellIdentifier = @"cell";

@interface ASJOverflowMenu () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

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
  [self setupShadow];
}

#pragma mark - Setup

- (void)setupTable
{
  _itemsTableView.backgroundColor = [UIColor clearColor];
  _itemsTableView.tableFooterView = [[UIView alloc] init];
  _itemsTableView.delaysContentTouches = NO;
  _itemsTableView.bounces = NO;
  _itemsTableView.clipsToBounds = YES;
  _itemsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  Class cellClass = [UITableViewCell class];
  [_itemsTableView registerClass:cellClass forCellReuseIdentifier:kCellIdentifier];
}

- (void)setupContentView
{
  _contentView.backgroundColor = [UIColor clearColor];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapped:)];
  tap.delegate = self;
  [_contentView addGestureRecognizer:tap];
}

#pragma mark - Touch handling

- (void)contentViewTapped:(UITapGestureRecognizer *)tap
{
  [self removeView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  // thanks to: http://stackoverflow.com/questions/11570160/uitableview-passes-touch-events-to-superview-when-it-shouldnt
  // don't allow content view's tap gesture to be detected inside table view
  CGPoint location = [touch locationInView:self];
  UIView *view = [self hitTest:location withEvent:nil];
  if ([view isDescendantOfView:_itemsTableView])
  {
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
  CGRect frame = _itemsTableView.bounds;
  frame.size.height = 44 * _items.count;
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:frame];
  _itemsTableView.layer.masksToBounds = YES;
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
  if (item.image)
  {
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

#pragma mark - Removal

- (void)removeView
{
  if (_menuRemoveBlock) {
    _menuRemoveBlock();
  }
}

@end
