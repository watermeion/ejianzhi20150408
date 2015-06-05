//
//  InputInfoVC.h
//  ejianzhi
//
//  Created by RAY on 15/5/2.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol finishInputDelegate <NSObject>
@required
- (void)finishInputWithType:(NSInteger)type And:(id)info;
@end

@interface InputInfoVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *inputInfoLabel;
@property (nonatomic,weak) id<finishInputDelegate> inputDelegate;
@property (nonatomic) NSInteger inputType;
@property (nonatomic, strong) NSString *labelText;

@end
