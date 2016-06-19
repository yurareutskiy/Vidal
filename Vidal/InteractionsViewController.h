//
//  InteractionsViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import "IMQuickSearch.h"

@interface InteractionsViewController : ModelViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, SWRevealViewControllerDelegate>
@property (nonatomic, strong) IMQuickSearch *quickSearch;
@property (strong, nonatomic) IBOutlet UILabel *info1;
@property (strong, nonatomic) IBOutlet UILabel *info2;
@property (strong, nonatomic) IBOutlet UITextField *input;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *FilteredResults;
@property (nonatomic, strong) NSMutableArray *hello1;
@property (nonatomic, strong) NSMutableArray *hello2;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UITextField *secondInput;
@property (strong, nonatomic) IBOutlet UIView *secondLine;
@property (strong, nonatomic) IBOutlet UILabel *result;
@property (strong, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *lead;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIPickerView *secondLinePicker;

- (IBAction)getData:(UIBarButtonItem *)sender;

@end
