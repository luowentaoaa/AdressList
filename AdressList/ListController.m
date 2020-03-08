//
//  ListController.m
//  AdressList
//
//  Created by luowentao on 2020/3/5.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "ListController.h"
#import "AddUserController.h"
#import "ModifyViewController.h"
#import "GetImageController.h"
#import "User.h"
#import "NSString+Sandbox.h"
#import "WebJson.h"
#import <AFNetworking.h>
#import <SDWebImage.h>

@interface ListController () <addViewDelegate,ModifityViewDelegate>

@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation ListController

- (NSMutableArray *)users{
    if (! _users) {
        _users = [User users];
    }
    return _users;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"caches:%@",caches);
    
   // [self.navigationController.navigationItem setTitle:self.userName];
    //self.tabBarController.navigationItem.title = self.userName;
    self.title = [NSString stringWithFormat:@"%@的通讯录",self.userName];
    
    //左边标题栏
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.leftBarButtonItem = item;
    //self.navigationItem.backBarButtonItem.title = @"返回";
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"返回通讯录";
    
    //右边标题栏
    UIBarButtonItem *ritem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser)];
    self.navigationItem.rightBarButtonItem = ritem;
    
    
//    [self getHttps:^(NSDictionary *data, NSError *error) {
//
//        NSError *err = nil;
//        WebJson *json = [[WebJson alloc]initWithDictionary:data error:&err];
//        NSLog(@"%@",json);
//        User *us = [[User alloc]init];
//        us.email = @"aa";
//        us.name = @"bb";
//        us.phone = @"cc";
//        us.json = json;
//        NSLog(@"%@",us);
//        NSString *jj = [us toJSONString];
//        NSLog(@"%@",jj);
//        User *uss = [[User alloc]initWithString:jj error:nil];
//        NSLog(@"------%@",uss);
//    }];
    
//    GetImageController *gic = [[GetImageController alloc]init];
//    [self.navigationController pushViewController:gic animated:YES];
  //  ModifyViewController  *modify = [[ModifyViewController alloc] init];
//    modify.user = self.users[indexPath.row];
//    modify.delegate = self;
   // [self.navigationController pushViewController:modify animated:YES];
    
}

#pragma mark - 注销按钮的点击事件
- (void) logOut{
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否注销" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");

    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - addViewDelegate

- (void)addViewControllerDidAddBtn:(AddUserController *)addViewController user:(User *)user{
    NSLog(@"添加 联系人 %@ ,%@ ,%@",user.name ,user.phone, user.phone);
    [self.users addObject:user];
    [self.tableView reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated{
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
#pragma mark - 存档
//    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self.users];
//    [userDefaults setObject:arrayData forKey:@"arrayKey"];
//    [userDefaults synchronize];
    static NSString *luo= @"luowentao";
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:self.users.count];
    for (User *us in self.users) {
        NSString *str = [us toJSONString];
        [mArr addObject:str];
    }
    NSString *path = [luo appendCache];
  //  NSLog(@"存%@",path);
    [mArr writeToFile: path atomically:YES];
}

#pragma mark - 修改联系人的代理

-(void)modeifyViewController{
    [self.tableView reloadData];
}
#pragma mark - 添加联系人按钮的单击事件

- (void)addUser{
    AddUserController *add = [[AddUserController alloc] init];
    add.delegate = self;
    [self.navigationController pushViewController:add animated:YES];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"%d %d",indexPath.section,indexPath.row);
    static NSString *ID = @"user_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    User *a = self.users[indexPath.row];
    
    cell.textLabel.text = a.name;
    cell.detailTextLabel.text = a.phone;
    cell.imageView.image = [UIImage imageNamed:@"rand.jpg"];
    
    
    if (a.json) {
        [cell.imageView sd_setImageWithURL:a.json.data.url placeholderImage:[UIImage imageNamed:@"rand.jpg"]];
    }
    
    return cell;
}

#pragma mark - 点击表格栏事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ModifyViewController  *modify = [[ModifyViewController alloc] init];
    modify.user = self.users[indexPath.row];
    modify.delegate = self;
    [self.navigationController pushViewController:modify animated:YES];
}

#pragma mark - table 进入编辑模式

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.users removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - AFNetworking 请求得到数据
- (void)getHttps:(void(^)(NSDictionary *data, NSError *error)) finishBlock{
    NSString *https = @"https://bing.ioliu.cn/v1/rand?w=320&h=240&type=json";
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:https parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       // NSLog(@"success--%@--%@",[responseObject class],responseObject);
        if (finishBlock) {
            finishBlock(responseObject ,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        if (finishBlock) {
            finishBlock(nil, error);
        }
    }];
}

@end
