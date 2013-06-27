//
//  AppDotNetSocialNetwork.h
//  App.Net Test
//
//  Created by Gayle Dunham on 6/26/13.
//  Copyright (c) 2013 Gayle Dunham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDotNetSocialNetwork : NSObject

+ (void)downloadLatestPostsWithCompletionHandler:(void (^)(NSMutableArray *newPosts))completionHandler;

@end
