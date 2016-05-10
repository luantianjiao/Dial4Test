//
//  MasterViewController.m
//  Dial4Test
//
//  Created by luan on 16/4/20.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "searchController.h"

@interface MasterViewController () <UIAlertViewDelegate>

@property (strong,nonatomic) NSMutableArray *objects;
@property UISearchController *searchController;

@end

@implementation MasterViewController

-(void)doCallDisplayBtn:(id)sender
{
    NSString *bbiTitle = @"Display";
    
    if (nil != sender && [[sender title] compare:@"Display"] == NSOrderedSame)
        bbiTitle = @"Call";
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:bbiTitle style:UIBarButtonItemStylePlain target:self action:@selector(doCallDisplayBtn:)];
    self.navigationItem.leftBarButtonItem = bbi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Dial4"];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self doCallDisplayBtn:nil];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    searchController *resultsController = [[searchController alloc]initWithNames:self.objects];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:resultsController];
    UISearchBar *searchBar =  self.searchController.searchBar;
//    searchBar.scopeButtonTitles = @[@"All",@"Short",@"Long"];
    searchBar.placeholder = @"Enter a searh term";
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
    self.searchController.searchResultsUpdater = resultsController;
}

-(NSMutableArray *)objects{
    if (!_objects)
    {
        _objects = [[NSMutableArray alloc] init];
        
        // 1.获取授权状态
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        // 2.判断授权状态,如果不是已经授权,则直接返回
        if (status != CNAuthorizationStatusAuthorized) return nil;
        // 3.创建通信录对象
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        // 4.创建获取通信录的请求对象
        // 4.1.拿到所有打算获取的属性对应的key
        NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
        // 4.2.创建CNContactFetchRequest对象
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];

        [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            [_objects addObject:contact];
        }];
    }
    return _objects;
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

-(bool)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CNContact *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

-(NSString*)personDisplayText:(CNContact *)person
{
    //	ABRecordRef person = [[myContacts objectAtIndex:rowIndex] retain];
    
    NSString *firstName = person.givenName;
    NSString *lastName = person.familyName;
    
    NSString *fullName = nil;
    if (firstName || lastName)
    {
        fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    }
    return fullName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    CNContact *object = self.objects[indexPath.row];
    cell.textLabel.text = [self personDisplayText:object];
    
    NSData *d = object.imageData;
    if (nil != d)
    {
        UIImage *i = [UIImage imageWithData:d];
        [[cell imageView] setImage:i];
    }
    else
        [[cell imageView] setImage:nil];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)handleRowSelection:(int)rowIndex
{
    CNContact *object = self.objects[rowIndex];
    NSArray *phoneArray = object.phoneNumbers;
    
    if ([phoneArray count] == 1) {
//        [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:@"12344312321"]]
        CNLabeledValue *labelValue = phoneArray[0];
        CNPhoneNumber *phoneNumber = labelValue.value;
        NSString *phoneValue = phoneNumber.stringValue;
        [self callThisNumber:phoneValue];
        
    }else if([phoneArray count] > 1){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Pick A Number"
                                                     message:@"Which number would you like to call?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
        for (CNLabeledValue *labeledValue in phoneArray) {
            // 2.1.获取电话号码的KEY
            NSString *phoneLabel = labeledValue.label;
            // 2.2.获取电话号码
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
            
            [av addButtonWithTitle:phoneValue];
        }
        [av show];

    }
}

-(void)callThisNumber:(NSString*)phoneNum
{
    NSString *url = [NSString stringWithFormat:@"tel:%@", phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0)
        [self callThisNumber:[alertView buttonTitleAtIndex:buttonIndex]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.navigationItem.leftBarButtonItem.title compare:@"Call"] == NSOrderedSame) {
        [self handleRowSelection:(int)indexPath.row];
    }else{
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}



@end
