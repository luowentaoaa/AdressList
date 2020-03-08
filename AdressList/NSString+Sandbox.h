//
//  NSString+Sandbox.h
//  缓存图片
//
//  Created by luowentao on 2020/3/8.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Sandbox)

- (instancetype) appendCache;
- (instancetype) appendTemp;
- (instancetype) appendDocument;

@end

NS_ASSUME_NONNULL_END
