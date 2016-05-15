//
//  ViewController.m
//  Branch-TestBed
//
//  Created by Alex Austin on 6/5/14.
//  Copyright (c) 2014 Branch Metrics. All rights reserved.
//

#import "Branch.h"
#import "ViewController.h"
#import "CreditHistoryViewController.h"
#import "LogOutputViewController.h"
#import "BranchUniversalObject.h"
#import "BranchLinkProperties.h"


NSString *cononicalIdentifier = @"item/12345";
NSString *canonicalUrl = @"https://branch.io/deepviews";
NSString *title = @"My Content Title";
NSString *contentDescription = @"My Content Description";
NSString *imageUrl = @"https://pbs.twimg.com/profile_images/658759610220703744/IO1HUADP.png";
NSString *feature = @"sharing";
NSString *channel = @"test";
NSString *desktop_url = @"http://branch.io";
NSString *ios_url = @"https://dev.branch.io/getting-started/sdk-integration-guide/guide/ios/";
NSString *shareText = @"Super amazing thing I want to share";
NSString *user_id1 = @"abe@emailaddress.io";
NSString *user_id2 = @"ben@emailaddress.io";
NSString *live_key = @"live_key";
NSString *test_key = @"test_key";
NSDictionary *metadata;


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *refreshUrlButton;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UITextField *editRefShortUrl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) BranchUniversalObject *branchUniversalObject;

@end


@implementation ViewController


- (void)viewDidLoad {
    [self.editRefShortUrl addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
    
    _branchUniversalObject = [[BranchUniversalObject alloc] initWithCanonicalIdentifier: cononicalIdentifier];
    _branchUniversalObject.canonicalUrl = canonicalUrl;
    _branchUniversalObject.title = title;
    _branchUniversalObject.contentDescription = contentDescription;
    _branchUniversalObject.imageUrl = imageUrl;
    [_branchUniversalObject addMetadataKey:@"Metadata_Key1" value:@"Metadata_value1"];
    [_branchUniversalObject addMetadataKey:@"Metadata_Key2" value:@"Metadata_value2"];
    [self refreshRewardPoints];
    
}


- (IBAction)createBranchLinkButtonTouchUpInside:(id)sender {
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = feature;
    linkProperties.channel = channel;
    [linkProperties addControlParam:@"$desktop_url" withValue: desktop_url];
    [linkProperties addControlParam:@"$ios_url" withValue: channel];
    
    [self.branchUniversalObject getShortUrlWithLinkProperties:linkProperties andCallback:^(NSString *url, NSError *err) {
        [self.editRefShortUrl setText:url];
    }];
}


- (IBAction)redeemFivePointsButtonTouchUpInside:(id)sender {
    _pointsLabel.hidden = YES;
    [_activityIndicator startAnimating];
    
    Branch *branch = [Branch getInstance];
    [branch redeemRewards:5 callback:^(BOOL changed, NSError *error) {
        if (error || !changed) {
            NSLog(@"Branch TestBed: Didn't redeem anything: %@", error);
            [self showAlert:@"Redemption Unsuccessful" withDescription:error.localizedDescription];
        } else {
            NSLog(@"Branch TestBed: Five Points Redeemed!");
            [_pointsLabel setText:[NSString stringWithFormat:@"%ld", (long)[branch getCredits]]];
        }
        _pointsLabel.hidden = NO;
        [_activityIndicator stopAnimating];
    }];
}


- (IBAction)setUserIDButtonTouchUpInside:(id)sender {
    Branch *branch = [Branch getInstance];
    [branch setIdentity: user_id2 withCallback:^(NSDictionary *params, NSError *error) {
        if (!error) {
            NSLog(@"Branch TestBed: Identity Successfully Set%@", params);
            [self performSegueWithIdentifier:@"ShowLogOutput" sender:[NSString stringWithFormat:@"Identity set to: %@\n\n%@", user_id2, params.description]];
        } else {
            NSLog(@"Branch TestBed: Error setting identity: %@", error);
            [self showAlert:@"Unable to Set Identity" withDescription:error.localizedDescription];
        }
    }];
}


- (IBAction)refreshRewardsButtonTouchUpInside:(id)sender {
    [self refreshRewardPoints];
}


- (IBAction)logoutWithCallback {
    Branch *branch = [Branch getInstance];
    [branch logoutWithCallback:^(BOOL changed, NSError *error) {
        if (error || !changed) {
            NSLog(@"Branch TestBed: Logout failed: %@", error);
            [self showAlert:@"Error simulating logout" withDescription:error.localizedDescription];
        } else {
            NSLog(@"Branch TestBed: Logout");
            [self refreshRewardPoints];
            [self showAlert:@"Logout succeeded" withDescription:@""];
        }
    }];
    
    self.pointsLabel.text = @"";
}


- (IBAction)sendBuyEventButtonTouchUpInside:(id)sender {
    Branch *branch = [Branch getInstance];
    [branch userCompletedAction:@"buy" withState:nil withDelegate:self];
    [self refreshRewardPoints];
    [self showAlert:@"'buy' event dispatched" withDescription:@""];
}


- (IBAction)sendComplexEventButtonTouchUpInside:(id)sender {
    NSDictionary *eventDetails = [[NSDictionary alloc] initWithObjects:@[user_id1, [NSNumber numberWithInt:1], [NSNumber numberWithBool:YES], [NSNumber numberWithFloat:0.13415512301], test_key] forKeys:@[@"name",@"integer",@"boolean",@"float",@"test_key"]];
    
    Branch *branch = [Branch getInstance];
    [branch userCompletedAction:@"buy" withState:eventDetails];
    [self performSegueWithIdentifier:@"ShowLogOutput" sender:[NSString stringWithFormat:@"Custom Event Details:\n\n%@", eventDetails.description]];
    [self refreshRewardPoints];
}


- (IBAction)getCreditHistoryButtonTouchUpInside:(id)sender {
    Branch *branch = [Branch getInstance];
    [branch getCreditHistoryWithCallback:^(NSArray *creditHistory, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"ShowCreditHistory" sender:creditHistory];
        } else {
            NSLog(@"Branch TestBed: Error retrieving credit history: %@", error.localizedDescription);
            [self showAlert:@"Error retrieving credit history" withDescription:error.localizedDescription];
        }
    }];
}


