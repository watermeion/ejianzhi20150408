//
//  CDIMClient.m
//  LeanChat
//
//  Created by lzw on 15/1/21.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import "CDIM.h"
#import "CDRoom.h"
#import "CDStorage.h"
#import "CDNotify.h"
#import "CDMacros.h"
#import "CDEmotionUtils.h"

static CDIM*instance;

@interface CDIM()<AVIMClientDelegate,AVIMSignatureDataSource>{
}

@property CDStorage* storage;

@property CDNotify* notify;

@end

@implementation CDIM

#pragma mark - lifecycle

+ (instancetype)sharedInstance
{
    if(instance==nil){
        instance=[[CDIM alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [AVOSCloud setApplicationId:@"owqomw6mc9jlqcj7xc2p3mdk7h4hqe2at944fzt0zb8jholj"
                          clientKey:@"q9bmfdqt5926m2vgm54lu8ydwxz349448oo1fyu154b0izuw"];
        
        _imClient=[[AVIMClient alloc] init];
        _imClient.delegate=self;
/* 取消下面的注释，将对 im的 open ，start(create conv),kick,invite 操作签名，更安全
   可以从你的服务器获得签名，这里从云代码获取，需要部署云代码，https://github.com/leancloud/leanchat-cloudcode
*/
        //_imClient.signatureDataSource=self;
        _storage=[CDStorage sharedInstance];
        _notify=[CDNotify sharedInstance];
    }
    return self;
}

-(BOOL)isOpened{
    return _imClient.status==AVIMClientStatusOpened;
}

-(void)openWithClientId:(NSString*)clientId callback:(AVIMBooleanResultBlock)callback{
    _selfId=clientId;
    _selfUser=[self.userDelegate getUserById:_selfId];
    [self.storage setupWithUserId:clientId];
    [_imClient openWithClientId:clientId callback:callback];
}

- (void)closeWithCallback:(AVBooleanResultBlock)callback{
    [_imClient closeWithCallback:callback];
}

#pragma mark - conversation

-(void)fecthConvWithId:(NSString*)convid callback:(AVIMConversationResultBlock)callback{
    AVIMConversationQuery* q=[_imClient conversationQuery];
    [q whereKey:@"objectId" equalTo:convid];
    [q findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        if(error){
            callback(nil,error);
        }else{
            callback([objects objectAtIndex:0],error);
        }
    }];;
}

- (void)fetchConvWithUserId:(NSString *)userId callback:(AVIMConversationResultBlock)callback {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:userId];
    [array addObject:_imClient.clientId];
    AVIMConversationQuery* q=[_imClient conversationQuery];
    [q whereKey:CONV_ATTR_TYPE_KEY equalTo:@(CDConvTypeSingle)];
    [q whereKey:CONV_MEMBERS_KEY containsAllObjectsInArray:array];
    [q findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        if(error){
            callback(nil,error);
        }else{
            if (objects.count > 0) {
                AVIMConversation *conv = [objects objectAtIndex:0];
                callback(conv,nil);
            }else{
                [self createConvWithUserId:userId callback:callback];
            }
        }
    }];
}

-(void)createConvWithUserId:(NSString*)userId callback:(AVIMConversationResultBlock)callback{
    [_imClient createConversationWithName:nil clientIds:@[userId] attributes:@{CONV_TYPE:@(CDConvTypeSingle)} options:AVIMConversationOptionNone callback:callback];
}

-(void)createConvWithUserIds:(NSArray*)userIds callback:(AVIMConversationResultBlock)callback{
    NSString* name=[self nameOfUserIds:userIds];
    [_imClient createConversationWithName:name clientIds:userIds attributes:@{CONV_TYPE:@(CDConvTypeGroup)} options:AVIMConversationOptionNone callback:callback];
}

-(void)findGroupedConvsWithBlock:(AVIMArrayResultBlock)block{
    AVIMConversationQuery* q=[_imClient conversationQuery];
    [q whereKey:@"attr.type" equalTo:@(CDConvTypeGroup)];
    [q whereKey:@"m" containedIn:@[self.selfId]];
    q.limit=1000;
    [q findConversationsWithCallback:block];
}

