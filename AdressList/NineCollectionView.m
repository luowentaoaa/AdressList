//
//  NineCollectionView.m
//  AdressList
//
//  Created by luowentao on 2020/3/9.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "NineCollectionView.h"
#import <SDWebImage.h>
@interface NineCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionViewFlowLayout *Layout;

@end

@implementation NineCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withJson:(NSArray<WebJson *> *)array{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
           _array = array;
           _Layout = (UICollectionViewFlowLayout *)layout;
           self.pagingEnabled = NO;
           self.showsHorizontalScrollIndicator = NO;
           self.showsVerticalScrollIndicator = NO;
           self.bounces = NO;
           self.delegate = self;
           self.dataSource = self;
           [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
       }
       return self;
}

#pragma mark UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    UIImageView *imageV = nil;
    imageV = [[UIImageView alloc] init];
    NSURL *url = [NSURL URLWithString:_array[indexPath.row].data.url];
    [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"rand.jpg"]];
    
    CGRect imageFrame = imageV.frame;
    imageFrame.size = _Layout.itemSize;
    imageV.frame = imageFrame;
    [cell.contentView addSubview:imageV];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem", indexPath.section, indexPath.row);
}

@end
