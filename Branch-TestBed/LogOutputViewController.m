//
//  LogOutputViewController.m
//  Branch-TestBed
//
//  Created by David Westgate on 5/11/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

#import "LogOutputViewController.h"

@interface LogOutputViewController ()

@property (weak, nonatomic) IBOutlet UITextView *logOutputTextView;

@end

@implementation LogOutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _logOutputTextView.text = _logOutput;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
