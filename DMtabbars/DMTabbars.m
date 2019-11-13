//
//  DMTabbars.m
//  reddot
//
//  Created by DM_dsz on 2019/11/8.
//  Copyright © 2019 dsz. All rights reserved.
//

#import "DMTabbars.h"
#import "UIViewExt.h"
#import "UIColor+ColorHexString.h"
#import "MainCollectionViewCell.h"
static NSString * const reuseID  = @"DDMainChannelCell";

#define kScreenWidth self.bounds.size.width
#define kScreenHeight self.bounds.size.height

@interface DMTabbars()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) UIScrollView * navScrollView;
@property (nonatomic , strong) UIView * lineView;
@property (nonatomic, strong) UICollectionView *m_contentCollectionView;
@property float titleFontSize;
@property float titleSelFontSize;
@property NSString *titleColor;
@property NSString *titleSelColor;
@property NSString *themeColor;
@property float lineWidth;
@property float tabHeight;
@property float minTitleBtnWidth;
@property float minTitleBtnHeight;
@property float lineMargin;
@end

@implementation DMTabbars


- (instancetype)initWithFrame:(CGRect)frame
                     tabsType:(DMTabsType)tabsType
                    themeType:(themeType)themeType{
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.m_contentCollectionView];
        self.thmeType = themeType;
        self.tabsType = tabsType;
    }
    return self;
}

- (void)layoutSubviews{
    _titleFontSize = 15.0f;
    [self addSubview:self.navScrollView];
    self.m_contentCollectionView.top = self.navScrollView.bottom +10;
    [self.navScrollView addSubview:self.lineView];
    [self.m_contentCollectionView reloadData];
    [self setNavScrollviewButtonTitle:0];
}

-(void)setNavScrollviewButtonTitle:(NSInteger)index{
    for (UIView *view in _navScrollView.subviews) {
        if (view.tag != 1523) {
            [view removeFromSuperview];
        }
    }
    NSMutableArray * titleArr = [NSMutableArray array];
    titleArr = self.dNewNavArray;
    if (titleArr.count>0) {
        float currentRight = 0;

        for (int i = 0; i<titleArr.count; i++) {

            UIButton * titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(currentRight, 0, _minTitleBtnWidth, _tabHeight-_lineMargin)];
            titleBtn.tag = 12001+i;
            [titleBtn addTarget:self action:@selector(navScrollTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
            [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            [titleBtn setTitleColor:[UIColor colorWithHexString:_titleColor] forState:UIControlStateNormal];
            titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:_titleFontSize];
            [titleBtn sizeToFit];
            titleBtn.width =titleBtn.width>_minTitleBtnWidth?(titleBtn.width+10):_minTitleBtnWidth;
            titleBtn.height =_minTitleBtnHeight;
            if ( i == index ) {
                titleBtn.selected = YES;
                if (self.tabsType == DMTabs_main_ls || self.tabsType == DMTabs_main_fc) {
                    titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:_titleSelFontSize];
                }
                [titleBtn setTitleColor:[UIColor colorWithHexString:_titleSelColor] forState:UIControlStateNormal];
                titleBtn.alpha = 1;
                if (i == 0 ) {
                    _lineView.left = titleBtn.left+(titleBtn.width-_lineWidth)/2;
                    _lineView.top = titleBtn.bottom - _lineMargin;
                }else{
                    [UIView animateWithDuration:.25 animations:^{
                        _lineView.left = titleBtn.left+(titleBtn.width-_lineWidth)/2;
                        _lineView.top = titleBtn.bottom - _lineMargin;                } completion:^(BOOL finished) {
                            
                        }];
                }
               
               
            }else{
                titleBtn.selected = NO;
                titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:_titleFontSize];
            }
            currentRight = titleBtn.right;
            [_navScrollView addSubview:titleBtn];
        }
        [_navScrollView bringSubviewToFront:_lineView];
        _navScrollView.contentSize = CGSizeMake(currentRight, _tabHeight);
        if (_navScrollView.contentSize.width>[UIScreen mainScreen].bounds.size.width) {
            UIButton *btn = (UIButton *)[_navScrollView viewWithTag:12001+index];
            [self settleTitleButton:btn];
        }
    }
}


#pragma mark - 标题按钮和横线居中偏移
- (void)settleTitleButton:(UIButton *)button
{
    // 标题
    // 这个偏移量是相对于scrollview的content frame原点的相对对标
    CGFloat deltaX = button.center.x - (self.frame.size.width) / 2;
    // 设置偏移量，记住这段算法
    if (deltaX < 0)
    {
        // 最左边
        deltaX = 0;
    }
    CGFloat maxDeltaX = _navScrollView.contentSize.width - (self.frame.size.width);
    if (deltaX > maxDeltaX)
    {
        // 最右边不能超范围
        deltaX = maxDeltaX;
    }
    [_navScrollView setContentOffset:CGPointMake(deltaX, 0) animated:YES];
    
}
#pragma mark 一级导航按钮点击
/*
 上导航之前逻辑，分类互切的时候也请求分类接口，重新加载视图；
 */
