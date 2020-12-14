//
//  UICollectionViewLayoutlllll.m
//  colltionView 布局
//
//  Created by 刘浩宇 on 2020/5/21.
//  Copyright © 2020 闫响. All rights reserved.
//

#import "UICollectionViewLayoutCustom.h"

@implementation UICollectionViewLayoutCustom

- (NSMutableArray *)attributesArr{
    if (!_attributesArr) {
        _attributesArr = [NSMutableArray array];
    }
    return _attributesArr;
}


-(void)prepareLayout {
    [self.attributesArr removeAllObjects];
    [super prepareLayout];
    self.SectionLastItemMinY = 0;
    NSInteger sectionCount =  [self.collectionView numberOfSections];
    for (int section = 0; section<sectionCount; section++) {
        if ([self.layoutDelegate respondsToSelector:@selector(layoutSizeForHeaderViewInSection:)]) {
            UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            self.SectionLastItemMinY = CGRectGetMaxY(headerAttrs.frame);
            [self.attributesArr addObject:headerAttrs];
        }
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < rowCount; row++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexpath];
            if (row == rowCount - 1) {
                if (row < 5) {
                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:section];
                    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexpath];
                    self.SectionLastItemMinY = CGRectGetMinY(attributes.frame) + CGRectGetHeight(attributes.frame) + self.sectionInset.bottom;
                }else{
                    self.SectionLastItemMinY = CGRectGetMinY(attributes.frame) + CGRectGetHeight(attributes.frame) + self.sectionInset.bottom;
                }
            }
            [self.attributesArr addObject:attributes];
        }
        if ([self.layoutDelegate respondsToSelector:@selector(layoutSizeForFooterViewInSection:)]) {
            UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            self.SectionLastItemMinY = CGRectGetMaxY(headerAttrs.frame);
            [self.attributesArr addObject:headerAttrs];
        }
    }
}

- (CGSize)collectionViewContentSize{
    UICollectionViewLayoutAttributes *attributes =  self.attributesArr.lastObject;
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), CGRectGetMaxY(attributes.frame));
    //    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
}


/** 返回indexPath位置头和脚视图对应的布局属性*/
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewLayoutAttributes *attri;

    if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {

        //头视图
        attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        if ([self.layoutDelegate respondsToSelector:@selector(layoutSizeForHeaderViewInSection:)]) {
            CGSize size= [self.layoutDelegate layoutSizeForHeaderViewInSection:indexPath.section];
            attri.frame = CGRectMake(0, self.SectionLastItemMinY, size.width, size.height);
        }


    }else {
        //脚视图
        attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        if ([self.layoutDelegate respondsToSelector:@selector(layoutSizeForFooterViewInSection:)]) {
            CGSize size= [self.layoutDelegate layoutSizeForFooterViewInSection:indexPath.section];
            attri.frame = CGRectMake(0, self.SectionLastItemMinY, size.width, size.height);
        }

    }

    return attri;

}
////设置所有cell的布局属性
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{

    //    return attributes;
    return self.attributesArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat largeItemWidth,largeItemHeight,smallItemWidth,smallItemHeight;
    largeItemWidth = largeItemHeight = (self.collectionView.frame.size.width-self.margin - self.sectionInset.left - self.sectionInset.right)/4.0*2;
    smallItemWidth = smallItemHeight = (largeItemWidth-self.margin)/2.0;
    CGFloat height = 0;
    CGFloat x = self.sectionInset.left;
    CGFloat y = self.sectionInset.top;
    if (indexPath.item == 0) {
        width = largeItemWidth;
        height = largeItemHeight;
        y += self.SectionLastItemMinY;
    }else if(indexPath.item <5) {
        width = smallItemWidth;
        height = smallItemHeight;
        CGFloat baseX = largeItemWidth +self.margin;
        x += baseX  + (width+self.margin) * ((indexPath.item-1) %2);
        y += ((indexPath.row -1)/2) * (height + self.margin*((indexPath.item-1) /2)) + self.SectionLastItemMinY;
    }else{
        width = smallItemWidth;
        height = smallItemHeight;
        CGFloat baseX = 0;
        x += baseX  + (width + self.margin)* ((indexPath.item-5) %4) ;
        y += largeItemHeight +self.margin + ((indexPath.row -5)/4) * (height + self.margin) + self.SectionLastItemMinY;
    }
    attributes.frame = CGRectMake( x, y, width, height);
    return attributes;
}
@end

