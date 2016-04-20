//
//  DetailViewController.h
//  Dial4Test
//
//  Created by luan on 16/4/20.
//  Copyright © 2016年 luan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

