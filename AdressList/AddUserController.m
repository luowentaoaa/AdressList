//
//  AddUserController.m
//  AdressList
//
//  Created by luowentao on 2020/3/5.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "AddUserController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage.h>
#import <AFNetworking.h>
#import "User.h"
@interface AddUserController ()

// 名字label
@property (nonatomic ,strong) UILabel *nameLabel;
// 电话label
@property (nonatomic ,strong) UILabel *phoneLabel;
//名字UITextField
@property (nonatomic ,strong) UITextField *nameField;
//电话UITextField
@property (nonatomic ,strong) UITextField *phoneField;

@property (nonatomic ,strong) UIButton *addUser;

@property (nonatomic ,strong) UIButton *bImage;

@property (nonatomic, strong) WebJson *wb;

@property (nonatomic, assign) BOOL isDoing;

@end

@implementation AddUserController

-(void)viewDidAppear:(BOOL)animated{
    [self.nameField becomeFirstResponder];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加联系人";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.nameField = [[UITextField alloc]init];
    self.phoneField = [[UITextField alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.phoneLabel = [[UILabel alloc] init];
    self.addUser = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.bImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    
    [self.addUser setTitle:@"添加" forState:UIControlStateNormal];
    [self.addUser setEnabled:NO];
    self.nameLabel.text = @"姓名";
    self.phoneLabel.text = @"电话";
    self.nameField.placeholder = @"请输入姓名";
    self.phoneField.placeholder = @"请输入号码";
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneField.keyboardType = UIKeyboardTypePhonePad;
    [self.bImage setBackgroundImage:[UIImage imageNamed:@"rand.jpg"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.phoneField];
    [self.view addSubview:self.addUser];
    [self.view addSubview:self.bImage];
    [self makeLayout];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    [self.nameField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.phoneField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    [self.addUser addTarget:self action:@selector(addUserClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bImage addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    self.wb = nil;
    self.isDoing = NO;
}
- (void)textChange{
    self.addUser.enabled = self.nameField.text.length > 0 && self.phoneField.text.length > 0;
}
-(void)changeImage{
    if (self.isDoing) {
        NSLog(@"正在努力加载图片");
        return;
    }
    self.isDoing = YES;
    [self getHttps:^(NSDictionary *data, NSError *error) {
        NSError *err = nil;
        WebJson *json = [[WebJson alloc]initWithDictionary:data error:&err];
        NSLog(@"%@",json);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.wb = json;
            NSURL *url = [NSURL URLWithString:json.data.url];
            [self.bImage sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            self.isDoing = NO;
        }) ;
    }];
}
- (void)addUserClick{
    [self.navigationController popViewControllerAnimated:YES];
    
    User *us = [[User alloc] init];
    us.name = self.nameField.text;
    us.phone = self.phoneField.text;
    us.json = self.wb;
    if ([self.delegate respondsToSelector:@selector(addViewControllerDidAddBtn:user:)]){
        [self.delegate addViewControllerDidAddBtn:self user:us];
    }
    
}




#pragma mark - 设计
-(void) makeLayout{
    NSNumber *height = [NSNumber numberWithDouble: self.view.frame.size.height *0.06];
    NSNumber *width = [NSNumber numberWithDouble:self.view.frame.size.width *0.1];
    int padding = 20;
    
    [self.addUser mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view).multipliedBy(1.1);
        make.centerY.equalTo(self.view).offset(100);
        make.height.equalTo(height);
        make.width.equalTo(width);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.greaterThanOrEqualTo(self.addUser.mas_top).offset(- padding);
        make.left.equalTo(self.view.mas_left).offset(padding);
        make.height.equalTo(height);
        make.width.equalTo(width);
    }];
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.phoneLabel);
        make.left.equalTo(self.phoneLabel.mas_right).offset(padding);
        make.right.equalTo(self.view.mas_right).offset( - padding);
        make.height.equalTo(self.phoneLabel);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.greaterThanOrEqualTo(self.phoneLabel.mas_top).offset(- padding);
        make.left.equalTo(self.phoneLabel);
        make.height.equalTo(self.phoneLabel);
    }];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.nameLabel);
        make.left.equalTo(self.phoneField);
        make.right.equalTo(self.phoneField);
        make.height.equalTo(self.phoneLabel);
    }];
    
    [self.bImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.nameField.mas_top).offset(-10);
        make.height.equalTo(@240);
        make.width.equalTo(@320);
    }];
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
