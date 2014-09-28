#import "MTDActionSheet.h"
#import "MTDActionSheetCell.h"


#define kMTDRowHeight           44.f
#define kMTDHeaderPaddingY      18.f


static UIFont *mtd_titleFont = nil;
static UIFont *mtd_buttonTitleFont = nil;
static UIFont *mtd_buttonAccessoryFont = nil;
static UIColor *mtd_backgroundColor = nil;
static UIColor *mtd_separatorColor = nil;
static UIColor *mtd_titleColor = nil;
static UIColor *mtd_tintColor = nil;
static UIColor *mtd_destructiveTintColor = nil;
static UIColor *mtd_disabledTintColor = nil;
static UIColor *mtd_accessoryTintColor = nil;
static UIColor *mtd_selectionColor = nil;
static UIEdgeInsets mtd_separatorInsets = (UIEdgeInsets){0.f,0.f,0.f,0.f};


////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - MTDAction
#pragma mark -
////////////////////////////////////////////////////////////////////////


@interface MTDAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *accessoryTitle;
@property (nonatomic, copy) mtd_sheet_block block;

@property (nonatomic, assign) NSTextAlignment titleTextAlignment;
@property (nonatomic, assign) BOOL disabled;

@end

@implementation MTDAction

+ (instancetype)actionWithTitle:(NSString *)title {
    return [self actionWithTitle:title accessoryTitle:nil titleTextAlignment:NSTextAlignmentCenter block:nil];
}

+ (instancetype)actionWithTitle:(NSString *)title accessoryTitle:(NSString *)accessoryTitle titleTextAlignment:(NSTextAlignment)titleTextAlignment block:(mtd_sheet_block)block {
    MTDAction *action = [MTDAction new];

    action.title = title;
    action.accessoryTitle = accessoryTitle;
    action.block = block;
    action.titleTextAlignment = titleTextAlignment;

    return action;
}

- (NSUInteger)hash {
    return self.title.hash;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[MTDAction class]]) {
        return NO;
    }

    return [self.title isEqualToString:[object title]];
}

@end

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - MTDActionSheet
#pragma mark -
////////////////////////////////////////////////////////////////////////


@interface MTDActionSheet () <UIPopoverControllerDelegate>

@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, strong) UIPopoverController *sheetPopover;

@property (nonatomic, assign) NSInteger clickedButtonIndex;
@property (nonatomic, assign) NSInteger destructiveButtonIndex;

@end


@implementation MTDActionSheet

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

+ (void)initialize {
    if (self == [MTDActionSheet class]) {
        mtd_titleFont = [UIFont systemFontOfSize:13.f];
        mtd_buttonTitleFont = [UIFont systemFontOfSize:21.f];
        mtd_buttonAccessoryFont = [UIFont systemFontOfSize:21.f];

        mtd_backgroundColor = [UIColor whiteColor];
        mtd_separatorColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        mtd_titleColor = [UIColor lightGrayColor];
        mtd_tintColor = [UIColor colorWithRed:0.f green:122.f/255.f blue:1.f alpha:1.f];
        mtd_destructiveTintColor = [UIColor redColor];
        mtd_accessoryTintColor = [UIColor lightGrayColor];
        mtd_disabledTintColor = [UIColor lightGrayColor];

        mtd_separatorInsets = UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f);
    }
}

- (instancetype)initWithTitle:(NSString *)title {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        self.title = title;

        _actions = [NSMutableArray new];
        _destructiveButtonIndex = NSNotFound;
        _clickedButtonIndex = NSNotFound;

        // Apply default values
        _titleFont = mtd_titleFont;
        _buttonTitleFont = mtd_buttonTitleFont;
        _buttonAccessoryFont = mtd_buttonAccessoryFont;

        _backgroundColor = mtd_backgroundColor;
        _separatorColor = mtd_separatorColor;
        _titleColor = mtd_titleColor;
        _tintColor = mtd_tintColor;
        _destructiveTintColor = mtd_destructiveTintColor;
        _disabledTintColor = mtd_disabledTintColor;
        _accessoryTintColor = mtd_accessoryTintColor;
        _selectionColor = mtd_selectionColor;

        _separatorInsets = mtd_separatorInsets;
    }

    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self initWithTitle:nil];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Class Methods
////////////////////////////////////////////////////////////////////////

+ (void)setTitleFont:(UIFont *)titleFont {
    mtd_titleFont = titleFont;
}

