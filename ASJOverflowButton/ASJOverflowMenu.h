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

@import UIKit;

@class ASJOverflowItem;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ItemTapBlock)(ASJOverflowItem *item, NSInteger idx);
typedef void (^MenuRemoveBlock)();

@interface ASJOverflowMenu : UIView

@property (copy, nonatomic) NSArray *items;
@property (nullable, strong, nonatomic) UIColor *menuBackgroundColor;
@property (nullable, strong, nonatomic) UIColor *itemTextColor;
@property (nullable, strong, nonatomic) UIFont *itemFont;
@property (assign, nonatomic) BOOL shouldDimBackground;
@property (nullable, copy) ItemTapBlock itemTapBlock;
@property (nullable, copy) MenuRemoveBlock menuRemoveBlock;

- (void)setItemTapBlock:(ItemTapBlock _Nullable)itemTapBlock;
- (void)setMenuRemoveBlock:(MenuRemoveBlock _Nullable)menuRemoveBlock;

@end

NS_ASSUME_NONNULL_END
