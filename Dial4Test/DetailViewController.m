//
//  DetailViewController.m
//  Dial4Test
//
//  Created by luan on 16/4/20.
//  Copyright © 2016年 luan. All rights reserved.
//

#import "DetailViewController.h"
#import "Masonry.h"

@interface DetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)NSArray *phoneArray;
@property(assign, nonatomic)NSInteger i;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

-(void) setupContraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(self.view.mas_height);
//        make.width.equalTo(self.view.mas_width);
//        make.height.equalTo(self.view.mas_height).width.offset(-20);
    }];
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]init];
//    self.tableView.backgroundColor= [UIColor redColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.phoneArray = self.detailItem.phoneNumbers;
    self.i = 0;
    
    [self setupContraints];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void)callThisNumber:(NSString*)phoneNum
{
    NSString *url = [NSString stringWithFormat:@"tel:%@", phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *phoneArray = self.detailItem.phoneNumbers;
//    for (CNLabeledValue *labeledValue in phoneArray) {
//        // 2.1.获取电话号码的KEY
//        NSString *phoneLabel = labeledValue.label;
//        // 2.2.获取电话号码
//        CNPhoneNumber *phoneNumer = labeledValue.value;
//        NSString *phoneValue = phoneNumer.stringValue;
//    }
    NSInteger retNum = [phoneArray count] + 2; // add 2 for names
    return retNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DetailsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row < 2)
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    else
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    NSString *title;
    NSString *text;
    switch (indexPath.row)
    {
        case 0:
            title = @"First Name";
            text = _detailItem.givenName;
            break;
        case 1:
            title = @"Last Name";
            text = _detailItem.familyName;
            break;
        default:
            title = @"Phone";
            if ([_phoneArray count] > 0) {
                CNLabeledValue *labeledValue =  _phoneArray[self.i];
                CNPhoneNumber *phoneNumer = labeledValue.value;
                text = phoneNumer.stringValue;
                self.i++;
            }
            break;
    }
    [[cell textLabel] setText:title];
    [[cell detailTextLabel] setText:text];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1)
        [self callThisNumber:[[[tableView cellForRowAtIndexPath:indexPath] detailTextLabel] text]];
}


@end