- (IBAction)simulateReferralsButtonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:@"ShowSimulateReferrals" sender:self];
}


- (IBAction)viewFirstReferringParamsButtonTouchUpInside:(id)sender {
    Branch *branch = [Branch getInstance];
    [self performSegueWithIdentifier:@"ShowLogOutput" sender:[[branch getFirstReferringParams] description]];
    NSLog(@"Branch TestBed: FirstReferringParams:\n%@", [[branch getFirstReferringParams] description]);
}


- (IBAction)viewLatestReferringParamsButtonTouchUpInside:(id)sender {
    Branch *branch = [Branch getInstance];
    [self performSegueWithIdentifier:@"ShowLogOutput" sender:[[branch getLatestReferringParams] description]];
    NSLog(@"Branch TestBed: LatestReferringParams:\n%@", [[branch getLatestReferringParams] description]);
}


- (IBAction)simulateContentAccessButtonTouchUpInsideButtonTouchUpInside:(id)sender {
    [self.branchUniversalObject registerView];
    [self showAlert:@"Content Access Registered" withDescription:@""];
}


/*
 - (IBAction)cmdIndexSpotlight:(id)sender {
 [self.branchUniversalObject listOnSpotlightWithCallback:^(NSString *url, NSError *error) {
 if (!error) {
 NSLog(@"Branch TestBed: ShortURL: %@", url);
 } else {
 NSLog(@"Branch TestBed: Error: %@", error);
 }
 }];
 }*/


//example using callbackWithURLandSpotlightIdentifier
- (IBAction)registerWithSpotlightButtonTouchUpInside:(id)sender {
    [self.branchUniversalObject listOnSpotlightWithIdentifierCallback:^(NSString *url, NSString *spotlightIdentifier,  NSError *error) {
        if (!error) {
            NSLog(@"Branch TestBed: ShortURL: %@   spotlight ID: %@", url, spotlightIdentifier);
            [self showAlert:@"Spotlight Registration Succeeded" withDescription:[NSString stringWithFormat:@"Branch Link:\n%@\n\nSpotlight ID:\n%@", url, spotlightIdentifier]];
        } else {
            NSLog(@"Branch TestBed: Error: %@", error);
            [self showAlert:@"Spotlight Registration Failed" withDescription:error.localizedDescription];
        }
    }];
}


- (IBAction)shareLinkButtonTouchUpInside:(id)sender {
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = feature;
    [linkProperties addControlParam:@"$desktop_url" withValue: desktop_url];
    [linkProperties addControlParam:@"$ios_url" withValue: ios_url];
    
    
    [self.branchUniversalObject
     showShareSheetWithShareText: shareText
     completion:^(NSString *activityType, BOOL completed) {
         if (completed) {
             NSLog(@"%@", [NSString stringWithFormat:@"Branch TestBed: Completed sharing to %@", activityType]);
         }
     }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowCreditHistory"]) {
        ((CreditHistoryViewController *)segue.destinationViewController).creditTransactions = sender;
    } else if ([segue.identifier isEqualToString:@"ShowLogOutput"]) {
        ((LogOutputViewController *)segue.destinationViewController).logOutput = sender;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshRewardPoints];
}


- (void)textFieldFinished:(id)sender {
    [sender resignFirstResponder];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.editRefShortUrl isFirstResponder] && [touch view] != self.editRefShortUrl) {
        [self.editRefShortUrl resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


- (void)branchViewVisible: (NSString *)actionName withID:(NSString *)branchViewID {
    NSLog(@"Branch TestBed: branchViewVisible for action : %@ %@", actionName, branchViewID);
}


- (void)branchViewAccepted: (NSString *)actionName withID:(NSString *)branchViewID {
    NSLog(@"Branch TestBed: branchViewAccepted for action : %@ %@", actionName, branchViewID);
}


- (void)branchViewCancelled: (NSString *)actionName withID:(NSString *)branchViewID {
    NSLog(@"Branch TestBed: branchViewCancelled for action : %@ %@", actionName, branchViewID);
}

- (void)refreshRewardPoints {
    _pointsLabel.hidden = YES;
    [_activityIndicator startAnimating];
    Branch *branch = [Branch getInstance];
    [branch loadRewardsWithCallback:^(BOOL changed, NSError *error) {
        if (!error) {
            [_pointsLabel setText:[NSString stringWithFormat:@"%ld", (long)[branch getCredits]]];
        }
        [_activityIndicator stopAnimating];
        _pointsLabel.hidden = NO;
    }];
}

- (void)showAlert: (NSString *)title withDescription:(NSString *) unattributedMessage {
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    UIFont *font = [UIFont fontWithName:@"Courier New" size:11.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:unattributedMessage attributes:attributes];
    [messageText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,[unattributedMessage length])];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:unattributedMessage preferredStyle:UIAlertControllerStyleAlert];
    [alert setValue:messageText forKey:@"attributedMessage"];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
