//
//  FogetPWDViewController.h
//  ejianzhi
//
//  Created by Mac on 5/7/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FogetPWDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
- (IBAction)sendMsgAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *showTimerLabel;
@property (weak, nonatomic) IBOutlet UITextField *smscodeText;
@property (weak, nonatomic) IBOutlet UITextField *pwdNewText;

@property (weak, nonatomic) IBOutlet UITextField *pwdNewAgainText;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitAction:(id)sender;

@end