- (void)updateConv:(AVIMConversation *)conv name:(NSString *)name attrs:(NSDictionary *)attrs callback:(AVIMBooleanResultBlock)callback {
    NSMutableDictionary* dict=[NSMutableDictionary dictionary];
    if(name){
        [dict setObject:name forKey:@"name"];
    }
    if(attrs){
        [dict setObject:attrs forKey:@"attrs"];
    }
    [conv update:dict callback:callback];
}

-(void)fetchConvsWithIds:(NSSet*)convids callback:(AVIMArrayResultBlock)callback{
    if(convids.count>0){
        AVIMConversationQuery* q=[_imClient conversationQuery];
        [q whereKey:@"objectId" containedIn:[convids allObjects]];
        q.limit=1000;  // default limit:10
        [q findConversationsWithCallback:callback];
    }else{
        callback([NSMutableArray array],nil);
    }
}

#pragma mark - query msgs

-(NSArray*)queryMsgsWithConv:(AVIMConversation*)conv msgId:(NSString*)msgId maxTime:(int64_t)time limit:(int)limit error:(NSError**)theError{
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    __block NSArray* result;
    __block NSError* blockError=nil;
    [conv queryMessagesBeforeId:msgId timestamp:time limit:limit callback:^(NSArray *objects, NSError *error) {
        result=objects;
        blockError=error;
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    *theError=blockError;
    if(blockError==nil){
    }
    return result;
}

#pragma mark - send or receive message

-(void)receiveMsg:(AVIMTypedMessage*)msg conv:(AVIMConversation*)conv{
    [_storage insertRoomWithConvid:conv.conversationId];
    [_storage insertMsg:msg];
    [_storage incrementUnreadWithConvid:conv.conversationId];
    [_notify postMsgNotify:msg];
}

#pragma mark - AVIMClientDelegate

- (void)imClientPaused:(AVIMClient *)imClient{
    DLog();
    [_notify postSessionNotify];
}

- (void)imClientResuming:(AVIMClient *)imClient{
    DLog();
    [_notify postSessionNotify];
}

- (void)imClientResumed:(AVIMClient *)imClient{
    DLog();
    [_notify postSessionNotify];
}

#pragma mark - AVIMMessageDelegate

- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    DLog();
}

- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    DLog();
    if(message.messageId){
        [self receiveMsg:message conv:conversation];
    }else{
        DLog(@"Receive Message , but MessageId is nil");
    }
}

- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message{
    if(message!=nil){
        [_storage updateStatus:AVIMMessageStatusDelivered byMsgId:message.messageId];
        [_notify postMsgNotify:message];
    }
    DLog();
}

- (void)conversation:(AVIMConversation *)conversation membersAdded:(NSArray *)clientIds byClientId:(NSString *)clientId{
    DLog();
}

- (void)conversation:(AVIMConversation *)conversation membersRemoved:(NSArray *)clientIds byClientId:(NSString *)clientId{
    DLog();
}

- (void)conversation:(AVIMConversation *)conversation invitedByClientId:(NSString *)clientId{
    DLog();
}

- (void)conversation:(AVIMConversation *)conversation kickedByClientId:(NSString *)clientId{
    DLog();
}


-(id)convSignWithSelfId:(NSString*)selfId convid:(NSString*)convid targetIds:(NSArray*)targetIds action:(NSString*)action{
    NSMutableDictionary* dict=[NSMutableDictionary dictionary];
    [dict setObject:selfId forKey:@"self_id"];
    if(convid){
        [dict setObject:convid forKey:@"convid"];
    }
    if(targetIds){
        [dict setObject:targetIds forKey:@"targetIds"];
    }
    if(action){
        [dict setObject:action forKey:@"action"];
    }
    return [AVCloud callFunction:@"conv_sign" withParameters:dict];
}

-(AVIMSignature*)getAVSignatureWithParams:(NSDictionary*) fields peerIds:(NSArray*)peerIds{
    AVIMSignature* avSignature=[[AVIMSignature alloc] init];
    NSNumber* timestampNum=[fields objectForKey:@"timestamp"];
    long timestamp=[timestampNum longValue];
    NSString* nonce=[fields objectForKey:@"nonce"];
    NSString* signature=[fields objectForKey:@"signature"];

    [avSignature setTimestamp:timestamp];
    [avSignature setNonce:nonce];
    [avSignature setSignature:signature];;
    return avSignature;
}

