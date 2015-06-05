//
//  ResetPwdViewController.h
//  ejianzhi
//
//  Created by Mac on 5/11/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextField *smsCode;
@property (weak, nonatomic) IBOutlet UIButton *GetSMSBtn;

@end
