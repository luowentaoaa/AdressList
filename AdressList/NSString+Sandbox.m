//
//  NSString+Sandbox.m
//  缓存图片
//
//  Created by luowentao on 2020/3/8.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "NSString+Sandbox.h"



@implementation NSString (Sandbox)

- (instancetype)appendCache{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:[self lastPathComponent]];
}
- (instancetype)appendTemp{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[self lastPathComponent]];
}
- (instancetype)appendDocument{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:[self lastPathComponent]];
}
@end