-(void)navScrollTitleClicked:(UIButton *)sender{
    
    //点击上导航btn后，让bigCollectionView滚到对应位置。
    [_m_contentCollectionView setContentOffset:CGPointMake((sender.tag - 12001)*kScreenWidth, 0) animated:NO];
    // 重新调用一下滚定停止方法，让label的着色和下划线到正确的位置。
    [self scrollViewDidEndScrollingAnimation:self.m_contentCollectionView];

    
}

#pragma mark - UICollectionViewDataSource协议

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dNewNavArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    [cell setdataWithArr:_dNewNavArray];
    return cell;
}

#pragma mark - UICollectionViewDelegate协议
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (value < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    if (rightIndex >= _dNewNavArray.count) {  // 防止滑到最右，再滑，数组越界，从而崩溃
        rightIndex = _dNewNavArray.count - 1;
    }
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    // 点击label会调用此方法1次，会导致【scrollViewDidEndScrollingAnimation】方法中的动画失效，这时直接return。
    if (scaleLeft == 1 && scaleRight == 0) {
        //                return;
        
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.m_contentCollectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}
/** 手指滑动m_ContentCollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.m_contentCollectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
    
}

/** 手指点击smallScrollView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.navScrollView]) {
        return;
    }
    
    // 获得索引
    int index = scrollView.contentOffset.x / self.frame.size.width;
    if(index + 1 >= _dNewNavArray.count){
        index =(int)_dNewNavArray.count - 1;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNavScrollviewButtonTitle:index];
    });
    
        UIButton *sender = (UIButton*)[self viewWithTag:(index + 12001)];
        [sender setTitleColor:[UIColor colorWithHexString:_titleSelColor] forState:UIControlStateNormal];
        if (_navScrollView.contentSize.width>self.bounds.size.width) {
            [self settleTitleButton:sender];
        }
}

#pragma mark 列表UI
-(UICollectionView *)m_contentCollectionView{
    if(_m_contentCollectionView == nil){

        // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
        CGRect frame = CGRectMake(0, _navScrollView.bottom+10, self.frame.size.width, 50);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _m_contentCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _m_contentCollectionView.backgroundColor = [UIColor whiteColor];
        _m_contentCollectionView.delegate = self;
        _m_contentCollectionView.dataSource = self;
        [_m_contentCollectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:reuseID];

        // 设置cell的大小和细节
        flowLayout.itemSize = _m_contentCollectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _m_contentCollectionView.pagingEnabled = YES;
        _m_contentCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _m_contentCollectionView;
}

- (UIScrollView *)navScrollView{
    if (!_navScrollView) {
        _navScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _tabHeight)];
        _navScrollView.delegate = self;
        _navScrollView.userInteractionEnabled = YES;
        _navScrollView.showsHorizontalScrollIndicator = NO;
        _navScrollView.showsVerticalScrollIndicator = NO;
        _navScrollView.backgroundColor = UIColor.whiteColor;
    }
    return _navScrollView;
}

- (UIView *)lineView{
    if (!_lineView) {
        //设置导航标题下划线
        _lineView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _lineWidth, 3)];
        _lineView.backgroundColor = [UIColor colorWithHexString:self.themeColor];
        _lineView.tag = 1523;
        _lineView.layer.cornerRadius = 1.5;
        _lineView.clipsToBounds = YES;
    }
    return _lineView;
}
- (void)setTabsType:(DMTabsType)tabsType{
    _tabsType = tabsType;
    _titleColor = @"#666666";
    if (_tabsType == DMTabs_main_ls) {
        _titleSelFontSize = 16.0f;
        _lineWidth = 28.0f;
    }else if (_tabsType == DMTabs_second_ls){
        _titleSelFontSize = 15.0f;
        _lineWidth = 15.0f;
        _titleSelColor = @"#333333";
    }else{
        _titleSelFontSize = 16.0f;
        _lineWidth = 0.0f;
    }
}

- (void)setThmeType:(themeType)thmeType{
    _thmeType = thmeType;
    if (thmeType == themeTypeOrange) {
        _themeColor = @"#FF881D";
    }else if(thmeType == themeTypeRed){
        _themeColor = @"#FF4F01";
    }else{
        _themeColor = @"#23BE9F";
    }
    _titleSelColor = _themeColor;
}

- (void)setDNewNavArray:(NSMutableArray *)dNewNavArray{
    _dNewNavArray = dNewNavArray;
    /*
     根据设计来设定每个大小  1个以上和7个以下的标题按钮宽高都会不同
     sizeArr 依次存储按钮宽 、 按钮高、 按钮下划线距底部间距
     */
    NSArray *sizeArr = @[@[@200.0f,@100.0f,@13.6f],
                         @[@170.0f,@96.0f,@12.9f],
                         @[@158.0f,@90.0f,@12.0f],
                         @[@150.0f,@80.0f,@11.6f],
                         @[@114.0f,@72.0f,@9.1f],
                         ];
    if(_dNewNavArray.count>1){
        NSInteger count = (_dNewNavArray.count<7?_dNewNavArray.count:6)-2;//取坐标，大于7个取最后的坐标
        _minTitleBtnWidth =[ sizeArr[count][0] floatValue]/2.0;
        _minTitleBtnHeight =[ sizeArr[count][1] floatValue]/2.0;
        _lineMargin = [ sizeArr[count][2] floatValue]/2.0+3;
        _tabHeight = _minTitleBtnHeight;
        
    }
   
}


@end
