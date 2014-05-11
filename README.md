# MTDActionSheet

A customizable UIActionSheet replacement for the iPad using blocks as callbacks.

In addition to the standard UIActionSheet functionality, fonts and colors of instances of MTDActionSheet can be easily customized and cells can show an additional accessory title.
Moreover it is possible to disable certain buttons which can be useful if you use the actionSheet to let the user choose from a list of values and you want to show but disable the current selected value.

## Sample Usage

```objective-c

// customize the default appearance of action sheets
+ (void)customizeActionSheets {
    [MTDActionSheet setTitleFont:[UIFont systemFontOfSize:13.f]];
    [MTDActionSheet setButtonTitleFont:[UIFont lightRedditFontOfSize:21.f]];
    [MTDActionSheet setButtonAccessoryFont:[UIFont systemFontOfSize:19.f]];
    [MTDActionSheet setBackgroundColor:[UIColor MTDNavigationBarInPopoverBarTintColor]];
    [MTDActionSheet setSeparatorColor:[UIColor MTDLineColor]];
    [MTDActionSheet setTitleColor:[UIColor MTDActionSheetTitleColor]];
    [MTDActionSheet setTintColor:[UIColor MTDTintColor]];
    [MTDActionSheet setDestructiveTintColor:[UIColor MTDDestructiveTintColor]];
    [MTDActionSheet setDisabledTintColor:[UIColor MTDActionSheetTitleColor]];
    [MTDActionSheet setAccessoryTintColor:[UIColor MTDActionSheetAccessoryColor]];
    [MTDActionSheet setSelectionColor:[UIColor MTDMenuItemCellSelectionColor]];
}

- (void)showActionSheetAtRect:(CGRect)rect {
    MTDActionSheet *actionSheet = [[MTDActionSheet alloc] initWithTitle:@"Submissions from"];

    for (RDTListingSubtype subtype = RDTFirstListingSubtype; subtype <= RDTLastListingSubtype; subtype++) {
        NSString *title = NSStringFromRDTListingSubtype(subtype);
        NSString *accessoryTitle = (subtype == self.listingSubtype) ? @"✓" : nil;

        [actionSheet addButtonWithTitle:title accessoryTitle:accessoryTitle block:^(MTDActionSheet *sheet, NSInteger buttonIndex) {
            self.listingSubtype = subtype;
            self.subreddit.preferredListingSubtypeValue = subtype;
            [self reloadVisibleItemsShowingHUD:YES];
        }];

        if (subtype == self.listingSubtype) {
            [actionSheet disableButtonWithTitle:title];
        }
    }

    // customize the title color of only this instance
    actionSheet.titleColor = [UIColor blueColor];
    [actionSheet showFromRect:rect inView:self.view animated:YES];
}

```

## Credits

MTDURLPreview was created by [Matthias Tretter](https://github.com/myell0w/) ([@myell0w](http://twitter.com/myell0w)) and extracted from the beautiful reddit client [*Biscuit for reddit*](http://biscuitapp.co).

![Biscuit for reddit](http://cdn.maikoapp.com/4u9e/5cu3e/200w.png)

## License

MTDURLPreview is available under the MIT license. See the LICENSE file for more info.
