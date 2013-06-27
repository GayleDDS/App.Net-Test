//
//  AppDotNetSocialNetwork.m
//  App.Net Test
//
//  Created by Gayle Dunham on 6/26/13.
//  Copyright (c) 2013 Gayle Dunham. All rights reserved.
//

#import "AppDotNetSocialNetwork.h"
#import "Post.h"

static NSString * const DataSourceURL = @"https://alpha-api.app.net/stream/0/posts/stream/global";

@implementation AppDotNetSocialNetwork

+ (void)downloadLatestPostsWithCompletionHandler:(void (^)(NSMutableArray *newPosts))completionHandler
{
    dispatch_queue_t postDownloadQ = dispatch_queue_create("App.Net downloader", NULL);
    dispatch_async(postDownloadQ, ^{
        NSMutableArray *newPosts = [AppDotNetSocialNetwork _backgroundDownloader];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(newPosts);
        });
    });
}

+ (NSMutableArray *)_backgroundDownloader
{
    NSURL *url = [NSURL URLWithString:DataSourceURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    if (error) {
    
        NSString *messageString = [NSString stringWithFormat:@"%@. %@",
                                   error.localizedDescription, error.localizedFailureReason];
        NSString *title         = NSLocalizedString(@"Error_Alert_Title", @"Title for the data parser error alert view");
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:messageString
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];

        return nil;
    }
    
    NSArray *rawPosts = [allDataDictionary objectForKey:@"data"];
    NSMutableArray *posts = [NSMutableArray arrayWithCapacity:rawPosts.count];
    
    for (NSDictionary *rawPost in rawPosts) {
        Post *post = [AppDotNetSocialNetwork _createPostFromRawData:rawPost];
        [posts addObject:post];
    }

    return posts;
}

+ (Post *)_createPostFromRawData:(NSDictionary *)rawData
{
    NSString *message    = [rawData objectForKey:@"text"];
    NSString *datePosted = [rawData objectForKey:@"created_at"];

    NSDictionary *rawUserData = [rawData objectForKey:@"user"];
    
    NSString *userName  = [rawUserData objectForKey:@"username"];
    NSString *avatarURL = [[rawUserData objectForKey:@"avatar_image"] objectForKey:@"url"];
    CGFloat avatarHight = [[[rawUserData objectForKey:@"avatar_image"] objectForKey:@"height"] doubleValue];
    
    NSURL *url   = [NSURL URLWithString:avatarURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // Scale the image down to a uniform 65 points height if needed.
    CGFloat imageScale = (avatarHight > 65) ? avatarHight/65.0 : 1.0;
    // Retina screen images are 2x bigger then non retina. 
    CGFloat retinaScale = [[UIScreen mainScreen] scale];
    
    UIImage *image = [[UIImage alloc] initWithData:data scale:(imageScale * retinaScale)];
    Post *post   = [Post postFromUser:userName date:datePosted avatar:image message:message];
    
    return post;
}

@end




















