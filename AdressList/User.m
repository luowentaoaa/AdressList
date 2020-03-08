//
//  User.m
//  AdressList
//
//  Created by luowentao on 2020/3/5.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "User.h"
#import "NSString+Sandbox.h"
@implementation User

+ (NSMutableArray *)users{
    static NSString *str = @"luowentao";
   // NSString *path = [[NSBundle mainBundle]pathForResource:str ofType:@"plist"];
    NSString *path = [str appendCache];
    NSLog(@"path = %@",path);
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *Marr = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSString *us in arr) {
        User *uss = [[User alloc]initWithString:us error:nil];
        [Marr addObject:uss];
    }
    return Marr;
}

@end
