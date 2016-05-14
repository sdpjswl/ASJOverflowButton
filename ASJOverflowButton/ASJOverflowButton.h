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

@import UIKit;

@class ASJOverflowItem;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ItemTapBlock)(ASJOverflowItem *item, NSInteger idx);

@interface ASJOverflowButton : UIBarButtonItem

@property (assign, nonatomic) BOOL shouldDimBackground;
@property (nullable, strong, nonatomic) UIColor *menuBackgroundColor;
@property (nullable, strong, nonatomic) UIColor *itemTextColor;
@property (nullable, strong, nonatomic) UIFont *itemFont;
@property (nullable, copy) ItemTapBlock itemTapBlock;

- (instancetype)initWithTarget:(UIViewController *)target image:(UIImage *)image items:(NSArray<ASJOverflowItem *> *)items;
- (void)setItemTapBlock:(ItemTapBlock _Nullable)itemTapBlock;

@end

@interface ASJOverflowItem : NSObject

@property (copy, nonatomic) NSString *name;
@property (nullable, strong, nonatomic) UIImage *image;

+ (ASJOverflowItem *)itemWithName:(NSString *)name image:(nullable UIImage *)image;

@end

NS_ASSUME_NONNULL_END
