//
//  Post.m
//  App.Net Test
//
//  Created by Gayle Dunham on 6/26/13.
//  Copyright (c) 2013 Gayle Dunham. All rights reserved.
//

#import "Post.h"

@implementation Post

- (Post *)initWithUserName:(NSString *)aUserName date:(NSString *)aDateString avatar:(UIImage *)anAvatar message:(NSString *) aMessage
{
    self = [super init];
    
    if (self != nil) {
        self.userName   = aUserName;
        self.avatar     = anAvatar;
        self.message    = aMessage;
        self.datePosted = aDateString;
    }
    
    return self;
}

+ (Post *)postFromUser:(NSString *)aUserName date:(NSString *)aDateString avatar:(UIImage *)anAvatar message:(NSString *) aMessage
{
    return [[Post alloc] initWithUserName:aUserName date:aDateString avatar:anAvatar message:aMessage];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ userName: %@, message: %@",
            [super description], self.userName, self.message];
}

@end
