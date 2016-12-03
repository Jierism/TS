//
//  CheckNetworkStatus.m
//  天时
//
//  Created by  Jierism on 2016/10/14.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "CheckNetworkStatus.h"

@implementation CheckNetworkStatus

+ (NSInteger)networkStatus
{
    return [Reachability connectedToNetWork];
}

@end
