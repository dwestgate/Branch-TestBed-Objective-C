//
//  SimulateReferralsViewController.m
//  Branch-TestBed
//
//  Created by David Westgate on 5/4/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

#import "Branch.h"
#import "BranchGetPromoCodeRequest.h"
#import "SimulateReferralsViewController.h"
#import "BranchConstants.h"

@interface SimulateReferralsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *promoCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *enterPrefixTextField;


@property (assign) NSDate *expirationDate;

@end

@implementation SimulateReferralsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _expirationDate = nil;
    
    rewardTypes = [[NSArray alloc] initWithObjects:@"Unlimited",@"Unique",nil];
    UIPickerView *rewardTypePicker = [[UIPickerView alloc] init];
    [_selectRewardTypeTextField setInputView:rewardTypePicker];
    rewardTypePicker.dataSource = self;
    rewardTypePicker.delegate = self;
    [rewardTypePicker setShowsSelectionIndicator:YES];
    [_selectRewardTypeTextField setInputView:rewardTypePicker];
    UIToolbar *rewardTypeToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
    [rewardTypeToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneSelectRewardTypeButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneRewardTypePicker)];
    UIBarButtonItem *emptySpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [rewardTypeToolBar setItems:[NSArray arrayWithObjects: emptySpace, doneSelectRewardTypeButton, nil]];
    [_selectRewardTypeTextField setInputAccessoryView:rewardTypeToolBar];
    
    rewardRecipients = [[NSArray alloc] initWithObjects:@"Referring user",@"Referred user",@"Both users",nil];
    UIPickerView *selectRewardRecipientPicker = [[UIPickerView alloc] init];
    [_selectRewardRecipientTextField setInputView:selectRewardRecipientPicker];
    selectRewardRecipientPicker.dataSource = self;
    selectRewardRecipientPicker.delegate = self;
    [selectRewardRecipientPicker setShowsSelectionIndicator:YES];
    [_selectRewardRecipientTextField setInputView:selectRewardRecipientPicker];
    UIToolbar *rewardRecipientToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
    [rewardRecipientToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneSelectRewardRecipientButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneSelectRewardRecipientPicker)];
    [rewardRecipientToolBar setItems:[NSArray arrayWithObjects: emptySpace, doneSelectRewardRecipientButton, nil]];
    [_selectRewardRecipientTextField setInputAccessoryView:rewardRecipientToolBar];
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [_expirationDateTextField setInputView:datePicker];
    UIToolbar *datePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
    [datePickerToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *cancelDatePickerButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDatePicker)];
    UIBarButtonItem *doneDatePickerButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(updateExpirationDateTextField)];
    [datePickerToolBar setItems:[NSArray arrayWithObjects: cancelDatePickerButton, emptySpace, doneDatePickerButton, nil]];
    [_expirationDateTextField setInputAccessoryView:datePickerToolBar];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_selectRewardTypeTextField.isFirstResponder) {
        return [rewardTypes count];
    } else {
        return [rewardRecipients count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_selectRewardTypeTextField.isFirstResponder) {
        return [rewardTypes objectAtIndex:row];
    } else {
        return [rewardRecipients objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_selectRewardTypeTextField.isFirstResponder) {
        _selectRewardTypeTextField.text = [rewardTypes objectAtIndex:row];
    } else {
        _selectRewardRecipientTextField.text = [rewardRecipients objectAtIndex:row];
    }
}


- (void)doneRewardTypePicker {
    [_selectRewardTypeTextField resignFirstResponder];
}


- (void)doneSelectRewardRecipientPicker {
    [_selectRewardRecipientTextField resignFirstResponder];
}


- (void)cancelDatePicker {
    [_expirationDateTextField resignFirstResponder];
}


- (void)updateExpirationDateTextField {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    _expirationDate = datePicker.date;
    _expirationDateTextField.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate: _expirationDate]];
    [_expirationDateTextField resignFirstResponder];
}

