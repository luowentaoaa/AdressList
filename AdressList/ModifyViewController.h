//
//  ModifyViewController.h
//  AdressList
//
//  Created by luowentao on 2020/3/5.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
NS_ASSUME_NONNULL_BEGIN

@protocol ModifityViewDelegate <NSObject>

@optional
- (void) modeifyViewController;

@end

@interface ModifyViewController : UIViewController

@property (strong ,nonatomic) UILabel *nameLabel;
@property (strong ,nonatomic) UILabel *phoneLabel;
@property (strong ,nonatomic) UITextField *nameField;
@property (strong ,nonatomic) UITextField *phoneField;
@property (strong ,nonatomic) UIButton *saveButton;
@property (nonatomic ,strong) UIButton *bImage;
@property (strong ,nonatomic) User *user;
@property (nonatomic,weak) id<ModifityViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
