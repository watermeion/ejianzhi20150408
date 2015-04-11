//
//  CDIMService.m
//  LeanChat
//
//  Created by lzw on 15/4/3.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import "CDIMService.h"
#import "CDCache.h"
#import "CDUtils.h"
#import "CDUserService.h"
//#import "CDConvDetailVC.h"

@interface CDIMService ()<CDUserDelegate>

@property (nonatomic,strong) CDIM* im;

@property (nonatomic,strong) CDChatRoomVC* chatRoomVC;

@end

@implementation CDIMService

+(instancetype)shareInstance{
    static CDIMService* imService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imService=[[CDIMService alloc] init];
    });
    return imService;
}

-(instancetype)init{
    self=[super init];
    if(self){
       self.im=[CDIM sharedInstance];
    }
    return self;
}

#pragma mark - user delegate

-(void)cacheUserByIds:(NSSet *)userIds block:(AVIMArrayResultBlock)block{
    [CDCache cacheUsersWithIds:userIds callback:block];
}

-(id<CDUserModel>)getUserById:(NSString *)userId{
    CDUser* user=[[CDUser alloc] init];
    AVUser* avUser=[CDCache lookupUser:userId];
    if(user==nil){
        [NSException raise:@"user is nil" format:nil];
    }
    user.userId=userId;
    user.username=avUser.username;
    AVFile* avatarFile=[avUser objectForKey:@"avatar"];
    user.avatarUrl=avatarFile.url;
    return user;
}

-(void)goWithConv:(AVIMConversation*)conv fromVC:(UIViewController*)vc{
    [self goWithConv:conv fromNav:vc.navigationController];
}

-(void)goWithConv:(AVIMConversation*)conv fromNav:(UINavigationController*)nav{
    self.chatRoomVC=[[CDChatRoomVC alloc] initWithConv:conv];
    self.chatRoomVC.hidesBottomBarWhenPushed=YES;
    [CDCache setCurConv:conv];
    UIImage* _peopleImage=[CDUtils resizeImage:[UIImage imageNamed:@"chat_menu_people"] toSize:CGSizeMake(25, 25)];
    UIBarButtonItem* item=[[UIBarButtonItem alloc] initWithImage:_peopleImage style:UIBarButtonItemStyleDone target:self action:@selector(goChatGroupDetail:)];
    self.chatRoomVC.navigationItem.rightBarButtonItem=item;
    [nav pushViewController:self.chatRoomVC animated:YES];
}

-(void)goWithUserId:(NSString*)userId fromVC:(UIViewController*)vc {
    CDIM* im=[CDIM sharedInstance];
    [im fetchConvWithUserId:userId callback:^(AVIMConversation *conversation, NSError *error) {
        if(error){
            DLog(@"%@",error);
        }else{
            [self goWithConv:conversation fromVC:vc];
        }
    }];
}

- (void)goChatGroupDetail:(id)sender {
//    CDConvDetailVC* controller=[[CDConvDetailVC alloc] init];
//    [self.chatRoomVC.navigationController pushViewController:controller animated:YES];
}


@end
