//
// ASJOverflowMenu.h
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

#import <CoreGraphics/CGBase.h>
#import <Foundation/NSObjCRuntime.h>
#import <UIKit/UIView.h>

@class ASJOverflowItem;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ItemTapBlock)(ASJOverflowItem *item, NSInteger idx);
typedef void (^HideMenuBlock)();

typedef NS_ENUM(NSInteger, MenuAnimationType)
{
  MenuAnimationTypeZoomIn,
  MenuAnimationTypeFadeIn
};

typedef struct MenuMargins
{
  CGFloat top, right, bottom;
} MenuMargins;

static inline MenuMargins MenuMarginsMake(CGFloat top, CGFloat right, CGFloat bottom)
{
  MenuMargins margins = {top, right, bottom};
  return margins;
}

typedef struct SeparatorInsets
{
  CGFloat left, right;
} SeparatorInsets;

static inline SeparatorInsets SeparatorInsetsMake(CGFloat left, CGFloat right)
{
  SeparatorInsets insets = {left, right};
  return insets;
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
 *  The selected overflow menu item's background color when tapped. Defaults to 'nil'.
 */
@property (nullable, strong, nonatomic) UIColor *itemHighlightedColor;

/**
 *  The overflow menu items' font. Defaults to system font 17 pts.
 */
@property (nullable, strong, nonatomic) UIFont *itemFont;

/**
 *  It set YES, the separator between two menu items will be hidden. In that case, setting 'separatorInsets' will do nothing. Defaults to 'YES'.
 */
@property (assign, nonatomic) BOOL hidesSeparator;

/**
 *  If set YES, the shadow around the menu will not be drawn. Defaults to 'NO'.
 */
@property (assign, nonatomic) BOOL hidesShadow;

/**
 *  If set YES, the background will be dimmed while the menu is visible. Defaults to 'NO'.
 */
@property (assign, nonatomic) BOOL dimsBackground;

/**
 *  Sets the degree to which the background is dimmed when menu is shown. Will work only if `dimsBackground ` is set to `YES`. Ranges from 0.0 to 1.0. Defaults to 0.6.
 */
@property (assign, nonatomic) CGFloat dimmingLevel;

/**
 *  Sets the height of individual overflow menu items. Defaults to 40 pts.
 */
@property (assign, nonatomic) CGFloat menuItemHeight;

/**
 *  Sets the ratio according to which the overflow menu width should be calculated. Acceptable values are from 0.0 to 1.0. For example, if your screen width is 320.0 pts and 'widthMultiplier' is set to 0.5, the menu width will be 0.5 * 320.0 = 160 pts. Defaults to 0.4.
 */
@property (assign, nonatomic) CGFloat widthMultiplier;

/**
 *  Sets the left and right insets of the separator between two menu items. Works only if 'hidesSeparator' is set to 'NO'. Defaults to (15.0f, 0.0f).
 */
@property (assign, nonatomic) SeparatorInsets separatorInsets;

/**
 *  The margins of the menu from the top, right and bottom edges. Defaults to 5 pts each.
 */
@property (assign, nonatomic) MenuMargins menuMargins;

/**
 *  Sets which way the menu show be shown; options including fading it in or zooming in from the top right corner. Defaults to 'MenuAnimationZoomIn'.
 */
@property (assign, nonatomic) MenuAnimationType menuAnimation;

/**
 *  A block that is called when any overflow menu item is tapped.
 */
@property (nullable, copy) ItemTapBlock itemTapBlock;

/**
 *  A block that is called when any overflow menu is removed from the screen.
 */
@property (nullable, copy) HideMenuBlock hideMenuBlock;

- (void)setItemTapBlock:(ItemTapBlock _Nullable)itemTapBlock;
- (void)setHideMenuBlock:(HideMenuBlock _Nullable)hideMenuBlock;

@end

NS_ASSUME_NONNULL_END
