//
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
#import <UIKit/UIButton.h>
#import <UIKit/UINibLoading.h>
#import <UIKit/UIScreen.h>
#import <UIKit/UIWindow.h>

@interface ASJOverflowButton ()

@property (strong, nonatomic) UIImage *buttonImage;
@property (copy, nonatomic) NSArray *items;
@property (strong, nonatomic) ASJOverflowMenu *overflowMenu;
@property (strong, nonatomic) UIWindow *overflowWindow;

- (void)setup;
- (void)setupDefaults;
- (void)validateItems;
- (void)setupCustomView;
- (UIButton *)buttonWithImage:(UIImage *)image;
- (void)overflowButtonTapped:(id)sender;
- (void)showMenu;
- (void)hideMenu;
- (void)setupOverflowWindow;
- (void)setupOverflowMenu;
- (void)handleOverflowBlocks;
- (void)destroyOverflowWindowAndMenu;

@end

@implementation ASJOverflowButton

- (instancetype)initWithImage:(UIImage *)image items:(NSArray<ASJOverflowItem *> *)items
{
  NSAssert(image, @"You must provide an image for the overflow button.");
  NSAssert(items.count, @"You must provide at least one ASJOverflowItem.");
  
  self = [super init];
  if (self)
  {
    _buttonImage = image;
    _items = items;
    [self setup];
  }
  return self;
}

#pragma mark - Setup

- (void)setup
{
  [self setupDefaults];
  [self validateItems];
  [self setupCustomView];
}

- (void)setupDefaults
{
  _menuBackgroundColor = [UIColor whiteColor];
  _itemTextColor = [UIColor blackColor];
  _itemFont = [UIFont systemFontOfSize:17.0f];
  _shouldDimBackground = NO;
  _widthMultiplier = 0.4f;
  _menuMargins = MenuMarginsMake(5.0f, 5.0f, 5.0f);
}

- (void)validateItems
{
  for (id object in _items)
  {
    NSAssert([object isMemberOfClass:[ASJOverflowItem class]], @"All items must be of type ASJOverflowItem");
    ASJOverflowItem *item = (ASJOverflowItem *)object;
#pragma unused(item)
    NSAssert(item.name, @"ASJOverflowItem's 'name' must not be nil; 'image' is optional.");
  }
}

#pragma mark - Custom view

- (void)setupCustomView
{
  self.customView = [self buttonWithImage:_buttonImage];
}

- (UIButton *)buttonWithImage:(UIImage *)image
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
  [button setImage:image forState:UIControlStateNormal];
  [button addTarget:self action:@selector(overflowButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  return button;
}

- (void)overflowButtonTapped:(id)sender
{
  [self showMenu];
}

#pragma mark - Show/hide

- (void)showMenu
{
  [self setupOverflowWindow];
  [self setupOverflowMenu];
  [self handleOverflowBlocks];
  
  [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^
   {
     _overflowMenu.alpha = 1.0f;
   } completion:nil];
}

- (void)hideMenu
{
  [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^
   {
     _overflowMenu.alpha = 0.0f;
   } completion:^(BOOL finished)
   {
     [self destroyOverflowWindowAndMenu];
   }];
}

#pragma mark - Window + menu

- (void)setupOverflowWindow
{
  _overflowWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  _overflowWindow.tintColor = [UIApplication sharedApplication].delegate.window.tintColor;
  _overflowWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
  _overflowWindow.windowLevel = topWindow.windowLevel + 1;
  [_overflowWindow makeKeyAndVisible];
}

- (void)setupOverflowMenu
{
  NSString *nibName = NSStringFromClass([ASJOverflowMenu class]);
  _overflowMenu = (ASJOverflowMenu *)[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil].firstObject;
  _overflowMenu.items = _items;
  _overflowMenu.alpha = 0.0f;
  _overflowMenu.menuBackgroundColor = _menuBackgroundColor;
  _overflowMenu.itemTextColor = _itemTextColor;
  _overflowMenu.itemFont = _itemFont;
  _overflowMenu.shouldDimBackground = _shouldDimBackground;
  _overflowMenu.widthMultiplier = _widthMultiplier;
  _overflowMenu.menuMargins = _menuMargins;
  _overflowMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _overflowMenu.frame = _overflowWindow.bounds;
  [_overflowWindow addSubview:_overflowMenu];
}

- (void)handleOverflowBlocks
{
  __weak typeof(self) weakSelf = self;
  [_overflowMenu setItemTapBlock:^(ASJOverflowItem *item, NSInteger idx)
   {
     if (weakSelf.itemTapBlock) {
       weakSelf.itemTapBlock(item, idx);
     }
   }];
  
  [_overflowMenu setMenuRemoveBlock:^
   {
     [weakSelf hideMenu];
     
     if (weakSelf.menuRemoveBlock) {
       weakSelf.menuRemoveBlock();
     }
   }];
}

- (void)destroyOverflowWindowAndMenu
{
  @synchronized (self)
  {
    [_overflowMenu removeFromSuperview];
    _overflowMenu = nil;
    _overflowWindow.hidden = YES;
    _overflowWindow = nil;
  }
}

@end

#pragma mark - ASJOverflowItem

@implementation ASJOverflowItem

+ (ASJOverflowItem *)itemWithName:(NSString *)name
{
  ASJOverflowItem *item = [[ASJOverflowItem alloc] init];
  item.name = name;
  return item;
}

+ (ASJOverflowItem *)itemWithName:(NSString *)name image:(UIImage *)image
{
  ASJOverflowItem *item = [[ASJOverflowItem alloc] init];
  item.name = name;
  item.image = image;
  return item;
}

@end