+ (void)setButtonTitleFont:(UIFont *)buttonTitleFont {
    mtd_buttonTitleFont = buttonTitleFont;
}

+ (void)setButtonAccessoryFont:(UIFont *)accessoryFont {
    mtd_buttonAccessoryFont = accessoryFont;
}

+ (void)setBackgroundColor:(UIColor *)backgroundColor {
    mtd_backgroundColor = backgroundColor;
}

+ (void)setSeparatorColor:(UIColor *)separatorColor {
    mtd_separatorColor = separatorColor;
}

+ (void)setTitleColor:(UIColor *)titleColor {
    mtd_titleColor = titleColor;
}

+ (void)setTintColor:(UIColor *)tintColor {
    mtd_tintColor = tintColor;
}

+ (void)setDestructiveTintColor:(UIColor *)destructiveTintColor {
    mtd_destructiveTintColor = destructiveTintColor;
}

+ (void)setDisabledTintColor:(UIColor *)disabledTintColor {
    mtd_disabledTintColor = disabledTintColor;
}

+ (void)setAccessoryTintColor:(UIColor *)accessoryTintColor {
    mtd_accessoryTintColor = accessoryTintColor;
}

+ (void)setSelectionColor:(UIColor *)selectionColor {
    mtd_selectionColor = selectionColor;
}

+ (void)setSeparatorInsets:(UIEdgeInsets)separatorInsets {
    mtd_separatorInsets = separatorInsets;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];

    [self reloadTitleHeight];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = self.separatorInsets;
    self.tableView.rowHeight = kMTDRowHeight;
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [UIView new];

    [self.tableView registerClass:[MTDActionSheetCell class] forCellReuseIdentifier:NSStringFromClass([MTDActionSheetCell class])];
    [self.tableView registerClass:[MTDActionSheetHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MTDActionSheetHeaderView class])];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
        [self.tableView flashScrollIndicators];
    }
}

