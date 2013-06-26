//
//  DetailViewController.h
//  App.Net Test
//
//  Created by Gayle Dunham on 6/26/13.
//  Copyright (c) 2013 Gayle Dunham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
