//
//  ModifyViewController.m
//  AdressList
//
//  Created by luowentao on 2020/3/5.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "ModifyViewController.h"
#import <Masonry/Masonry.h>
#import <AFNetworking.h>
#import "WebJson.h"
#import "User.h"
#import <SDWebImage.h>
@interface ModifyViewController ()
@property (nonatomic ,assign) BOOL isDoing;
@property (nonatomic, strong)WebJson *wb;
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看 / 编辑联系人";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(Modify:)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
       
    self.nameField = [[UITextField alloc]init];
    self.phoneField = [[UITextField alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.phoneLabel = [[UILabel alloc] init];
    self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.bImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setEnabled:NO];
    [self.bImage setEnabled:NO];
    
    self.saveButton.hidden = YES;
    self.nameLabel.text = @"姓名";
    self.phoneLabel.text = @"电话";
    self.nameField.placeholder = @"请输入姓名";
    self.phoneField.placeholder = @"请输入号码";
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.enabled = NO;
    self.phoneField.enabled = NO;
    self.phoneField.keyboardType = UIKeyboardTypePhonePad;
    if (self.user.json) {
        NSURL *url = [NSURL URLWithString:self.user.json.data.url];
        [self.bImage sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    }
    else{
        [self.bImage setBackgroundImage:[UIImage imageNamed:@"rand.jpg"] forState:UIControlStateNormal];
    }
    
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.phoneField];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.bImage];
    [self makeLayout];
    
    self.nameField.text = self.user.name;
    self.phoneField.text = self.user.phone;
    [self.nameField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.phoneField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bImage addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    
    self.wb = self.user.json;
    self.isDoing = NO;
    
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
- (void)textChange{
    self.saveButton.enabled = self.nameField.text.length > 0 && self.phoneField.text.length > 0;
}
- (void)saveClick{
    self.user.name = self.nameField.text;
    self.user.phone = self.phoneField.text;
    self.user.json = self.wb;
    if ([self.delegate respondsToSelector:@selector(modeifyViewController)]){
        [self.delegate modeifyViewController];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) Modify:(UIBarButtonItem *)sender{
    if (self.saveButton.hidden) {
        sender.title = @"取消";
        self.nameField.enabled = YES;
        self.phoneField.enabled = YES;
        self.saveButton.hidden = NO;
        self.bImage.enabled = YES;
        [self.phoneField becomeFirstResponder];
        [self textChange];
    }else{
        sender.title = @"编辑";
        self.nameField.enabled = NO;
        self.phoneField.enabled = NO;
        self.bImage.enabled = NO;
        self.saveButton.hidden = YES;
        self.nameField.text = self.user.name;
        self.phoneField.text = self.user.phone;
        if (self.user.json) {
            NSURL *url = [NSURL URLWithString:self.user.json.data.url];
            [self.bImage sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
        else{
            [self.bImage setBackgroundImage:[UIImage imageNamed:@"rand.jpg"] forState:UIControlStateNormal];
        }
        [self textChange];
        
    }

}


#pragma mark - 设计
-(void) makeLayout{
    NSNumber *height = [NSNumber numberWithDouble: self.view.frame.size.height *0.06];
    NSNumber *width = [NSNumber numberWithDouble:self.view.frame.size.width *0.1];
    int padding = 20;
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view).multipliedBy(1.1);
        make.centerY.equalTo(self.view).offset(100);
        make.height.equalTo(height);
        make.width.equalTo(width);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.greaterThanOrEqualTo(self.saveButton.mas_top).offset(- padding);
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
