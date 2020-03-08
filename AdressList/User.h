//
//  User.h
//  AdressList
//
//  Created by luowentao on 2020/3/5.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "WebJson.h"
NS_ASSUME_NONNULL_BEGIN

@interface User : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString<Optional> *email;
@property (nonatomic, copy) WebJson<Optional> *json;

+(NSArray *)users;

@end

NS_ASSUME_NONNULL_END
