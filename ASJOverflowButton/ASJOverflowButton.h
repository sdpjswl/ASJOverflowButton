//
// ASJOverflowButton.h
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
#import <UIKit/UIBarButtonItem.h>

@class ASJOverflowItem;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ItemTapBlock)(ASJOverflowItem *item, NSInteger idx);
typedef void (^MenuRemoveBlock)();

@interface ASJOverflowButton : UIBarButtonItem

/**
 *  The overflow menu's background color.
 */
@property (nullable, strong, nonatomic) UIColor *menuBackgroundColor;

/**
 *  The overflow menu items' text color.
 */
@property (nullable, strong, nonatomic) UIColor *itemTextColor;

/**
 *  The overflow menu items' font.
 */
@property (nullable, strong, nonatomic) UIFont *itemFont;

/**
 *  If set YES, the background will be dimmed while the menu is visible.
 */
@property (assign, nonatomic) BOOL shouldDimBackground;

/**
 *  Set the ratio according to which the overflow menu width should be calculated. Acceptable values are from 0.0 to 1.0. For example, if your screen width is 320.0 pts and 'widthMultiplier' is set to 0.5, the menu width will be 0.5 * 320.0 = 160 pts. Defaults to 0.4.
 */
@property (assign, nonatomic) CGFloat widthMultiplier;

/**
 *  The margins of the menu from the top, right and bottom edges. Defaults to 5 each.
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

/**
 *  The designated initializer.
 *
 *  @param target A UIViewController to show the overflow menu on.
 *  @param image  The overflow buttn's image.
 *  @param items  An array of ASJOverflowItems to show on the menu.
 *
 *  @return An instance of ASJOverflowButton.
 */
- (instancetype)initWithImage:(UIImage *)image items:(NSArray<ASJOverflowItem *> *)items NS_DESIGNATED_INITIALIZER;

/**
 *  Don't allow user to use "init".
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Don't allow user to use "initWithCoder:".
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)setItemTapBlock:(ItemTapBlock _Nullable)itemTapBlock;
- (void)setMenuRemoveBlock:(MenuRemoveBlock _Nullable)menuRemoveBlock;

@end

@interface ASJOverflowItem : NSObject

/**
 *  The overflow item's name.
 */
@property (copy, nonatomic) NSString *name;

/**
 *  The overflow item's image. Optional.
 */
@property (nullable, strong, nonatomic) UIImage *image;

/**
 *  A convenience constructor to create ASJOverflowItems.
 *
 *  @param name  The overflow item's name.
 *
 *  @return An instance of ASJOverflowItem.
 */
+ (ASJOverflowItem *)itemWithName:(NSString *)name;

/**
 *  A convenience constructor to create ASJOverflowItems.
 *
 *  @param name  The overflow item's name.
 *  @param image The overflow item's image. Optional.
 *
 *  @return An instance of ASJOverflowItem.
 */
+ (ASJOverflowItem *)itemWithName:(NSString *)name image:(nullable UIImage *)image;

@end

NS_ASSUME_NONNULL_END
