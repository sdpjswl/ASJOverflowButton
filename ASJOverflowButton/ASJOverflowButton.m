//
// ASJOverflowButton.m
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

#import "ASJOverflowButton.h"
#import <QuartzCore/CALayer.h>
#import <UIKit/UIButton.h>
#import <UIKit/UINibLoading.h>
#import <UIKit/UIScreen.h>
#import <UIKit/UIViewController.h>

#define kDefaultHighlightedColor [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f]

@interface ASJOverflowButton ()

@property (strong, nonatomic) __kindof UIViewController *vc;
@property (strong, nonatomic) UIImage *buttonImage;
@property (strong, nonatomic) ASJOverflowMenu *overflowMenu;
@property (copy, nonatomic) NSArray<ASJOverflowItem *> *items;
@property (readonly, nonatomic) UIViewAutoresizing autoresizingMasks;

- (void)setup;
- (void)setupDefaults;
- (void)validateItems;
- (void)setupCustomView;
- (void)buttonTapped:(id)sender;
- (void)showMenu;
- (void)hideMenu;
- (void)setupMenu;
- (void)handleBlocks;
- (void)destroyMenu;

@end

@implementation ASJOverflowButton

- (instancetype)initWithTarget:(__kindof UIViewController *)target image:(UIImage *)image items:(NSArray<ASJOverflowItem *> *)items
{
    NSAssert(target, @"You must provide the controller from which the menu is to be presented.");
    NSAssert(image, @"You must provide an image for the overflow button.");
    NSAssert(items.count, @"You must provide at least one ASJOverflowItem.");
    
    self = [super init];
    if (self)
    {
        _vc = target;
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
    _itemHighlightedColor = kDefaultHighlightedColor;
    _itemFont = [UIFont systemFontOfSize:17.0f];
    _hidesShadow = NO;
    _hidesSeparator = YES;
    _dimsBackground = NO;
    _dimmingLevel = 0.6f;
    _menuItemHeight = 40.0f;
    _widthMultiplier = 0.4f;
    _menuAnimationType = MenuAnimationTypeZoomIn;
    _separatorInsets = SeparatorInsetsMake(15.0f, 0.0f);
    _menuMargins = MenuMarginsMake(5.0f, 5.0f, 5.0f);
    _borderColor = [UIColor grayColor];
    _borderWidth = 0.0f;
}

- (void)validateItems
{
    for (id object in _items)
    {
        NSAssert([object isMemberOfClass:[ASJOverflowItem class]], @"All items must be of type ASJOverflowItem");
        __attribute__((unused)) ASJOverflowItem *item = (ASJOverflowItem *)object;
        NSAssert(item.name, @"ASJOverflowItem's 'name' must not be nil; 'image' is optional.");
    }
}

#pragma mark - Custom view

- (void)setupCustomView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
    button.autoresizingMask = self.autoresizingMasks;
    [button setImage:_buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.customView = button;
}

- (void)buttonTapped:(id)sender
{
    [self showMenu];
}

#pragma mark - Show/hide

- (void)showMenu
{
    [self setupMenu];
    [self handleBlocks];
    
    _overflowMenu.alpha = 0.0f;
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
        self->_overflowMenu.alpha = 1.0f;
    } completion:nil];
}

- (void)hideMenu
{
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
        self->_overflowMenu.alpha = 0.0f;
    } completion:^(BOOL finished)
     {
        [self destroyMenu];
    }];
}

#pragma mark - Menu

- (void)setupMenu
{
    NSString *nibName = NSStringFromClass([ASJOverflowMenu class]);
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    _overflowMenu = (ASJOverflowMenu *)[bundle loadNibNamed:nibName owner:nil options:nil].firstObject;
    _overflowMenu.autoresizingMask = self.autoresizingMasks;
    _overflowMenu.frame = _vc.view.bounds;
    [_vc.view addSubview:_overflowMenu];
    
    // look and feel
    _overflowMenu.items = _items;
    _overflowMenu.itemFont = _itemFont;
    _overflowMenu.hidesShadow = _hidesShadow;
    _overflowMenu.hidesSeparator = _hidesSeparator;
    _overflowMenu.itemTextColor = _itemTextColor;
    _overflowMenu.dimsBackground = _dimsBackground;
    _overflowMenu.dimmingLevel = _dimmingLevel;
    _overflowMenu.menuAnimation = _menuAnimationType;
    _overflowMenu.menuItemHeight = _menuItemHeight;
    _overflowMenu.separatorInsets = _separatorInsets;
    _overflowMenu.menuBackgroundColor = _menuBackgroundColor;
    _overflowMenu.itemHighlightedColor = _itemHighlightedColor;
    _overflowMenu.borderColor = _borderColor;
    _overflowMenu.borderWidth = _borderWidth;
    
    // size
    _overflowMenu.menuMargins = _menuMargins;
    _overflowMenu.widthMultiplier = _widthMultiplier;
}

- (UIViewAutoresizing)autoresizingMasks
{
    return UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)handleBlocks
{
    __weak typeof(self) weakSelf = self;
    [_overflowMenu setItemTapBlock:^(ASJOverflowItem *item, NSInteger idx)
     {
        if (weakSelf.itemTapBlock) {
            weakSelf.itemTapBlock(item, idx);
        }
    }];
    
    [_overflowMenu setHideMenuBlock:^
     {
        [weakSelf hideMenu];
        
        if (weakSelf.hideMenuBlock) {
            weakSelf.hideMenuBlock();
        }
    }];
    [_overflowMenu setDelegate:_delegate];
}

- (void)destroyMenu
{
    @synchronized (self)
    {
        [_overflowMenu removeFromSuperview];
        _overflowMenu = nil;
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

+ (ASJOverflowItem *)itemWithName:(NSString *)name tapBlock:(ItemTapBlock)itemTapBlock
{
    ASJOverflowItem *item = [[ASJOverflowItem alloc] init];
    item.name = name;
    item.itemTapBlock = itemTapBlock;
    return item;
}

+ (ASJOverflowItem *)itemWithName:(NSString *)name image:(UIImage *)image backgroundColor:(nullable UIColor *)backgroundColor
{
    ASJOverflowItem *item = [[ASJOverflowItem alloc] init];
    item.name = name;
    item.image = image;
    item.backgroundColor = backgroundColor;
    return item;
}

@end
