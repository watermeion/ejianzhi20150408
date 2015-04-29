//
//  CompanyInfoViewController.h
//  ejianzhi
//
//  Created by Mac on 4/29/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyInfoViewController : UIViewController
@property (strong,nonatomic)id company;
-(instancetype)initWithData:(id) company;
@end
