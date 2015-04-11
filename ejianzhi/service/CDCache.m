//
//  CDCacheService.m
//  LeanChat
//
//  Created by lzw on 14/12/3.
//  Copyright (c) 2014年 AVOS. All rights reserved.
//

#import "CDCache.h"
#import "CDUtils.h"
#import "CDService.h"

@implementation CDCache

static NSMutableDictionary *cachedConvs;
static NSMutableDictionary *cachedUsers;
static AVIMConversation* curConv;
static NSArray* friends;
static CDIM* _im;

+(void)initialize{
    [super initialize];
    cachedConvs=[[NSMutableDictionary alloc] init];
    cachedUsers=[[NSMutableDictionary alloc] init];
    _im=[CDIM sharedInstance];
}

#pragma mark - user cache

+ (void)registerUsers:(NSArray*)users{
    for(int i=0;i<users.count;i++){
        [self registerUser:[users objectAtIndex:i]];
    }
}

+(void) registerUser:(AVUser*)user{
    [cachedUsers setObject:user forKey:user.objectId];
}

+(AVUser *)lookupUser:(NSString*)userId{
    return [cachedUsers valueForKey:userId];
}

#pragma mark - group cache

+(AVIMConversation*)lookupConvById:(NSString*)convid{
    return [cachedConvs valueForKey:convid];
}

+(void)registerConv:(AVIMConversation*)conv{
    [cachedConvs setObject:conv forKey:conv.conversationId];
}

+(void)registerConvs:(NSArray*)convs{
    for(AVIMConversation* conv in convs){
        [self registerConv:conv];
    }
}

+(void)cacheConvsWithIds:(NSMutableSet*)convids callback:(AVArrayResultBlock)callback{
    NSMutableSet* uncacheConvids=[[NSMutableSet alloc] init];
    for(NSString * convid in convids){
        if([self lookupConvById:convid]==nil){
            [uncacheConvids addObject:convid];
        }
    }
    [_im fetchConvsWithIds:uncacheConvids callback:^(NSArray *objects, NSError *error) {
        [CDUtils filterError:error callback:^{
            for(AVIMConversation* conv in objects){
                [self registerConv:conv];
            }
            callback(objects,error);
        }];
    }];
}

+(void)cacheUsersWithIds:(NSSet*)userIds callback:(AVArrayResultBlock)callback{
    NSMutableSet* uncachedUserIds=[[NSMutableSet alloc] init];
    for(NSString* userId in userIds){
        if([self lookupUser:userId]==nil){
            [uncachedUserIds addObject:userId];
        }
    }
    if([uncachedUserIds count]>0){
        [CDUserService findUsersByIds:[[NSMutableArray alloc] initWithArray:[uncachedUserIds allObjects]] callback:^(NSArray *objects, NSError *error) {
            if(objects){
                [self registerUsers:objects];
            }
            callback(objects,error);
        }];
    }else{
        callback([[NSMutableArray alloc] init],nil);
    }
}

#pragma mark - current cache group

+(void)setCurConv:(AVIMConversation*)conv{
    curConv=conv;
}

+(AVIMConversation*)getCurConv{
    return curConv;
}

+(void)refreshCurConv:(AVBooleanResultBlock)callback{
    if(curConv!=nil){
        CDIM* im=[CDIM sharedInstance];
        [im fecthConvWithId:curConv.conversationId callback:^(AVIMConversation *conversation, NSError *error) {
            if(error){
                callback(NO,error);
            }else{
                [self setCurConv:conversation];
                [[CDNotify sharedInstance] postConvNotify];
                callback(YES,nil);
            }
        }];
    }else{
        callback(NO,[NSError errorWithDomain:nil code:0 userInfo:@{NSLocalizedDescriptionKey:@"current conv is nil"}]);
    }
}

#pragma mark - friends

+(void)setFriends:(NSArray*)_friends{
    friends=_friends;
}

+(NSArray*)getFriends{
    return friends;
}

#pragma mark - rooms

+(void)cacheAndFillRooms:(NSMutableArray*)rooms callback:(AVBooleanResultBlock)callback{
    NSMutableSet* convids=[NSMutableSet set];
    for(CDRoom* room in rooms){
        [convids addObject:room.convid];
    }
    [CDCache cacheConvsWithIds:convids callback:^(NSArray *objects, NSError *error) {
        if(error){
            callback(NO,error);
        }else{
            for(CDRoom * room in rooms){
                room.conv=[CDCache lookupConvById:room.convid];
                if(room.conv==nil){
                    [NSException raise:@"not found conv" format:nil];
                }
            }
            NSMutableSet* userIds=[NSMutableSet set];
            for(CDRoom* room in rooms){
                if([[CDIM sharedInstance] typeOfConv:room.conv]==CDConvTypeSingle){
                    [userIds addObject:[[CDIM sharedInstance] otherIdOfConv:room.conv]];
                }
            }
            [CDCache cacheUsersWithIds:userIds callback:^(NSArray *objects, NSError *error) {
                if(error){
                    callback(NO,error);
                }else{
                    callback(YES,nil);
                }
            }];
        }
    }];
}

@end
