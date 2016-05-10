//
//  DetailViewController.h
//  Dial4Test
//
//  Created by luan on 16/4/20.
//  Copyright © 2016年 luan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) CNContact *detailItem;

@end

