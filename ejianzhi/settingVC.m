//
//  settingVC.m
//  ejianzhi
//
//  Created by RAY on 15/4/19.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "settingVC.h"
#import "UIImageView+EMWebCache.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "FogetPWDViewController.h"
@interface settingVC ()
@property (strong, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation settingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cacheLabel.text=[NSString stringWithFormat:@"%.1fM",(float)[[EMSDImageCache sharedImageCache] getSize]/(1024*1024)];
}
- (IBAction)clearCache:(id)sender {
    
    [[EMSDImageCache sharedImageCache] clearDiskOnCompletion:^{

        [MBProgressHUD showSuccess:@"清除成功" toView:self.view];
        self.cacheLabel.text=[NSString stringWithFormat:@"%.1fM",(float)[[EMSDImageCache sharedImageCache] getSize]/(1024*1024)];
        [[EMSDImageCache sharedImageCache] clearMemory];
    }];
}

- (IBAction)showIntroduction:(id)sender {
    
    TTAlert(@"e兼职功能介绍详情请登录 www.ejzhi.com ");
}
- (IBAction)showAboutUs:(id)sender {
    UITextView *textView=[[UITextView alloc]init];
    textView.text=@"重要提示：e兼职由北京融顺网络科技有限公司负责开发与运营。中科艾普依据本协议的规定为用户提供服务，本协议在用户和中科艾普之间具有合同的法律效力。\n\
    在此特别提醒用户认真阅读、充分理解本协议各条款，特别是其中所涉及的免除、限制用户的条款、对用户权利限制条款、争议解决和法律适用等条款。\n\
    一、用户注册\n\
    1.1 本协议内容包括协议正文及所有中科艾普已经发布或将来可能发布的各类服务条款及规则。所有条款与规则为协议不可分割的组成部分，与协议具有同等法律效力。\n\
    1.2 用户在使用e兼职提供的各项服务时，承诺接受并遵守各项相关条款的规定。e兼职有权根据需要不时地制定、修改本协议或各项条款。如本协议有任何变更，e兼职将在e兼职上刊载公告，通知用户。如用户不同意相关变更，必须停止使用e兼职所提供的服务。经修订的协议一经在e兼职公布后，立即自动生效。\n\
    1.3 e兼职的各项服务的所有权和运作权归北京融顺网络科技有限公司所有。\n\
    1.4 用户必须是具有完全民事行为能力的自然人，或者是具有合法经营资格的实体组织。无民事行为能力人、限制民事行为能力人以及无合法经营资格的组织不得与e兼职进行交易，如与e兼职进行交易的，则服务协议自始无效，e兼职有权立即停止与该用户的交易、注销该用户账户，并有权要求其承担相应的法律责任。\n\
    二、用户账户\n\
    2.1 用户注册成功后，e兼职将为用户开通一个账户，作为用户在e兼职交易及使用e兼职服务时的唯一身份标识，该账户的用户名和密码由用户负责保管。\n\
    2.2 用户使用e兼职服务时，应谨慎、合理、安全地保存和使用用户名及密码，用户应对以其用户名和密码进行的操作和交易活动负责。用户如发现任何非法使用用户账号或存在安全漏洞的情况，应立即通知联盟服务并向公安机关报案。\n\
    三、用户信息收集、使用和保护\n\
    3.1 用户在使用e兼职服务服务时需要根据要求披露一些信息，这些信息包括但不限于：真实姓名或名称、联系地址、邮箱和联系电话等。用户应保证这些信息在提供时是真实、准确、有效且完整的，且应及时根据实际情况或者e兼职的要求更新这些信息。由于信息披露不完整、不真实或者信息更新不及时导致用户在享受e兼职服务时受到限制或损失的，应由用户独立承担责任。除了必要信息外，用户也有权自行决定披露一些其他信息。\n\
    3.2 用户授权e兼职收集您的用户信息，这些信息可能包括注册信息、产品信息和交易信息，e兼职对用户信息的收集将遵循相关法律的规定。\n\
    3.3 e兼职将采取适当措施，根据相关法律的要求，对用户信息提供充分的信息安全保障。用户应妥善保管、使用其用户信息，包括QQ号码及其密码、微信帐号及其密码、与交易有关的支付账号及密码、联系方式、地址等信息，因上述信息泄露而导致用户的任何损失，包括使用e兼职的任何第三方应用软件造成信息泄露而导致的任何损失，由用户独立承担责任。如用户泄露上述任何信息，用户还应及时将泄露的情况以有效方式立即通知e兼职，以便e兼职在合理时间内采取措施防止损失继续扩大，但e兼职对采取措施前已经产生的后果不承担任何责任。\n\
    3.4 e兼职保证不对外公开或向任何第三方提供用户的个人信息，但是存在下列情形之一的除外：\n\
    3.4.1 公开或提供相关信息之前获得用户许可的；\n\
    3.4.2 根据法律或政策的规定而公开或提供的；\n\
    3.4.3 只有公开或提供用户的个人信息，才能提供用户需要的商品或服务的；\n\
    3.4.4 根据国家权力机关要求公开或提供的；\n\
    3.4.5 根据本协议其他条款约定而公开或提供的。\n\
    3.5 用户理解并认同，在e兼职发生重组、解散、破产清算、并购等情况时，e兼职可能会向第三方出售或转让。在该等交易中，作为e兼职不可分割的一部分，您的用户信息也可能将被转让给该第三方，以使该第三方可以继续为您提供服务。\n\
    四、服务规则\n\
    4.1  同意接收广告、营销信息：用户同意接收来自e兼职的信息，包括但不限于营销活动信息、商品交易信息、促销信息等。为使用户及时了解丰富的商品信息，提升电商服务体验，e兼职其合作的第三方可以在法律法规允许的范围内，通过短信、电话、邮件等各种方式向用户提供前述信息。\n\
    五、规则变更\n\
    5.1 e兼职可以根据需要变更本服务规则。对服务规则的修改和变更将被包含在e兼职更新后的规则中。所有变更具有可分性，如果部分变更或条款被认定为无效的，不影响其他变更或条款的有效性。e兼职\n\
    5.2 用户在使用e兼职提供的各项服务时，承诺接受并遵守各项相关规则的规定。e兼职有权根据需要不时地制定、修改本协议或各类规则。如果用户不同意相关变更，则应当停止使用e兼职服务。经修订的协议及服务规则一经在网站公布后，则立即生效。\n\
    六、责任限制\n\
    6.1 在法律法规允许的限度内，因使用e兼职服务而引起的任何损害或经济损失，e兼职承担的全部责任均不超过用户所购买的与该索赔有关的商品金额。\n\
    6.2 除非另有书面说明，e兼职不对e兼职的运营及其包含的信息、内容、材料、产品（包括软件）或服务作任何形式的、明示或默示的声明或担保。\n\
    6.3 e兼职不担保e兼职提供给用户的全部信息，从e兼职或其服务器发出的电子邮件、信息等没有病毒或其他有害成份。\n\
    6.4 如因不可抗力或其他e兼职无法控制的原因使e兼职系统崩溃或无法正常使用导致网上交易无法完成或丢失有关的信息、记录等，e兼职不承担责任。但是e兼职会尽可能合理地协助处理善后事宜，并努力使用户免受损失。\n\
    七、终止服务\n\
    7.1 如用户向e兼职提出注销用户账号时，经e兼职审核同意后予以注销其账号，用户即解除与e兼职的服务协议关系。但注销该用户账号后，e兼职仍保留以下权利：\n\
    7.1.1 e兼职有权保留该用户的注册信息及以前的交易信息；\n\
    7.1.2 如用户在注销前在e兼职上存在违法行为或违反本协议的行为，e兼职仍可行使本协议所规定的权利。\n\
    7.2 下列情形，e兼职可以通过注销用户的方式终止服务： \n\
    7.2.1 用户违反本协议相关规定，e兼职有权终止向该用户提供服务。\n\
    7.2.2 e兼职发现用户注册信息中主要内容是虚假的，e兼职有权随时终止向该用户提供服务。\n\
    7.2.3 本协议终止或更新时，用户不愿接受新的服务协议的。\n\
    八、用户管理\n\
    8.1 用户不得在e兼职发表包含以下内容的言论：\n\
    8.1.1 反对宪法所确定的基本原则，煽动、抗拒、破坏宪法和法律、行政法规实施的；\n\
    8.1.2 煽动颠覆国家政权，推翻社会主义制度，煽动、分裂国家，破坏国家统一的；\n\
    8.1.3 损害国家荣誉和利益的；\n\
    8.1.4 煽动民族仇恨、民族歧视，破坏民族团结的；\n\
    8.1.5 任何包含对种族、性别、宗教、地域内容等歧视的；\n\
    8.1.6 捏造或者歪曲事实，散布谣言，扰乱社会秩序的；\n\
    8.1.7 宣扬封建迷信、邪教、淫秽、色情、赌博、暴力、凶杀、恐怖、教唆犯罪的；\n\
    8.1.8 公然侮辱他人或者捏造事实诽谤他人的，或者进行其他恶意攻击的；\n\
    8.1.9 其他违反宪法和法律法规的。\n\
    8.2 用户同意严格遵守以下义务：\n\
    8.2.1 不得利用e兼职从事洗钱、窃取商业秘密、窃取个人信息等违法犯罪活动；\n\
    8.2.2 不得干扰e兼职的正常运营，不得侵入网站及计算机信息系统；\n\
    8.2.3 不得利用在e兼职注册的账户进行牟利性经营活动；\n\
    8.2.4 不得发布任何侵犯他人著作权、商标权等知识产权或其他合法权利的内容。\n\
    8.3 如用户未遵守以上规定的，e兼职有权作出独立判断并采取暂停或注销用户账户等措施。用户对自己在网上的言论和行为独立承担法律责任。\n\
    九、法律适用和争议管辖\n\
    9.1 本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。\n\
    9.2 如发生e兼职服务条款与中国法律相抵触时，则该等条款将按法律规定解释，而其他条款继续有效。\n\
    9.3 如用户与e兼职就本协议内容或其履行等发生的一切争议，双方应努力通过友好协商解决；协商不能解决时，任何一方均应将争议提交北京融顺网络科技有限公司所在地有管辖权的人民法院诉讼解决。";
    UIViewController *aboutusVC=[[UIViewController alloc]init];
    aboutusVC.view=textView;
    aboutusVC.title=@"关于我们";
    [self.navigationController pushViewController:aboutusVC animated:YES];
}
- (IBAction)modifyPhone:(id)sender {
    FogetPWDViewController *modifyVC=[[FogetPWDViewController alloc]init];
    modifyVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:modifyVC animated:YES];
}
- (IBAction)modifyPassword:(id)sender {
   
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
