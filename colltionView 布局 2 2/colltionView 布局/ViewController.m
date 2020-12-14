//
//  ViewController.m
//  colltionView 布局
//
//  Created by 闫响 on 2020/05/20.
//  Copyright © 2020 闫响. All rights reserved.
//

#import "ViewController.h"
#import "collectionViewCell.h"
#import "CollectionReusableFooterView.h"
#import "UICollectionViewLayoutCustom.h"
#import "CollectionReusableHeaderView.h"
#include <sys/param.h>
#include <sys/mount.h>

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,layoutDelete>
@property(nonatomic,strong)UICollectionView * imgCollectionView;

@property (nonatomic) NSMutableArray *dataSourceArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.dataSourceArr = [NSMutableArray array];


    for (NSInteger i = 1; i<11; i++) {
        [self.dataSourceArr addObject:@[[NSString stringWithFormat:@"mz%zd.jpg",i]]];
    }
    [self setupUI];

    [self sizesize];
}
#pragma mark - 计算存储大小
- (void)sizesize
{
    NSLog(@"存储---总空间=%llu----剩余空间=%llu",(([self getDiskTotalSpace] / 1024) / 1024/1024),(([self getDiskFreeSpace] / 1024) / 1024/1024));
}
- (uint64_t)getDiskTotalSpace

{

uint64_t totalSpace = 0;

__autoreleasing NSError *error = nil;

NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];

if (dictionary) {

NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];

totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];

NSLog(@"Memory Capacity of %llu MiB.", ((totalSpace/1024ll)/1024ll));

}

else {

NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);

}

return totalSpace;

}
- (uint64_t)getDiskFreeSpace

{

uint64_t totalFreeSpace = 0;

__autoreleasing NSError *error = nil;

NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];

if (dictionary) {

NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];

totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];

NSLog(@"Memory Capacity of %llu.", ((totalFreeSpace/1024ll)/1024ll));

}

else {

NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);

}

return totalFreeSpace;

}
#pragma mark - 代理
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (self.view.frame.size.width - 12.5*2 - 10*3)/4 - 1;
    if (indexPath.item == 0) {
        return CGSizeMake(itemWidth*2 + 10, itemWidth*2 + 10);
    }else{
        return CGSizeMake(itemWidth, itemWidth);
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSourceArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataSourceArr.count > indexPath.section) {
        NSArray *rowArray = self.dataSourceArr[indexPath.section];
        if (rowArray.count > indexPath.row) {
            NSString *imgstr = rowArray[indexPath.row];
            cell.contentImageView.image = [UIImage imageNamed:imgstr];
        }else{
            if (rowArray.count > 0) {
                NSString *imgstr = rowArray[0];
                cell.contentImageView.image = [UIImage imageNamed:imgstr];
            }
        }
    }
    return cell;
}

/** 头视图Size */
-(CGSize )layoutSizeForHeaderViewInSection:(NSInteger)section;{
    return CGSizeMake(self.view.bounds.size.width, 100);
}
/** 脚视图Size */
-(CGSize )layoutSizeForFooterViewInSection:(NSInteger)section;{
     return CGSizeMake(self.view.bounds.size.width, 100);
}
#pragma mark - UI
- (void)setupUI
{
    UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.bounds];
    image.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:image];

    UICollectionViewLayoutCustom *layout = [[UICollectionViewLayoutCustom alloc] init];
    layout.margin = 10;
    layout.layoutDelegate = self;
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.minimumLineSpacing = 10;      //行间距
//    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(15, 12.5, 25, 12.5);// 设置分区的边距
//    layout.itemCount = 90;

    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    mainCollectionView.backgroundColor = [UIColor clearColor];
    [mainCollectionView registerClass:[CollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionReusableHeaderView"];
    [mainCollectionView registerClass:[CollectionReusableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionReusableFooterView"];
    [mainCollectionView registerClass:[collectionViewCell class] forCellWithReuseIdentifier:@"cell"];



    [self.view addSubview:mainCollectionView];
    self.imgCollectionView = mainCollectionView;

    [self.imgCollectionView reloadData];
}
//点击单元格

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    collectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.selectButton.selected = !cell.selectButton.isSelected;
    NSLog(@"%ld区--%ld单元格",(long)indexPath.section,(long)indexPath.row);

    [collectionView reloadData];
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
         CollectionReusableHeaderView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionReusableHeaderView" forIndexPath:indexPath];
        header.titleLabel.text = [NSString stringWithFormat:@"%zd个相思，几处闲愁",indexPath.section];

        return header;
    }
    //如果底部视图
//    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
//    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
         CollectionReusableFooterView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionReusableFooterView" forIndexPath:indexPath];
        //添加头视图的内容
        //头视图添加view
        header.backgroundColor = [UIColor purpleColor];
        return header;
    }

    return nil;

}

@end
