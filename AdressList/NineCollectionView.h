//
//  NineCollectionView.h
//  AdressList
//
//  Created by luowentao on 2020/3/9.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebJson.h"
NS_ASSUME_NONNULL_BEGIN

@interface NineCollectionView : UICollectionView

@property (nonatomic, strong) NSArray <WebJson *> *array;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withJson:(NSArray <WebJson *> *)array;

@end

NS_ASSUME_NONNULL_END
