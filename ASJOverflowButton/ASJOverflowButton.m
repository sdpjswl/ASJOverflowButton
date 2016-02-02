// ASJOverflowButton.m
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

#import "ASJOverflowButton.h"
#import "ASJOverflowMenu.h"

@interface ASJOverflowButton ()

@property (weak, nonatomic) UIViewController *targetController;
@property (copy, nonatomic) NSArray *items;
@property (strong, nonatomic) ASJOverflowMenu *overflowMenu;

- (UIButton *)buttonWithImage:(UIImage *)image;
- (void)setup;
- (void)validateItems;
- (void)setupOverflowMenu;
- (void)handleOverflowBlocks;
- (void)overflowButtonTapped:(id)sender;
- (void)showMenu;
- (void)hideMenu;

@end

@implementation ASJOverflowButton

- (instancetype)initWithTarget:(UIViewController *)target image:(UIImage *)image items:(NSArray *)items
{
  UIButton *btn = [self buttonWithImage:image];
  self = [super initWithCustomView:btn];
  if (self) {
    _targetController = target;
    _items = items;
    [self setup];
  }
  return self;
}

#pragma mark - Setup

- (void)setup
{
  [self validateItems];
  [self setupOverflowMenu];
}

- (void)validateItems
{
  for (id item in _items)
  {
    BOOL success = [item isMemberOfClass:[ASJOverflowItem class]];
    if (!success) {
      NSAssert(success, @"Items must be of kind ASJOverflowItem");
    }
    
    ASJOverflowItem *itemObject = (ASJOverflowItem *)item;
    BOOL nilCheck = (itemObject.name != nil);
    if (!nilCheck) {
      NSAssert(nilCheck, @"ASJOverflowItem property 'name' must not be nil. 'image' however is optional.");
    }
  }
}

- (void)setupOverflowMenu
{
  _overflowMenu = (ASJOverflowMenu *)[[NSBundle mainBundle] loadNibNamed:@"ASJOverflowMenu" owner:self options:nil][0];
  _overflowMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _overflowMenu.frame = _targetController.view.bounds;
  _overflowMenu.items = _items;
  _overflowMenu.alpha = 0.0;
  
  [self handleOverflowBlocks];
}

- (void)handleOverflowBlocks
{
  __weak typeof(self) weakSelf = self;
  [_overflowMenu setItemTapBlock:^(ASJOverflowItem *item, NSInteger idx) {
    if (weakSelf.itemTapBlock) {
      weakSelf.itemTapBlock(item, idx);
    }
  }];
  
  [_overflowMenu setMenuRemoveBlock:^{
    [weakSelf hideMenu];
  }];
}

#pragma mark - Button for custom view

- (UIButton *)buttonWithImage:(UIImage *)image
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0, 0, 44, 44);
  [button setImage:image forState:UIControlStateNormal];
  [button addTarget:self action:@selector(overflowButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  return button;
}

- (void)overflowButtonTapped:(id)sender
{
  [self showMenu];
}

#pragma mark - Property setters

- (void)setMenuBackgroundColor:(UIColor *)menuBackgroundColor
{
  _overflowMenu.menuBackgroundColor = menuBackgroundColor;
}

- (void)setItemTextColor:(UIColor *)itemTextColor
{
  _overflowMenu.itemTextColor = itemTextColor;
}

- (void)setItemFont:(UIFont *)itemFont
{
  _overflowMenu.itemFont = itemFont;
}

- (void)setShouldDimBackground:(BOOL)shouldDimBackground
{
  _overflowMenu.shouldDimBackground = shouldDimBackground;
}

#pragma mark - Show/hide

- (void)showMenu
{
  [_targetController.view addSubview:_overflowMenu];
  [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     _overflowMenu.alpha = 1.0;
                   } completion:nil];
}

- (void)hideMenu
{
  [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     _overflowMenu.alpha = 0.0;
                   } completion:^(BOOL finished) {
                     [_overflowMenu removeFromSuperview];
                   }];
}

@end

@implementation ASJOverflowItem

+ (ASJOverflowItem *)itemWithName:(NSString *)name image:(UIImage *)image
{
  ASJOverflowItem *item = [[ASJOverflowItem alloc] init];
  item.name = name;
  item.image = image;
  return item;
}

@end
