//
//  ViewController.m
//  AdressList
//
//  Created by luowentao on 2020/3/5.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "LoginController.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "ListController.h"

#define kUsernameKey @"KUsernameKey"
#define kPasswordKey @"kPasswordKey"
#define kremPasswordKey @"kremPasswordKey"
#define kAutoLoginKey @"kAutoLoginKey"

@interface LoginController ()
//账号label
@property (strong ,nonatomic) UILabel *accountLabel;
//密码label
@property (strong, nonatomic) UILabel *passwordLabel;
//账号输入框
@property (strong, nonatomic) UITextField *accountField;
//密码输入框
@property (strong, nonatomic) UITextField *passwordField;
//记住密码
@property (strong, nonatomic) UISwitch *remPassword;
//自动登录
@property (strong, nonatomic) UISwitch *autoLogin;
//记住密码label
@property (strong ,nonatomic) UILabel *remPasswordLabel;
//自动登录label
@property (strong, nonatomic) UILabel *autoLoginLabel;
//登录按钮
@property (strong, nonatomic) UIButton *login;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.view.backgroundColor = [UIColor redColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"通讯录";
    
    self.accountField = [[UITextField alloc]init];
    self.accountLabel = [[UILabel alloc]init];
    self.passwordField = [[UITextField alloc]init];
    self.passwordLabel = [[UILabel alloc] init];
    self.remPassword = [[UISwitch alloc] init];
    self.autoLogin = [[UISwitch alloc]init];
    self.login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.remPasswordLabel = [[UILabel alloc] init];
    self.autoLoginLabel = [[UILabel alloc] init];
    
    self.accountLabel.text = @"账号:";
    self.passwordLabel.text = @"密码:";
    self.remPasswordLabel.text = @"记住密码";
    self.autoLoginLabel.text = @"自动登录";
    [self.login setTitle:@"登录" forState:UIControlStateNormal];
    [self.login setEnabled:NO];
    
    
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.accountField];
    [self.view addSubview:self.passwordLabel];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.remPassword];
    [self.view addSubview:self.autoLogin];
    [self.view addSubview:self.remPasswordLabel];
    [self.view addSubview:self.autoLoginLabel];
    [self.view addSubview:self.login];
    
    self.accountField.placeholder = @"请输入用户名";
    self.passwordField.placeholder = @"请输入密码";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.remPassword.on = [ud boolForKey:kremPasswordKey];
    self.autoLogin.on = [ud boolForKey:kAutoLoginKey];
    
    [self makeLayout];
    
#pragma mark - 监听
    //1.通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //2.注册监听
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.accountField];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.passwordField];
    
    // 登录框点击监听
    [self.login addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    self.accountField.text = [ud objectForKey:kUsernameKey];
    
    // UIswitch监听
    [self.remPassword addTarget:self action:@selector(remPwdChange:) forControlEvents:UIControlEventValueChanged];
    if (self.remPassword.isOn) {
        self.passwordField.text = [ud objectForKey:kPasswordKey]; //从用户数据中读取
    }
    
    [self.autoLogin addTarget:self action:@selector(autoLoginChange:) forControlEvents:UIControlEventValueChanged];
    
    if (self.autoLogin.isOn) {
        [self loginClick:nil];
    }
    [self textChange];
}



- (void) remPwdChange:(id)sender
{
    // 1.判断是否记住密码
    if (self.remPassword.isOn == NO) {
        // 2.如果取消记住密码取消自动登录
        [self.autoLogin setOn:NO animated:YES];
    }
}
- (void)autoLoginChange:(id)sender
{
    // 1.判断是否自动登录
    if (self.autoLogin.isOn) {
        // 2.如果自动登录就记住密码
//        self.remPwdSwitch.on = YES;
        [self.remPassword setOn:YES animated:YES];
    }
}


- (void)textChange{
    self.login.enabled = self.accountField.text.length > 0 && self.passwordField.text.length >0;
}

