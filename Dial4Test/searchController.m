//
//  searchController.m
//  Dial4Test
//
//  Created by luan on 16/4/22.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "searchController.h"

NSString * const SectionsTableIdentifier = @"tableIdentifier";

@interface searchController()

@property(strong,nonatomic)NSArray *objects;
@property(strong,nonatomic)NSMutableArray *filterNumbers;

@end

@implementation searchController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:SectionsTableIdentifier];
}

-(instancetype)initWithNames:(NSArray *)objects{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.objects = objects;
        self.filterNumbers = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.filterNumbers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.filterNumbers[indexPath.row];
    return cell;
}

#pragma mark UISearchResult Delegate
static const NSUInteger longNameSize = 6;
static const NSInteger shortNamesButtonIndex = 1;
static const NSInteger longNamesButtonIndex = 2;

- (void)updateSearchResultsForSearchController:(UISearchController *)controller {
    NSString *searchString = controller.searchBar.text;
    NSInteger buttonIndex = controller.searchBar.selectedScopeButtonIndex;
    [self.filterNumbers removeAllObjects];
    if (searchString.length > 0) {
        for (int i=0; i< [self.objects count]; i++) {
            CNContact *contact = self.objects[i];
            NSArray *phoneArray = contact.phoneNumbers;
            for (int j=0; j < [phoneArray count]; j++) {
                CNLabeledValue *labeledValue =  phoneArray[j];
                CNPhoneNumber *phoneNumer = labeledValue.value;
                NSString *phoneString = phoneNumer.stringValue;
                NSRange range = [phoneString rangeOfString:searchString options:NSCaseInsensitiveSearch];
                if (range.location != NSNotFound) {
                    [self.filterNumbers addObject:phoneString];
                }
            }

        [self.tableView reloadData];
        }
    }
}


@end