- (AVIMSignature *)signatureWithClientId:(NSString *)clientId
                          conversationId:(NSString *)conversationId
                                  action:(NSString *)action
                       actionOnClientIds:(NSArray *)clientIds{
    if([action isEqualToString:@"open"] || [action isEqualToString:@"start"]){
        action=nil;
    }
    if([action isEqualToString:@"remove"]){
        action=@"kick";
    }
    if([action isEqualToString:@"add"]){
        action=@"invite";
    }
    NSDictionary* dict=[self convSignWithSelfId:clientId convid:conversationId targetIds:clientIds action:action];
    if(dict!=nil){
        return [self getAVSignatureWithParams:dict peerIds:clientIds];
    }else{
        return nil;
    }
}

#pragma mark - Message Utils

-(NSString*)getMsgTitle:(AVIMTypedMessage*)msg{
    NSString* title;
    AVIMLocationMessage* locationMsg;
    switch (msg.mediaType) {
        case kAVIMMessageMediaTypeText:
            title=[CDEmotionUtils convertWithText:msg.text toEmoji:YES];;
            break;
        case kAVIMMessageMediaTypeAudio:
            title=@"声音";
            break;
        case kAVIMMessageMediaTypeImage:
            title=@"图片";
            break;
        case kAVIMMessageMediaTypeLocation:
            locationMsg=(AVIMLocationMessage*)msg;
            title=locationMsg.text;
            break;
        default:
            break;
    }
    return title;
}

#pragma mark - File Utils

-(NSString*)getFilesPath{
    NSString* appPath=[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filesPath=[appPath stringByAppendingString:@"/files/"];
    NSFileManager *fileMan=[NSFileManager defaultManager];
    NSError *error;
    BOOL isDir=YES;
    if([fileMan fileExistsAtPath:filesPath isDirectory:&isDir]==NO){
        [fileMan createDirectoryAtPath:filesPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(error){
            [NSException raise:@"error when create dir" format:@"error"];
        }
    }
    return filesPath;
}

-(NSString*)getPathByObjectId:(NSString*)objectId{
    return [[self getFilesPath] stringByAppendingFormat:@"%@",objectId];
}

-(NSString*)tmpPath{
    return [[self getFilesPath] stringByAppendingFormat:@"tmp"];
}

#pragma mark - conv utils

-(CDConvType)typeOfConv:(AVIMConversation*)conv{
    CDConvType type=[[conv.attributes objectForKey:CONV_TYPE] intValue];
    return type;
}

-(NSString*)nameOfUserIds:(NSArray*)userIds{
    NSMutableArray* names=[NSMutableArray array];
    for(int i=0;i<userIds.count;i++){
        id<CDUserModel> user=[_userDelegate getUserById:[userIds objectAtIndex:i]];
        [names addObject:user.username];
    }
    return [names componentsJoinedByString:@","];
}

-(NSString*)nameOfConv:(AVIMConversation*)conv{
    if([self typeOfConv:conv]==CDConvTypeSingle){
        NSString* otherId=[self otherIdOfConv:conv];
        id<CDUserModel> other=[_userDelegate getUserById:otherId];
        return other.username;
    }else{
        return conv.name;
    }
}

-(NSString*)otherIdOfConv:(AVIMConversation*)conv{
    NSArray* members=conv.members;
    if(members.count!=2){
        [NSException raise:@"invalid conv" format:nil];
    }
    if([members containsObject:self.selfId]==NO){
        [NSException raise:@"invalid conv" format:nil];
    }
    NSString* otherId;
    if([members[0] isEqualToString:self.selfId]){
        otherId=members[1];
    }else{
        otherId=members[0];
    }
    return otherId;
}

-(NSString*)titleOfConv:(AVIMConversation*)conv{
    if([self typeOfConv:conv]==CDConvTypeSingle){
        return [self nameOfConv:conv];
    }else{
        return [NSString stringWithFormat:@"%@(%ld)",conv.name,(long)conv.members.count];
    }
}

-(NSString*)uuid{
    NSString *chars=@"abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    assert(chars.length==62);
    int len=(int)chars.length;
    NSMutableString* result=[[NSMutableString alloc] init];
    for(int i=0;i<24;i++){
        int p=arc4random_uniform(len);
        NSRange range=NSMakeRange(p, 1);
        [result appendString:[chars substringWithRange:range]];
    }
    return result;
}

@end
