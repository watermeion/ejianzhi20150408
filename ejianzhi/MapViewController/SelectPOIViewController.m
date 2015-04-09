//
//  SelectPOIViewController.m
//  EJianZhi
//
//  Created by Mac on 3/29/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "SelectPOIViewController.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
@interface SelectPOIViewController ()<UITextViewDelegate>




- (IBAction)backAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)addTextAction:(id)sender;
- (IBAction)confirmAction:(id)sender;

@end

@implementation SelectPOIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置显示标题
    //此处你们可以替换会KVO 监听值的变化
    [self addObserver:self forKeyPath:@"rightNowData" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
//    @weakify(self)
//    [RACObserve(self,rightNowData) subscribeNext:^(id x) {
//        @strongify(self)
//         [self.confirmBtn setTitle:self.rightNowData.address forState:UIControlStateNormal];
//    }];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"rightNowData"])
    {
          [self.confirmBtn setTitle:self.rightNowData.address forState:UIControlStateNormal];
    }
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

/**
 *  向后跳转
 *
 *  @param sender <#sender description#>
 */
- (IBAction)backAction:(id)sender {
    NSInteger index=self.rightNowData.index;
    if(index>0)  index--;
    if(index==0) [MBProgressHUD showError:@"到头了" toView:nil];
    [self.delegate backToIndex:index];
}

- (IBAction)nextAction:(id)sender {
    
    NSInteger index=self.rightNowData.index;
    if(index>=0)  index++;
    [self.delegate nextToIndex:index];
}

- (IBAction)addTextAction:(id)sender {
    [self.delegate sendAddTextSignal];

}

- (IBAction)confirmAction:(id)sender {
    NSInteger index=self.rightNowData.index;
    [self.delegate sendSelectedIndex:index];
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    [self.delegate getTextWhenEndEdit:textView.text];
    [textView removeFromSuperview];
}


@end
