//
//  LogOutputViewController.h
//  Branch-TestBed
//
//  Created by David Westgate on 5/11/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Branch.h"

@interface LogOutputViewController : UIViewController <BranchDeepLinkingController>

@property (nonatomic, strong) NSString *logOutput;

@end
