//
//  MTDActionSheetCell.h
//  Biscuit
//
//  Created by Matthias Tretter on 10.05.14.
//  Copyright (c) 2014 biscuitapp.co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MTDActionSheetCell : UITableViewCell

@property (nonatomic, readonly) UIView *separatorView;
@property (nonatomic, readonly) UILabel *accessoryLabel;

@end


@interface MTDActionSheetHeaderView : UITableViewHeaderFooterView

@property (nonatomic, readonly) UILabel *headerLabel;
@property (nonatomic, readonly) UIView *separatorView;

@end