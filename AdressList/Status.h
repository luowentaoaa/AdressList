//
//  Status.h
//  AdressList
//
//  Created by luowentao on 2020/3/9.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface Status : JSONModel

@property(nonatomic, assign) int code;
@property(nonatomic, copy) NSString<Optional> *message;

@end

NS_ASSUME_NONNULL_END
