//
//  Data.m
//  AdressList
//
//  Created by luowentao on 2020/3/9.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "Data.h"

@implementation Data
+ (JSONKeyMapper *)keyMapper{
    return [JSONKeyMapper mapperForSnakeCase];
}
@end
