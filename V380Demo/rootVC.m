//
//  rootVC.m
//  DEMO
//
//  Created by 视宏 on 16/12/9.
//  Copyright © 2016年 macrovideo. All rights reserved.
//

#import "rootVC.h"
#import "PanoPlayViewController.h"
#import "PlayViewController.h"
#import "RecFileSearchViewController.h"
@interface rootVC ()
@property(nonatomic,strong) PanoPlayViewController *panoVC;
@property(nonatomic,strong) PlayViewController *playVC;
@property(nonatomic,strong) RecFileSearchViewController *recFileVC;

@end

@implementation rootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton *btn1 =[UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *btn2 =[UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"普通" forState:UIControlStateNormal];
    [btn2 setTitle:@"全景" forState:UIControlStateNormal];
    [btn3 setTitle:@"录像回放" forState:UIControlStateNormal];

    
    [btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
     [btn3 addTarget:self action:@selector(btn3click) forControlEvents:UIControlEventTouchUpInside];
    
    btn1.frame = CGRectMake(100, 100, 120, 30);
    btn2.frame = CGRectMake(100, 150, 120, 30);
    btn3.frame = CGRectMake(100, 200, 120, 30);

    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    
    self.panoVC = [[PanoPlayViewController alloc]initWithNibName:@"PanoPlayViewController_iphone" bundle:nil];
    self.playVC = [[PlayViewController alloc]initWithNibName:@"PlayViewController_iphone" bundle:nil];
 self.recFileVC  = [[RecFileSearchViewController alloc] initWithNibName:@"RecFileSearchViewController" bundle:nil];
}

-(void)btn2click{
    [self presentViewController:self.panoVC animated:YES completion:nil];
//    [self.navigationController pushViewController:self.panoVC animated:YES];
    
}
-(void)btn1click{
    [self presentViewController:self.playVC animated:YES completion:nil];
//    [self.navigationController pushViewController:self.playVC animated:YES];
}

-(void)btn3click{

    [self.recFileVC initInterface];
    [self.recFileVC updateServerListData];
    [self presentViewController:self.recFileVC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
