#import "MTDActionSheetCell.h"


@implementation MTDActionSheetCell

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

        _accessoryLabel = [UILabel new];
        _accessoryLabel.backgroundColor = [UIColor clearColor];
        _accessoryLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView insertSubview:_accessoryLabel belowSubview:self.textLabel];

        _accessoryImageView = [UIImageView new];
        _accessoryImageView.clipsToBounds = YES;
        _accessoryImageView.contentMode = UIViewContentModeCenter;
        [self.contentView insertSubview:_accessoryImageView belowSubview:self.textLabel];

        _separatorView = [UIView new];
        [self.contentView addSubview:_separatorView];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat lineHeight = 1.f / [UIScreen mainScreen].scale;
    CGFloat accessoryPaddingRight = self.separatorInset.right ?: 10.f;
    self.separatorView.frame = CGRectMake(self.separatorInset.left, self.bounds.size.height - lineHeight, self.bounds.size.width - self.separatorInset.left - self.separatorInset.right, lineHeight);

    CGFloat accessoryLeft = 0.f;
    if (self.accessoryImageView.image != nil) {
        [self.accessoryImageView sizeToFit];
        self.accessoryImageView.frame = CGRectMake(self.contentView.bounds.size.width - self.accessoryImageView.frame.size.width - accessoryPaddingRight,
                                                   0.f,
                                                   self.accessoryImageView.frame.size.width,
                                                   self.contentView.bounds.size.height);
        accessoryLeft = self.accessoryImageView.frame.origin.x;
    } else {
        [self.accessoryLabel sizeToFit];
        self.accessoryLabel.frame = CGRectMake(self.contentView.bounds.size.width - self.accessoryLabel.frame.size.width - accessoryPaddingRight,
                                               0.f,
                                               self.accessoryLabel.frame.size.width,
                                               self.contentView.bounds.size.height);
        accessoryLeft = self.accessoryLabel.frame.origin.x;
    }

    if (self.textLabel.textAlignment == NSTextAlignmentLeft) {
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x,
                                          self.textLabel.frame.origin.y,
                                          accessoryLeft - self.textLabel.frame.origin.x - 5.f,
                                          self.textLabel.frame.size.height);
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewCell
////////////////////////////////////////////////////////////////////////

- (void)prepareForReuse {
    [super prepareForReuse];

    self.separatorView.hidden = NO;
}

@end



#pragma mark -



@implementation MTDActionSheetHeaderView

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.hidden = YES;

        _headerLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.numberOfLines = 0;
        _headerLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_headerLabel];

        _separatorView = [UIView new];
        [self.contentView addSubview:_separatorView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat lineHeight = 1.f / [UIScreen mainScreen].scale;
    self.separatorView.frame = CGRectMake(0.f, self.bounds.size.height - lineHeight, self.bounds.size.width, lineHeight);
}

@end
