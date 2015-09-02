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
    CGFloat accessoryPaddingOutside = self.separatorInset.right ?: 10.f;
    self.separatorView.frame = CGRectMake(self.separatorInset.left, self.bounds.size.height - lineHeight, self.bounds.size.width - self.separatorInset.left - self.separatorInset.right, lineHeight);

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    BOOL isRTLLayout = ({
        UIUserInterfaceLayoutDirection layoutDirection = [UIApplication sharedApplication].userInterfaceLayoutDirection;
        if ([self.contentView respondsToSelector:@selector(semanticContentAttribute)]) {
            layoutDirection = [self.contentView.class userInterfaceLayoutDirectionForSemanticContentAttribute:self.contentView.semanticContentAttribute];
        }
        layoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
    });
#else
    BOOL isRTLLayout = NO;
#endif

    // check resulting text alignment based on user interface layout direction
    NSTextAlignment textAlignment = self.textLabel.textAlignment;
    if (textAlignment == NSTextAlignmentNatural) {
        textAlignment = isRTLLayout ? NSTextAlignmentRight : NSTextAlignmentLeft;
    }

    CGFloat accessoryWidth = 0.f;
    CGRectEdge accessoryEdge = isRTLLayout ? CGRectMinXEdge : CGRectMaxXEdge;
    CGRectEdge textEdge = isRTLLayout ? CGRectMaxXEdge : CGRectMinXEdge;
    if (self.accessoryImageView.image != nil) {
        [self.accessoryImageView sizeToFit];
        accessoryWidth = CGRectGetWidth(self.accessoryImageView.frame);
    } else {
        [self.accessoryLabel sizeToFit];
        accessoryWidth = CGRectGetWidth(self.accessoryLabel.frame);
    }

    CGRect contentRect = self.contentView.bounds, textRect, accessoryRect, dummy;
    CGRectDivide(contentRect, &dummy, &contentRect, accessoryPaddingOutside, accessoryEdge);
    CGRectDivide(contentRect, &dummy, &contentRect, self.separatorInset.left, textEdge);

    CGRectDivide(contentRect, &accessoryRect, &textRect, accessoryWidth, accessoryEdge);
    CGRectDivide(textRect, &dummy, &textRect, 5.f, accessoryEdge);

    self.accessoryImageView.frame = accessoryRect;
    self.accessoryLabel.frame = accessoryRect;
    if (textAlignment == NSTextAlignmentLeft || textAlignment == NSTextAlignmentRight) {
        self.textLabel.frame = textRect;
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
