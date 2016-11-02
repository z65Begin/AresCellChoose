//
//  ViewController.m
//  AresCellChoose
//
//  Created by Admin on 16/11/1.
//  Copyright © 2016年 AresBegin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIButton * deleteButton;

@property (nonatomic, assign) BOOL  isAllSelected;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:
                                              UIBarButtonItemStyleDone target:self action:@selector(exit)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton = button;
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    button.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
    [self.view addSubview:button];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [button addTarget:self action:@selector(deleteArray) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)exit{
    self.isAllSelected = NO;
    self.tableView.editing = !self.tableView.editing;
    NSString * string = self.tableView.editing?@"取消":@"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStyleDone target:self action:@selector(exit)];
    
    if (self.dataSource.count) {
        self.navigationItem.leftBarButtonItem = self.tableView.editing? [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)]:nil;
        CGFloat height = self.tableView.editing ? 40:0;
        [UIView animateWithDuration:0.3f animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, 40);
        }];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        [UIView animateWithDuration:0.3f animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40.0f);
        }];
    }
    

}

- (void)deleteArray{
    NSMutableArray * deleteArray = [NSMutableArray array];
    for (NSIndexPath * indexPath in self.tableView.indexPathsForSelectedRows) {
        [deleteArray addObject:self.dataSource[indexPath.row]];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.dataSource removeObjectsInArray:deleteArray];
        [self.tableView reloadData];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            if (!self.dataSource.count) {
                self.navigationItem.leftBarButtonItem = nil;
                self.navigationItem.rightBarButtonItem = nil;
                self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
            }
        }completion:^(BOOL finished) {
//            self.isAllSelected = NO;
        }];
    }];
    
    
}

- (void)selectAll{
    self.isAllSelected = !self.isAllSelected;

    for (int i = 0; i < self.dataSource.count; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0 ];
        if (self.isAllSelected) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        for (int i = 0; i < 25; i++) {
            NSString * nameString = [NSString stringWithFormat:@"列表-->%d",i];
            [_dataSource addObject:nameString];
        }
    }
    return _dataSource;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.allowsMultipleSelectionDuringEditing = YES;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // 单元格选中类型一定不能设置为UITableViewCellSelectionStyleNone 否则无法全选
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
    
    NSString * nameString = self.dataSource[indexPath.row];
    cell.textLabel.text = nameString;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0f;
}
#pragma mark 左划删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPa{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
