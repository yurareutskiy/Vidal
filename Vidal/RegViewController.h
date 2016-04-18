//
//  RegViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 28/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HSDatePickerViewController.h>
#import "AFNetworking.h"
#import "IMQuickSearch.h"

@interface RegViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *month;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *agree;
@property (strong, nonatomic) IBOutlet UIButton *worker;
@property (nonatomic, strong) NSArray *FilteredResults;

@property (nonatomic, strong) IMQuickSearch *quickSearch;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dictSpec;
@property (strong, nonatomic) NSMutableArray *namesSpec;
@property (strong, nonatomic) IBOutlet UITextField *special;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *passText;
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *surnameText;
@property (strong, nonatomic) IBOutlet UITextField *cityText;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIButton *check1;
@property (strong, nonatomic) IBOutlet UIButton *check2;

- (IBAction)button1:(UIButton *)sender;
- (IBAction)button2:(UIButton *)sender;

- (IBAction)callDatePicker:(UIButton*)sender;
- (IBAction)regButton:(UIButton *)sender;

- (IBAction)backButton:(id)sender;
- (IBAction)getData:(UIBarButtonItem *)sender;

@end
