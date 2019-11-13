//
//  MainCollectionViewCell.m
//  reddot
//
//  Created by DM_dsz on 2019/11/8.
//  Copyright © 2019 dsz. All rights reserved.
//

#import "MainCollectionViewCell.h"

@implementation MainCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setdataWithArr:(NSMutableArray *)arr{
    for (int i = 0; i< arr.count; i++) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.frame = self.bounds;
        UIButton * titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 41)];
        titleBtn.center = vc.view.center;
        titleBtn.tag = 12001+i;
        [titleBtn setTitle:[NSString stringWithFormat:@"%d",arc4random() % 100] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        titleBtn.alpha = 0.5;
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:32];
        [titleBtn sizeToFit];
        [vc.view addSubview:titleBtn];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self addSubview:vc.view];
    }
}
@end
