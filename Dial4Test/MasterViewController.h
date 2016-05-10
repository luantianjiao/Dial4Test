//
//  MasterViewController.h
//  Dial4Test
//
//  Created by luan on 16/4/20.
//  Copyright © 2016年 luan. All rights reserved.
//

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