- (void)loginClick:(id) sender{
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    [self.view addSubview:hud];
    hud.label.text = @"加载中...";
    [hud showAnimated:YES];
   // NSLog(@"%@ %@",self.accountField.text,self.passwordField.text);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if ( ([self.accountField.text isEqualToString:@"1"] )
            &&([self.passwordField.text isEqualToString:@"1"]) ){
            
             [hud hideAnimated:YES];
             ListController *listCt = [[ListController alloc]init];
             listCt.userName = self.accountField.text;
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
#pragma mark - 保存记住密码
            [ud setBool:self.remPassword.isOn forKey:kremPasswordKey];
            [ud setBool:self.autoLogin.isOn forKey:kAutoLoginKey];
            [ud setObject:self.accountField.text forKey:kUsernameKey];
            [ud setObject:self.passwordField.text forKey:kPasswordKey];
            [ud synchronize];
            
            
             [self.navigationController pushViewController:listCt animated:YES];
            
        }else{
                hud.label.text = @"密码或者账号不正确";
                [hud showAnimated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
           });
        }
    });
    
}

-(void)makeLayout{
        int totalHeight = self.view.frame.size.height;
        NSNumber *heightNum = @40;
        NSNumber *widthLabelNum = @50;
        int padding = 50;
        double padding2 = totalHeight*0.01;
        
    #pragma mark - 布局
        [self.login mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.height.equalTo(heightNum);
            make.width.equalTo(widthLabelNum);
        }];
        
       // self.login.backgroundColor = [UIColor redColor];
        [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(heightNum);
            make.width.equalTo(widthLabelNum);
    //        make.centerX.equalTo(@100);
    //        make.centerY.equalTo(@100);
            make.left.equalTo(self.view.mas_left).offset(padding);
            make.bottom.greaterThanOrEqualTo(self.passwordLabel.mas_top).offset(- padding2);
        }];
        [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(self.accountLabel);
            make.width.equalTo(self.accountLabel);
            make.left.equalTo(self.accountLabel);
            make.bottom.greaterThanOrEqualTo(self.remPasswordLabel.mas_top).offset(- padding2);;
        }];
        [self.accountField mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(heightNum);
            make.right.equalTo(self.view.mas_right).offset(-padding);
            make.bottom.greaterThanOrEqualTo(self.passwordLabel.mas_top).offset(- padding2);
            make.left.equalTo(self.accountLabel.mas_right).offset(20);
        }];
        self.accountField.borderStyle = UITextBorderStyleRoundedRect;
        [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(heightNum);
            make.right.equalTo(self.view.mas_right).offset(-padding);
            make.bottom.greaterThanOrEqualTo(self.remPasswordLabel.mas_top).offset(- padding2);;
            make.left.equalTo(self.passwordLabel.mas_right).offset(20);
        }];
        self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordField.secureTextEntry = YES;
        
        [self.remPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(heightNum);
            make.bottom.greaterThanOrEqualTo(self.login.mas_top);
            make.left.equalTo(self.accountLabel.mas_left);
            make.right.lessThanOrEqualTo(self.remPassword.mas_left);
        }];
        
        [self.remPassword mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(heightNum);
            make.bottom.greaterThanOrEqualTo(self.login.mas_top);
            make.right.lessThanOrEqualTo(self.autoLogin.mas_left);
            make.left.equalTo(self.remPasswordLabel.mas_right).offset(20);
        }];
        [self.autoLoginLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(heightNum);
            make.bottom.greaterThanOrEqualTo(self.login.mas_top);
            make.left.greaterThanOrEqualTo(self.remPassword.mas_right);
            make.right.lessThanOrEqualTo(self.autoLogin.mas_left).offset(-20);
        }];
        [self.autoLogin mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(heightNum);
            make.bottom.greaterThanOrEqualTo(self.login.mas_top);
            make.right.lessThanOrEqualTo(self.passwordField.mas_right);
        }];
}

@end
