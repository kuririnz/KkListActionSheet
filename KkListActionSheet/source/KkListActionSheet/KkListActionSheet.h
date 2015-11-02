//
//  ListActionSheet.h
//  RealmSample
//
//  Created by keisuke kuribayashi on 2015/09/12.
//  Copyright (c) 2015年 keisuke kuribayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol KkListActionSheetDelegate <NSObject>

@required
// set row index
- (NSInteger)kkTableView:(UITableView *)tableView rowsInSection:(NSInteger)section;

// create row cell instance
- (UITableViewCell *)kktableView:(UITableView *)tableView currentIndex:(NSIndexPath *)indexPath;

@optional
// set the selected item Action in this tableview
- (void)kkTableView:(UITableView *)tableView selectIndex:(NSIndexPath *)indexPath;

// set each row height in this tableview
- (CGFloat)kkTableView:(UITableView *)tableView heightIndex:(NSIndexPath *)indexPath;
@end

@interface KkListActionSheet : UIView <UITableViewDelegate, UITableViewDataSource>

enum HEIGHTSTYLE {
    DEFAULT,
    MIDDLE,
    LOW
};

@property (nonatomic, assign) id<KkListActionSheetDelegate> delegate;

@property (nonatomic, weak) IBOutlet UITableView *kkTableView;

// Constructor
+ (instancetype) createInit:(UIViewController *) parent;
+ (instancetype) createInit:(UIViewController *) parent style:(int) styleIdx;

// private Method
- (void) setTitle:(NSString *)title;
- (void) setAttrTitle:(NSAttributedString *)attrTitle;
- (void) setHiddenTitle;
- (void) setHiddenScrollBar:(BOOL)value;
- (void) showHide;
@end
