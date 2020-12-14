//
//  TestCollectionViewCell.m
//  colltionView 布局
//
//  Created by 闫响 on 2020/05/20.
//  Copyright © 2020 闫响. All rights reserved.
//

#import "collectionViewCell.h"

@interface collectionViewCell ()
//@property (nonatomic) UIImageView *contentImageView;

@end

@implementation collectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {

//        self.contentView.backgroundColor = [UIColor yellowColor];r
        [self.contentView addSubview:self.contentImageView];

        [self.contentView addSubview:self.selectButton];
    }

    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentImageView.layer.cornerRadius = 12.f;
    self.contentImageView.frame = self.bounds;

//    CGFloat width_scale = 80.0 /20;
    CGFloat contentImageWidth = self.contentImageView.bounds.size.width;
//    CGFloat width = contentImageWidth / width_scale;
    self.selectButton.frame = CGRectMake(contentImageWidth - 25, contentImageWidth - 20 -5, 20, 20);
}


- (UIButton *)selectButton{
    if (!_selectButton) {
        _selectButton = [[UIButton alloc]init];
        [_selectButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        _selectButton.enabled = YES;
    }
    return _selectButton;
}
#pragma mark - Getter
- (UIImageView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc]init];
        _contentImageView.layer.masksToBounds = YES;

    }
    return _contentImageView;
}

@end
