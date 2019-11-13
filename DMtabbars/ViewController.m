//
//  ViewController.m
//  DMtabbars
//
//  Created by DM_dsz on 2019/11/13.
//  Copyright © 2019 dsz. All rights reserved.
//

#import "ViewController.h"
#import "DMTabbars.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    DMTabbars *tab = [[DMTabbars alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width , 50) tabsType:DMTabs_main_ls themeType:3];
    tab.dNewNavArray = (NSMutableArray *)@[@"关注",@"推荐",@"热点",@"北京",@"视频",@"图片",@"问答",@"科技",@"房产",@"健康"];
    [self.view addSubview:tab];
    
    CGRect rect1 =  CGRectMake(30, 200, self.view.frame.size.width-60, 50);
    DMTabbars *tab1 = [[DMTabbars alloc]initWithFrame:rect1 tabsType:DMTabs_second_ls themeType:3];
    tab1.dNewNavArray = (NSMutableArray *)@[@"关注",@"推荐",@"热点",@"北京"];
    [self.view addSubview:tab1];
    
    CGRect rect2 =  CGRectMake(0, 400, self.view.frame.size.width, 50);
    DMTabbars *tab2 = [[DMTabbars alloc]initWithFrame:rect2 tabsType:DMTabs_main_fc themeType:3];
    tab2.dNewNavArray = (NSMutableArray *)@[@"关注",@"推荐",@"热点",@"北京",@"视频"];
    [self.view addSubview:tab2];
    // Do any additional setup after loading the view.
}


@end