- (CGSize)preferredContentSize {
    return CGSizeMake(272.f, self.tableView.contentSize.height);
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MTDActionSheet
////////////////////////////////////////////////////////////////////////

- (BOOL)isVisible {
    return self.sheetPopover.popoverVisible;
}

- (void)addButtonWithTitle:(NSString *)title block:(mtd_sheet_block)block {
    [self addButtonWithTitle:title accessoryTitle:nil block:block];
}

- (void)addButtonWithTitle:(NSString *)title accessoryTitle:(NSString *)accessoryTitle block:(mtd_sheet_block)block {
    [self addButtonWithTitle:title accessoryTitle:accessoryTitle titleTextAlignment:NSTextAlignmentCenter block:block];
}

- (void)addButtonWithTitle:(NSString *)title accessoryTitle:(NSString *)accessoryTitle titleTextAlignment:(NSTextAlignment)textAlignment block:(mtd_sheet_block)block {
    NSParameterAssert(title != nil);

    MTDAction *action = [MTDAction actionWithTitle:title accessoryTitle:accessoryTitle titleTextAlignment:textAlignment block:block];
    [self.actions addObject:action];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(mtd_sheet_block)block {
    [self setDestructiveButtonWithTitle:title accessoryTitle:nil block:block];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title accessoryTitle:(NSString *)accessoryTitle block:(mtd_sheet_block)block {
    [self setDestructiveButtonWithTitle:title accessoryTitle:accessoryTitle titleTextAlignment:NSTextAlignmentCenter block:block];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title accessoryTitle:(NSString *)accessoryTitle titleTextAlignment:(NSTextAlignment)textAlignment block:(mtd_sheet_block)block {
    NSParameterAssert(self.destructiveButtonIndex == NSNotFound); // assert that its only called once

    [self addButtonWithTitle:title accessoryTitle:accessoryTitle block:block];
    self.destructiveButtonIndex = self.actions.count - 1;
}

- (void)disableButtonWithTitle:(NSString *)title {
    NSInteger index = [self.actions indexOfObject:[MTDAction actionWithTitle:title]];
    [self disableButtonAtIndex:index];
}

- (void)disableButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != NSNotFound && buttonIndex < self.actions.count) {
        MTDAction *action = self.actions[buttonIndex];
        action.disabled = YES;
    }
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {
    [self setupPopoverController];

    [self.sheetPopover presentPopoverFromRect:rect inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:animated];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated {
    [self setupPopoverController];

    [self.sheetPopover presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:animated];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (buttonIndex >= 0 && buttonIndex < self.actions.count) {
        MTDAction *action = self.actions[buttonIndex];
        if (action.block != nil) {
            mtd_sheet_block block = [action.block copy];

            // prevent a possible second call of the action
            action.block = nil;
            block(self, buttonIndex);
        }
    }

    self.clickedButtonIndex = buttonIndex;
    [self.sheetPopover dismissPopoverAnimated:animated];
    [self popoverControllerDidDismissPopover:self.sheetPopover];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissWithClickedButtonIndex:NSNotFound animated:animated];
}

- (void)reloadWithTitle:(NSString *)newTitle reloadBlock:(mtd_sheet_reload_block)block {
    [self destroy];

    block(self);
    self.title = newTitle;
    [self reloadTitleHeight];

    [self.tableView reloadData];
    [self.sheetPopover setPopoverContentSize:self.preferredContentSize animated:YES];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource
////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTDActionSheetCell *cell = (MTDActionSheetCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MTDActionSheetCell class])];
    MTDAction *action = self.actions[indexPath.row];

    cell.textLabel.text = action.title;
    cell.accessoryLabel.text = action.accessoryTitle;

    if (indexPath.row == self.actions.count - 1) {
        cell.separatorView.hidden = YES;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.title;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MTDActionSheetHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MTDActionSheetHeaderView class])];

    headerView.headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];

    return headerView;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate
////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissWithClickedButtonIndex:indexPath.row animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MTDActionSheetCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MTDAction *action = self.actions[indexPath.row];

    if (action.disabled) {
        cell.textLabel.textColor = self.disabledTintColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.row == self.destructiveButtonIndex && self.destructiveTintColor != nil) {
        cell.textLabel.textColor = self.destructiveTintColor;
    } else {
        cell.textLabel.textColor = self.tintColor;
    }

    cell.textLabel.textAlignment = action.titleTextAlignment;
    cell.textLabel.font = self.buttonTitleFont;
    cell.accessoryLabel.font = self.buttonAccessoryFont;
    cell.accessoryLabel.textColor = self.accessoryTintColor;
    cell.separatorView.backgroundColor = self.separatorColor;

    // separate the destructive button by extending the separators to the edge
    if (indexPath.row == self.destructiveButtonIndex - 1 || indexPath.row == self.destructiveButtonIndex) {
        cell.separatorInset = UIEdgeInsetsZero;
    }

    if (self.selectionColor != nil) {
        UIView *selectedBackgroundView = [UIView new];
        selectedBackgroundView.backgroundColor = self.selectionColor;
        cell.selectedBackgroundView = selectedBackgroundView;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MTDAction *action = self.actions[indexPath.row];

    return action.disabled ? nil : indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(MTDActionSheetHeaderView *)view forSection:(NSInteger)section {
    view.contentView.backgroundColor = self.backgroundColor;
    view.backgroundView.backgroundColor = self.backgroundColor;
    view.headerLabel.font = self.titleFont;
    view.headerLabel.textColor = self.titleColor;
    view.separatorView.backgroundColor = self.separatorColor;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIPopoverControllerDelegate
////////////////////////////////////////////////////////////////////////

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.sheetPopover = nil;
    [self destroy];

    if (self.destroyBlock != nil) {
        self.destroyBlock(self, self.clickedButtonIndex);
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)setupPopoverController {
    [self.sheetPopover dismissPopoverAnimated:NO];

    self.sheetPopover = [[UIPopoverController alloc] initWithContentViewController:self];
    self.sheetPopover.backgroundColor = self.backgroundColor;
    self.sheetPopover.popoverContentSize = [self preferredContentSize];
    self.sheetPopover.delegate = self;
}

- (void)destroy {
    self.destructiveButtonIndex = NSNotFound;
    [self.actions removeAllObjects];
}

- (void)reloadTitleHeight {
    CGRect titleRect = [self.title boundingRectWithSize:CGSizeMake(self.preferredContentSize.width, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName : self.titleFont}
                                                context:nil];

    if (self.title == nil) {
        self.tableView.sectionHeaderHeight = 0;
    } else {
        self.tableView.sectionHeaderHeight = (CGFloat)ceil(CGRectGetHeight(titleRect)) + 2*kMTDHeaderPaddingY;
    }
}

@end
