//
//  ViewController.m
//  KkListActionSheetSample
//
//  Created by keisuke kuribayashi on 2015/09/30.
//  Copyright (c) 2015年 keisuke kuribayashi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController {
    KkListActionSheet *kkListActionSheet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    kkListActionSheet = [KkListActionSheet createInit:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonPushed:(UIButton *)sender {
    [kkListActionSheet kkListActionSheetAnimation];
}


#pragma mark - UITableViewDelegate,UITableViewDatasource
- (NSInteger)kkTableView:(UITableView *)tableView rowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)kktableView:(UITableView *)tableView currentIndex:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return cell;
}

- (void) kkTableView:(UITableView *)tableView selectIndex:(NSIndexPath *)indexPath {
    NSLog(@"%ld行目をタップ", (long)indexPath.row);
}

@end
