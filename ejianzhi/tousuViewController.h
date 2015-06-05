//
//  tousuViewController.h
//  ejianzhi
//
//  Created by Mac on 4/20/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

@protocol tousuViewControllerDelegate <NSObject>

-(void) commitTousu:(NSString*) tousuliyou;

@end

#import <UIKit/UIKit.h>

@interface tousuViewController : UIViewController

@property (strong,nonatomic)NSString *tousuLiyou;

@property (weak, nonatomic) IBOutlet UITextView *tousuliyouTextView;
@property (weak,nonatomic)id<tousuViewControllerDelegate> delegate;

@end