- (IBAction)getButton:(id)sender {
    Branch *branch = [Branch getInstance];
    
    NSString *prefix = _enterPrefixTextField.text;
    int amount = [_amountTextField.text intValue];
    int rewardType = (int) [rewardTypes indexOfObject: _selectRewardTypeTextField.text];
    int rewardRecipient = (int) [rewardRecipients indexOfObject:_selectRewardRecipientTextField.text];
    
    [branch getPromoCodeWithPrefix:prefix amount:amount expiration:_expirationDate bucket:@"default" usageType:rewardType rewardLocation:rewardRecipient callback:^(NSDictionary *params, NSError *error) {
        if (!error) {
            _promoCodeTextField.text = [params valueForKey:BRANCH_RESPONSE_KEY_PROMO_CODE];
            NSLog(@"Branch TestBed: Get promo code results:\n%@", params);
            [self showAlert:@"Get Promo Code" withDescription:params.description];
        } else {
            NSLog(@"Branch TestBed: Error retreiving promo code: \n%@", [error localizedDescription]);
            [self showAlert:@"Get Promo Code Failure" withDescription:error.localizedDescription];
        }
    }];
    /*
     [branch getReferralCodeWithPrefix:prefix amount:amount expiration:_expirationDate andCallback:^(NSDictionary *params, NSError *error) {
     if (!error) {
     NSLog(@"Branch TestBed: Parameters returned from Branch:\n%@", params);
     _promoCodeTextField.text = [params valueForKey:BRANCH_RESPONSE_KEY_PROMO_CODE];
     } else {
     NSLog(@"Branch TestBed: Error retreiving referral code: \n%@", [error localizedDescription]);
     }
     }];*/
    
    /*[branch getPromoCodeWithPrefix:prefix amount:amount callback:^(NSDictionary *params, NSError *error) {
     if (!error) {
     NSLog(@"Branch TestBed: Promo code: %@", params);
     } else {
     NSLog(@"Branch TestBed: Error retreiving promo code.");
     }
     }];*/
    
    NSLog(@"Branch TestBed: Get %@", prefix);
    
}


- (IBAction)validateButton:(id)sender {
    Branch *branch = [Branch getInstance];
    
    if (_promoCodeTextField.text.length > 0) {
        [branch validateReferralCode:_promoCodeTextField.text andCallback:^(NSDictionary *params, NSError *error) {
            
            
            
            
            if (!error) {
                
                if ([params objectForKey:@"error_message"] != nil) {
                    NSLog(@"Promo code %@ is invalid.", _promoCodeTextField.text);
                    NSLog(@"Branch TestBed: Parameters returned from Branch:\n%@", params);
                    [self showAlert:@"Validation Failed" withDescription:params.description];
                } else {
                    NSLog(@"Promo code %@ is valid.", [params valueForKey:BRANCH_RESPONSE_KEY_PROMO_CODE]);
                    NSLog(@"Branch TestBed: Parameters returned from Branch:\n%@", params);
                    [self showAlert:@"Validation Succeeded" withDescription:params.description];
                }

            } else {
                NSDictionary *errorDescription = [error localizedDescription];
                NSLog(@"Branch TestBed: Promo code validation failed:\n%@", errorDescription);
                [self showAlert:@"Validation Failed" withDescription:errorDescription.description];
            }
            
            
        }];
    } else {
        NSLog(@"Branch TestBed: No promo code to validate\n");
        [self showAlert:@"No promo code!" withDescription:@""];
    }
}


- (IBAction)redeemButton:(id)sender {
    Branch *branch = [Branch getInstance];
    
    if (_promoCodeTextField.text.length > 0) {
        [branch applyReferralCode:_promoCodeTextField.text andCallback:^(NSDictionary *params, NSError *error) {
            if (!error) {
                NSLog(@"Branch TestBed: Parameters returned from Branch:\n%@", params);
                NSLog(@"Promo code %@ has been successfully applied.", [params valueForKey:BRANCH_RESPONSE_KEY_PROMO_CODE]);
            } else {
                NSLog(@"Branch TestBed: Error retreiving referral code: \n%@", [error localizedDescription]);
            }
        }];
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


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
