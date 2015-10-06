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
- (NSInteger)kkTableView:(UITableView *)tableView rowsInSection:(NSInteger)section;
- (UITableViewCell *)kktableView:(UITableView *)tableView currentIndex:(NSIndexPath *)indexPath;

@optional
- (void)kkTableView:(UITableView *)tableView selectIndex:(NSIndexPath *)indexPath;

@end

@interface KkListActionSheet : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id<KkListActionSheetDelegate> delegate;

@property (nonatomic, weak) IBOutlet UITableView *kkTableView;

+(instancetype) createInit:(UIViewController *) parent;
-(void) setTitle:(NSString *)title;
-(void) kkListActionSheetAnimation;

@end
