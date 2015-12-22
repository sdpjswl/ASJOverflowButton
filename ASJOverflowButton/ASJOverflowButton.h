//
//  ASJOverflowButton.h
//  ASJOverflowButtonExample
//
//  Created by sudeep on 21/12/15.
//  Copyright © 2015 sudeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASJOverflowItem;

typedef void (^ItemTapBlock)(ASJOverflowItem *item, NSInteger idx);

@interface ASJOverflowButton : UIBarButtonItem

@property (assign, nonatomic) BOOL shouldDimBackground;
@property (strong, nonatomic) UIColor *menuBackgroundColor;
@property (strong, nonatomic) UIColor *itemTextColor;
@property (strong, nonatomic) UIFont *itemFont;
@property (copy) ItemTapBlock itemTapBlock;

- (instancetype)initWithTarget:(UIViewController *)target image:(UIImage *)image items:(NSArray *)items;
- (void)setItemTapBlock:(ItemTapBlock)itemTapBlock;

@end

@interface ASJOverflowItem : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;

+ (ASJOverflowItem *)itemWithName:(NSString *)name image:(UIImage *)image;

@end
