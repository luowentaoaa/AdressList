//
//  Data.h
//  AdressList
//
//  Created by luowentao on 2020/3/9.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface Data : JSONModel

@property(nonatomic, copy) NSString *enddate;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString<Optional> *bmiddlePic;
@property(nonatomic, copy) NSString<Optional> *originalPic;
@property(nonatomic, copy) NSString<Optional> *thumbnailPic;
@property(nonatomic, copy) NSString *copyright;


@end

NS_ASSUME_NONNULL_END
