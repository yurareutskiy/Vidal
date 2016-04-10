//
//  RegViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 28/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "RegViewController.h"

@interface RegViewController ()

@property (nonatomic, strong) Server *serverManager;

@end

@implementation RegViewController {
    HSDatePickerViewController *datePicker;
    UITapGestureRecognizer *singleTap;
    BOOL keyboard;
    CGPoint svos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    datePicker = [[HSDatePickerViewController alloc] init];
    datePicker.delegate = self;
    self.scrollView.delegate = self;
    for (UITextField *textField in self.textFields) {
        textField.delegate = self;
    }
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    svos = self.scrollView.contentOffset;
    datePicker.dateFormatter.dateFormat = @"Y";
    
    self.agree.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.worker.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    self.serverManager = [[Server alloc] init];
    
    [self getSpec];
    
    // Do any additional setup after loading the view.
}

- (void)setUpQuickSearch:(NSMutableArray *)work {
    // Create Filters
    IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:work keys:@[@"description"]];
    self.quickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter]];
}

- (void)filterResults {
    // Asynchronously

    [self.quickSearch asynchronouslyFilterObjectsWithValue:((UITextField *)[self.view viewWithTag:6]).text completion:^(NSArray *filteredResults) {
            [self updateTableViewWithNewResults:filteredResults];
        }];
    
    // Synchronously
    //[self updateTableViewWithNewResults:[self.QuickSearch filteredObjectsWithValue:self.searchTextField.text]];
}

- (void)updateTableViewWithNewResults:(NSArray *)results {
    self.FilteredResults = results;
    [self.tableView reloadData];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.FilteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
    }
    
    // Set Content
    NSString *title, *subtitle;
    title = self.FilteredResults[indexPath.row];
    subtitle = self.FilteredResults[indexPath.row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    // Return Cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ((UITextField *)[self.view viewWithTag:6]).text = self.FilteredResults[indexPath.row];
    self.tableView.hidden = true;
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSInteger i = textField.tag;
    
    if (textField.tag < 4) {
        [[self.view viewWithTag:i+1] becomeFirstResponder];
        i += 1;
    } else if (textField.tag == 6) {
        [textField resignFirstResponder];
        self.tableView.hidden = true;
    }else {
        [[self.view viewWithTag:i] resignFirstResponder];
        [self.scrollView setContentOffset:self.view.frame.origin animated:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
    self.tableView.hidden = false;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = self.scrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:self.scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 300;
    [self.scrollView setContentOffset:pt animated:YES];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    for (UITextField *textField in self.textFields){
        [textField resignFirstResponder];
        [self.scrollView setContentOffset:self.view.frame.origin animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)callDatePicker:(UIButton*)sender {
    
    [self presentViewController:datePicker animated:YES completion:nil];
    
}

- (IBAction)regButton:(UIButton *)sender {
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"revealMenu"];
    [self presentViewController:vc animated:false completion:nil];
    
    [self performSegueWithIdentifier:@"toFullApp" sender:self];
    
}

-(void)hsDatePickerPickedDate:(NSDate *)date {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"Y"];
    NSString *y = [formatter stringFromDate:date];
    [formatter setDateFormat:@"MMMM"];
    NSString *m = [formatter stringFromDate:date];
    [formatter setDateFormat:@"d"];
    NSString *d = [formatter stringFromDate:date];
    
    [self.day setText:[NSString stringWithFormat:@"%@", d]];
    [self.month setText:[NSString stringWithFormat:@"%@", m]];
    [self.year setText:[NSString stringWithFormat:@"%@", y]];
    
    NSLog(@"%ld", (long)components.year);
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    if (!keyboard){
        keyboard = true;
        
        NSInteger tag = 0;
        
        for (UITextField *textField in self.textFields) {
            if (textField.isFirstResponder) {
                tag = textField.tag;
                break;
            }
        }
        
        UIView *thatNeed = [self.view viewWithTag:tag];
        NSLog(@"%f", thatNeed.frame.origin.y);
        [self.scrollView scrollRectToVisible:CGRectMake(thatNeed.frame.origin.x, thatNeed.frame.origin.y, thatNeed.frame.size.width, thatNeed.frame.size.height)  animated:YES];
        NSLog(@"%f", self.scrollView.frame.origin.y);
            
//            [UIView animateWithDuration:0.3 animations:^{
//                self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardSize.height, self.view.frame.size.width, self.view.frame.size.height);
//            }];
        
        
        
    }
}

- (void) getSpec {
    
    self.namesSpec = [NSMutableArray array];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.vidal.ru/api/specialties" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSArray *responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.dictSpec = [[NSMutableArray alloc] initWithArray:responseObject];
        for (NSDictionary *key in self.dictSpec) {
            [self.namesSpec addObject:[key objectForKey:@"doctorName"]];
        }
        [self setUpQuickSearch:self.namesSpec];
        self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}



//-(void)keyboardWillHide:(NSNotification *)notification
//{
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    if (keyboard){
//        keyboard = false;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardSize.height, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }
//}

@end
