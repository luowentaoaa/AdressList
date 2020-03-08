//
//  GetImageController.m
//  AdressList
//
//  Created by luowentao on 2020/3/9.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "GetImageController.h"
#import <AFNetworking.h>
#import <SDWebImage.h>
#import "NineCollectionView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "User.h"
@interface GetImageController ()

@property (strong ,nonatomic) UIButton *cbutton;
@property (strong ,nonatomic) UIButton *qbutton;
@property (strong ,nonatomic) UIImageView *img;


@end

@implementation GetImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rand.jpg"]];
    self.cbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.qbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [self.view addSubview:self.img];
    [self.view addSubview:self.cbutton];
    [self.view addSubview:self.qbutton];
    
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
