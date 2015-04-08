//
//  AVSignature.h
//  paas
//
//  Created by yang chaozhong on 5/15/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVConstants.h"

@interface AVSignature : NSObject

@property (nonatomic, strong) NSString *signature;
@property (nonatomic) int64_t timestamp;
@property (nonatomic, strong) NSString *nonce;
@property (nonatomic, strong) NSString *action  AVDeprecated("2.6.4");
@property (nonatomic, strong) NSArray *signedPeerIds;
@property (nonatomic, strong) NSError *error;

@end

@protocol AVSignatureDelegate <NSObject>
@optional
- (AVSignature *)signatureForPeerWithPeerId:(NSString *)peerId watchedPeerIds:(NSArray *)watchedPeerIds action:(NSString *)action;
- (AVSignature *)signatureForGroupWithPeerId:(NSString *)peerId groupId:(NSString *)groupId groupPeerIds:(NSArray *)groupPeerIds action:(NSString *)action;


- (AVSignature *)createSignature:(NSString *)peerId watchedPeerIds:(NSArray *)watchedPeerIds AVDeprecated("2.6.4");
- (AVSignature *)createSessionSignature:(NSString *)peerId watchedPeerIds:(NSArray *)watchedPeerIds action:(NSString *)action AVDeprecated("2.6.4");
- (AVSignature *)createGroupSignature:(NSString *)peerId groupPeerIds:(NSArray *)groupPeerIds action:(NSString *)action AVDeprecated("2.6.4");
- (AVSignature *)createGroupSignature:(NSString *)peerId groupId:(NSString *)groupId groupPeerIds:(NSArray *)groupPeerIds action:(NSString *)action AVDeprecated("2.6.4");
@end