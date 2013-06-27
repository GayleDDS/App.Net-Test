//
//  Post.h
//  App.Net Test
//
//  Created by Gayle Dunham on 6/26/13.
//  Copyright (c) 2013 Gayle Dunham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (strong, nonatomic) UIImage  *avatar;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *datePosted;

- (Post *)initWithUserName:(NSString *)aUserName date:(NSString *)aDateString avatar:(UIImage *)anAvatar message:(NSString *)aMessage;
+ (Post *)postFromUser:(NSString *)aUserName date:(NSString *)aDateString avatar:(UIImage *)avatar message:(NSString *)aMessage;

- (NSString *)description;

@end
