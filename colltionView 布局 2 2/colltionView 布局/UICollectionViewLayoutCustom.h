//
//  UICollectionViewLayoutlllll.h
//  colltionView 布局
//
//  Created by 刘浩宇 on 2020/5/21.
//  Copyright © 2020 闫响. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol layoutDelete <NSObject>

/** 头视图Size */
-(CGSize )layoutSizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
-(CGSize )layoutSizeForFooterViewInSection:(NSInteger)section;

@end

@interface UICollectionViewLayoutCustom : UICollectionViewFlowLayout
{
    //这个数组就是我们自定义的布局配置数组
       NSMutableArray * _attributeAttay;

}
@property (nonatomic, assign)  NSInteger itemCount;
@property (nonatomic, assign) CGFloat margin;

@property (nonatomic) NSMutableArray *attributesArr;
@property (nonatomic) CGFloat SectionLastItemMinY;//计算contentSize
@property (nonatomic, weak) id<layoutDelete> layoutDelegate;
@end

NS_ASSUME_NONNULL_END
