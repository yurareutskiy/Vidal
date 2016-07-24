//
//  RegViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 28/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "IMQuickSearch.h"

@interface RegViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@property (assign, nonatomic) BOOL isProfileUpdate;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIPickerView *specialistPickerView;
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *month;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *agree;
@property (strong, nonatomic) IBOutlet UIButton *worker;
@property (nonatomic, strong) NSArray *FilteredResults;

@property (nonatomic, strong) IMQuickSearch *quickSearch;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *tableView2;

@property (strong, nonatomic) NSMutableArray *dictSpec;
@property (strong, nonatomic) NSArray *namesSpec;
@property (strong, nonatomic) NSMutableArray *namesCity;
@property (strong, nonatomic) NSArray *namesUniversities;
@property (strong, nonatomic) NSArray *pickerViewData;
@property (strong, nonatomic) NSArray *namesDegree;
@property (strong, nonatomic) IBOutlet UITextField *special;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *passText;
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *surnameText;
@property (strong, nonatomic) IBOutlet UITextField *cityText;
@property (strong, nonatomic) IBOutlet UITextField *universityText;
@property (strong, nonatomic) IBOutlet UITextField *secondSpecialiteText;
@property (strong, nonatomic) IBOutlet UITextField *yearDegreeText;
@property (strong, nonatomic) IBOutlet UITextField *degreeText;
@property (weak, nonatomic) IBOutlet UITableView *tableSpec;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableSearchTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopConstraint;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIButton *check1;
@property (strong, nonatomic) IBOutlet UIButton *check2;
@property (weak, nonatomic) IBOutlet UIButton *agreementReadButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *updateButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *mainLabel;

- (IBAction)button1:(UIButton *)sender;
- (IBAction)button2:(UIButton *)sender;
- (IBAction)agreementLink:(UIButton *)sender;


- (IBAction)callDatePicker:(UIButton*)sender;
- (IBAction)regButton:(UIButton *)sender;

- (IBAction)backButton:(id)sender;
- (IBAction)getData:(UIBarButtonItem *)sender;

- (IBAction)showPicker:(UIButton *)sender;

- (IBAction)selectYearDegreeAction:(id)sender;
- (IBAction)selectSecondSpecialateAction:(id)sender;
- (IBAction)selectDegreeAction:(id)sender;
- (IBAction)selectUniverAction:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonLabels;

@end
