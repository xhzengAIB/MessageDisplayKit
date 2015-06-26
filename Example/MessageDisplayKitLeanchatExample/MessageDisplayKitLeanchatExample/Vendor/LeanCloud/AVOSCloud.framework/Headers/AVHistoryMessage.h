//
//  AVHistoryMessage.h
//  AVOS
//
//  Created by Qihe Bian on 10/21/14.
//
//

#import <Foundation/Foundation.h>
#import "AVMessage.h"

@interface AVHistoryMessage : AVMessage
@property(nonatomic, strong)NSString *conversationId;
@end
