//
//  AddUserController.h
//  AdressList
//
//  Created by luowentao on 2020/3/5.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddUserController, User;

NS_ASSUME_NONNULL_BEGIN

@protocol addViewDelegate <NSObject>

- (void)addViewControllerDidAddBtn:(AddUserController *)addViewController
                              user:(User *)user;

@end

@interface AddUserController : UIViewController

@property (nonatomic,weak)id<addViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
