//
//  CollectionReusableFooterView.m
//  colltionView 布局
//
//  Created by 刘浩宇 on 2020/5/21.
//  Copyright © 2020 闫响. All rights reserved.
//

#import "CollectionReusableFooterView.h"

@implementation CollectionReusableFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailButton];

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(19, self.bounds.size.height/2.0-7, 100, 14);
    self.detailButton.frame = CGRectMake(self.bounds.size.width - 20-50, 0, 50, self.bounds.size.height);
}

- (UIButton *)detailButton{
    if (!_detailButton) {
        _detailButton = [[UIButton alloc]init];
        _detailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_detailButton setTitle:@"全选" forState:UIControlStateNormal];
    }
    return _detailButton;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"尾部";
    }
    return _titleLabel;
}
@end
