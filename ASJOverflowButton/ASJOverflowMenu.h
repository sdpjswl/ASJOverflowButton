//
// ASJOverflowMenu.h
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

#import <CoreGraphics/CGBase.h>
#import <Foundation/NSObjCRuntime.h>
#import <UIKit/UIView.h>

@class ASJOverflowItem;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ItemTapBlock)(ASJOverflowItem *item, NSInteger idx);
typedef void (^MenuRemoveBlock)();

typedef struct MenuMargins
{
  CGFloat top, right, bottom;
} MenuMargins;

static inline MenuMargins MenuMarginsMake(CGFloat top, CGFloat right, CGFloat bottom)
{
  MenuMargins margins = {top, right, bottom};
  return margins;
}

@interface ASJOverflowMenu : UIView

/**
 *  An array of ASJOverflowItems to show on the menu.
 */
@property (copy, nonatomic) NSArray<ASJOverflowItem *> *items;

/**
 *  The overflow menu's background color. Defaults to white.
 */
@property (nullable, strong, nonatomic) UIColor *menuBackgroundColor;

/**
 *  The overflow menu items' text color. Defaults to black.
 */
@property (nullable, strong, nonatomic) UIColor *itemTextColor;

/**
 *  The overflow menu items' font. Defaults to system font 17 pt.
 */
@property (nullable, strong, nonatomic) UIFont *itemFont;

/**
 *  If set YES, the background will be dimmed while the menu is visible. Defaults to NO.
 */
@property (assign, nonatomic) BOOL dimsBackground;

/**
 *  If set YES, the shadow around the menu will not be drawn.
 */
@property (assign, nonatomic) BOOL hidesShadow;

/**
 *  Sets the height of individual overflow menu items. Defaults to 40 pt.
 */
@property (assign, nonatomic) CGFloat menuItemHeight;

/**
 *  Set the ratio according to which the overflow menu width should be calculated. Acceptable values are from 0.0 to 1.0. For example, if your screen width is 320.0 pts and 'widthMultiplier' is set to 0.5, the menu width will be 0.5 * 320.0 = 160 pts. Defaults to 0.4.
 */
@property (assign, nonatomic) CGFloat widthMultiplier;

/**
 *  The margins of the menu from the top, right and bottom edges. Defaults to 5 pt each.
 */
@property (assign, nonatomic) MenuMargins menuMargins;

/**
 *  A block that is called when any overflow menu item is tapped.
 */
@property (nullable, copy) ItemTapBlock itemTapBlock;

/**
 *  A block that is called when any overflow menu item is removed from the screen.
 */
@property (nullable, copy) MenuRemoveBlock menuRemoveBlock;

- (void)setItemTapBlock:(ItemTapBlock _Nullable)itemTapBlock;
- (void)setMenuRemoveBlock:(MenuRemoveBlock _Nullable)menuRemoveBlock;

@end

NS_ASSUME_NONNULL_END
