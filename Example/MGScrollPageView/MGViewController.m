//
//  MGViewController.m
//  MGScrollPageView
//
//  Created by spf on 09/25/2017.
//  Copyright (c) 2017 spf. All rights reserved.
//

#import "MGViewController.h"
#import "MGScrollPageView_Example-Swift.h"

@interface MGViewController ()

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonAction:(id)sender {
    TabListViewController *textVC =  [[TabListViewController alloc] init];
    [self.navigationController pushViewController:textVC animated:true];
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
