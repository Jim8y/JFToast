//
//  ViewController.m
//  JHToast
//
//  Created by 廖京辉 on 3/18/16.
//  Copyright © 2016 廖京辉. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (IBAction)showToast:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showToast:(id)sender {
    [JHToast showWithText:@"This is a toast" bottomOffset:100.0f duration:3.5f];
}
@end
