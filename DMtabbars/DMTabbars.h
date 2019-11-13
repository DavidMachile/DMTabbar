//
//  DMTabbars.h
//  reddot
//
//  Created by DM_dsz on 2019/11/8.
//  Copyright © 2019 dsz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,DMTabsType) {//tabs类型
    DMTabs_main_ls = 1,//标题、线和主题色统一色调
    DMTabs_main_fc,//没有下划线
    DMTabs_second_ls //标题固定黑色 线颜色和主题保持一致
};
typedef NS_ENUM(NSInteger,themeType){//主题色调
    themeTypeGreen = 1,
    themeTypeRed,
    themeTypeOrange
};
@interface DMTabbars : UIView

/**
 init初始化

 @param frame frame
 @param tabsType tabs类型
 @param themeType 主题色调
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                     tabsType:(DMTabsType)tabsType
                    themeType:(themeType)themeType;



/**
 数组
 */
@property (nonatomic , strong) NSMutableArray * dNewNavArray;


/**
 tabs类型
 */
@property (nonatomic , assign)DMTabsType tabsType;

/**
 主题色
 */
@property (nonatomic , assign) themeType thmeType;


@end

NS_ASSUME_NONNULL_END
