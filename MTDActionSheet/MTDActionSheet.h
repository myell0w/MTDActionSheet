//
//  MTDActionSheet.h
//  Biscuit
//
//  Created by Matthias Tretter on 10.05.14.
//  Copyright (c) 2014 biscuitapp.co. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MTDActionSheet;


typedef void (^mtd_sheet_reload_block)(MTDActionSheet *sheet);
typedef void (^mtd_sheet_block)(MTDActionSheet *sheet, NSInteger buttonIndex);


@interface MTDAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *accessoryTitle;
@property (nonatomic, strong) UIImage *accessoryImage;
@property (nonatomic, copy) mtd_sheet_block block;

@property (nonatomic, assign) NSTextAlignment titleTextAlignment;
@property (nonatomic, assign) BOOL disabled;

+ (instancetype)actionWithTitle:(NSString *)title accessoryTitle:(NSString *)accessoryTitle titleTextAlignment:(NSTextAlignment)titleTextAlignment block:(mtd_sheet_block)block;
+ (instancetype)actionWithTitle:(NSString *)title accessoryImage:(UIImage *)accessoryImage titleTextAlignment:(NSTextAlignment)titleTextAlignment block:(mtd_sheet_block)block;

@end


@interface MTDActionSheet : UITableViewController

/******************************************
 @name Appearance
 ******************************************/

+ (void)setRowHeight:(CGFloat)rowHeight;
+ (void)setTitleFont:(UIFont *)titleFont;
+ (void)setButtonTitleFont:(UIFont *)buttonTitleFont;
+ (void)setButtonAccessoryFont:(UIFont *)accessoryFont;
+ (void)setBackgroundColor:(UIColor *)backgroundColor;
+ (void)setSeparatorColor:(UIColor *)separatorColor;
+ (void)setTitleColor:(UIColor *)titleColor;
+ (void)setTintColor:(UIColor *)tintColor;
+ (void)setDestructiveTintColor:(UIColor *)destructiveTintColor;
+ (void)setDisabledTintColor:(UIColor *)disabledTintColor;
+ (void)setAccessoryTintColor:(UIColor *)accessoryTintColor;
+ (void)setSelectionColor:(UIColor *)selectionColor;
+ (void)setSeparatorInsets:(UIEdgeInsets)separatorInsets;

/******************************************
 @name Properties
 ******************************************/

@property (nonatomic, readonly) NSUInteger buttonCount;
@property (nonatomic, readonly, getter = isVisible) BOOL visible;
@property (nonatomic, copy) mtd_sheet_block destroyBlock;

/******************************************
 @name Customization
 ******************************************/

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *buttonTitleFont;
@property (nonatomic, strong) UIFont *buttonAccessoryFont;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *destructiveTintColor;
@property (nonatomic, strong) UIColor *disabledTintColor;
@property (nonatomic, strong) UIColor *accessoryTintColor;
@property (nonatomic, strong) UIColor *selectionColor;

@property (nonatomic, assign) UIEdgeInsets separatorInsets;

/******************************************
 @name Initialization
 ******************************************/

- (instancetype)initWithTitle:(NSString *)title;

/******************************************
 @name Configuring Buttons
 ******************************************/

- (void)addButtonWithAction:(MTDAction *)action;
- (void)addButtonWithTitle:(NSString *)title block:(mtd_sheet_block)block;
- (void)addButtonWithTitle:(NSString *)title accessoryTitle:(NSString *)accessoryTitle block:(mtd_sheet_block)block;
- (void)addButtonWithTitle:(NSString *)title accessoryTitle:(NSString *)accessoryTitle titleTextAlignment:(NSTextAlignment)textAlignment block:(mtd_sheet_block)block;

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(mtd_sheet_block)block;
- (void)setDestructiveButtonWithTitle:(NSString *)title accessoryTitle:(NSString *)accessoryTitle block:(mtd_sheet_block)block;
- (void)setDestructiveButtonWithTitle:(NSString *)title accessoryTitle:(NSString *)accessoryTitle titleTextAlignment:(NSTextAlignment)textAlignment block:(mtd_sheet_block)block;

- (void)disableButtonWithTitle:(NSString *)title;
- (void)disableButtonAtIndex:(NSInteger)buttonIndex;

- (void)reloadWithTitle:(NSString *)newTitle reloadBlock:(mtd_sheet_reload_block)block;

/******************************************
 @name Presenting/Dismissing the ActionSheet
 ******************************************/

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)showFromBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

@end
