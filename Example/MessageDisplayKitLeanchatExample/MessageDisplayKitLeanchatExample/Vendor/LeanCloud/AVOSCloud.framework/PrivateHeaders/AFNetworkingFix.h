//
//  AFNetworkingFix.h
//  paas
//
//  Created by Travis on 13-12-9.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVNetworking.h"

#ifndef _AFNETWORKING_
    #define _AFNETWORKING_
    #define AFMultipartFormData AVMultipartFormData

    typedef AVHTTPClient AFHTTPClient;
    typedef AVHTTPRequestOperation AFHTTPRequestOperation;
    typedef AVJSONRequestOperation AFJSONRequestOperation;
    typedef AVXMLRequestOperation AFXMLRequestOperation;
    typedef AVURLConnectionOperation AFURLConnectionOperation;
    typedef AVPropertyListRequestOperation AFPropertyListRequestOperation;
    typedef AVHTTPClient AFHTTPClient;
    typedef AVImageRequestOperation AFImageRequestOperation;
    typedef AVNetworkActivityIndicatorManager AFNetworkActivityIndicatorManager;
#endif

