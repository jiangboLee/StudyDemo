//
//  ViewController.m
//  SaoYiSaoDemo
//
//  Created by ljb48229 on 2017/12/5.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import "ViewController.h"
#import "LEEScanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushToScanV:(id)sender {
    
    LEEScanViewController *scanVC = [[LEEScanViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
