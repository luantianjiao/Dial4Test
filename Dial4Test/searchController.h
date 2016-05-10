//
//  searchController.h
//  Dial4Test
//
//  Created by luan on 16/4/22.
//  Copyright © 2016年 luan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface searchController : UITableViewController <UISearchResultsUpdating>

-(instancetype)initWithNames:(NSArray *)objects;

@end
