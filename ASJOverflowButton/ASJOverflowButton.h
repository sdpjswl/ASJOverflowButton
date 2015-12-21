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

@property (strong, nonatomic) UIColor *menuBackgroundColor;
@property (strong, nonatomic) UIColor *itemTextColor;
@property (strong, nonatomic) UIFont *itemFont;
@property (assign, nonatomic) BOOL shouldDimBackground;
@property (copy) ItemTapBlock itemTapBlock;

- (instancetype)initWithTarget:(UIViewController *)target image:(UIImage *)image items:(NSArray *)items;
- (void)setItemTapBlock:(ItemTapBlock)itemTapBlock;

@end

@interface ASJOverflowItem : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *imageName;

+ (ASJOverflowItem *)itemWithName:(NSString *)name imageName:(NSString *)imageName;

@end
