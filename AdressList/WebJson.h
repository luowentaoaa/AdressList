//
//  WebJson.h
//  AdressList
//
//  Created by luowentao on 2020/3/9.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import <JSONModel.h>
#import "Status.h"
#import "Data.h"
NS_ASSUME_NONNULL_BEGIN

@interface WebJson :JSONModel

@property(strong, nonatomic)Status *status;
@property(strong, nonatomic)Data *data;

@end

NS_ASSUME_NONNULL_END
