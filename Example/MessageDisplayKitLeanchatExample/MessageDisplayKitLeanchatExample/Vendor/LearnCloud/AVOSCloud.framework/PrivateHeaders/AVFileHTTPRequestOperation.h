//
//  AVFileHTTPRequestOperation.h
//  paas
//
//  Created by Summer on 13-5-27.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVJSONRequestOperation.h"

@interface AVFileHTTPRequestOperation : AVJSONRequestOperation
@property (copy) NSString *localPath;
@end
