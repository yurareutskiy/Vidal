//
//  RegViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 28/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "RegViewController.h"

@interface RegViewController ()

@end

@implementation RegViewController {
    
    UITapGestureRecognizer *singleTap;
    BOOL keyboard;
    CGPoint svos;
    NSString *monthYeah;
    int job;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.delegate = self;
    
    self.special.delegate = self;
    self.emailText.delegate = self;
    self.passText.delegate = self;
    self.surnameText.delegate = self;
    self.nameText.delegate = self;
    self.cityText.delegate = self;
    
    self.datePicker.hidden = true;
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    self.toolbar.hidden = true;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.hidden = true;
    
    svos = self.scrollView.contentOffset;
    
    self.agree.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.worker.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
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

    [self.quickSearch asynchronouslyFilterObjectsWithValue:((UITextField *)[self.view viewWithTag:5]).text completion:^(NSArray *filteredResults) {
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
    
    
    NSLog(@"HELLO %ld %@", (long)indexPath.row, self.FilteredResults[indexPath.row]);
    self.special.text = self.FilteredResults[indexPath.row];
    self.tableView.hidden = true;
    for (NSDictionary *key in self.dictSpec) {
        if ([[key objectForKey:@"doctorName"] isEqualToString:self.FilteredResults[indexPath.row]])
            job = (int)[key objectForKey:@"id"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSInteger i = textField.tag;
    
    if (textField.tag < 5) {
        [[self.view viewWithTag:i+1] becomeFirstResponder];
        i += 1;
    } else if (textField.tag == 5) {
        [textField resignFirstResponder];
        self.tableView.hidden = true;
        [self.scrollView setContentOffset:self.view.frame.origin animated:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 5) {
        [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
        self.tableView.hidden = false;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 5) {
        svos = self.scrollView.contentOffset;
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.scrollView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 180;
        [self.scrollView setContentOffset:pt animated:YES];
    } else if (textField.tag == 3 || textField.tag == 4) {
        svos = self.scrollView.contentOffset;
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.scrollView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 300;
        [self.scrollView setContentOffset:pt animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([[touch.view class] isSubclassOfClass:[UITextField class]]) {
        [touch.view resignFirstResponder];
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

- (IBAction)button1:(UIButton *)sender {
}

- (IBAction)button2:(UIButton *)sender {
}

- (IBAction)callDatePicker:(UIButton*)sender {
    
//    [self presentViewController:datePicker animated:YES completion:nil];
    self.datePicker.hidden = false;
    self.toolbar.hidden = false;
    
}

- (IBAction)regButton:(UIButton *)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *email = self.emailText.text;
    NSString *pass = [self reverse:self.passText.text];
    NSString *name = self.nameText.text;
    NSString *surname = self.surnameText.text;
    NSString *city = self.cityText.text;
    
    [manager POST:@"http://www.vidal.ru/api/user/add" parameters:
     @{@"register[username]":email,
    @"register[password]":pass,
    @"register[firstName]":name,
    @"register[lastName]":surname,
    @"register[birthdate][day]":self.day.text,
    @"register[birthdate][month]":monthYeah,
    @"register[birthdate][year]":self.year.text,
    @"register[city]":city,
    @"register[primarySpecialty]":[NSString stringWithFormat:@"%d", job]}
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              NSLog(@"Responce is :%@",responseObject);
              UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"revealMenu"];
              [self presentViewController:vc animated:false completion:nil];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"revealMenu"];
    [self presentViewController:vc animated:false completion:nil];

//    [self performSegueWithIdentifier:@"toFullApp" sender:self];
    
}

- (NSString *) reverse:(NSString *) input {
    
    NSMutableString *output = [NSMutableString string];
    NSInteger charIndex = [input length];
    while (charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [output appendString:[input substringWithRange:subStrRange]];
    }
    
    NSData *check = [output dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result= [check base64EncodedStringWithOptions:0];
    NSLog(@"%@", result);
    
    return result;
}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)getData:(UIBarButtonItem *)sender {
    
    self.datePicker.hidden = true;
    self.toolbar.hidden = true;
    NSDate *bd = [self.datePicker date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"Y"];
    self.year.text = [formatter stringFromDate:bd];
    [formatter setDateFormat:@"MMMM"];
    self.month.text = [formatter stringFromDate:bd];
    [formatter setDateFormat:@"d"];
    self.day.text = [formatter stringFromDate:bd];
    [formatter setDateFormat:@"M"];
    monthYeah = [formatter stringFromDate:bd];
    NSLog(@"%@", monthYeah);
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    if (!keyboard){
        keyboard = true;
        
        NSInteger tag = 0;
    
        for (UIView *subView in self.view.subviews) {
            if ([subView isFirstResponder]) {
                tag = subView.tag;
                break;
            }
        }
        
        if (tag == 6) {
            UIView *thatNeed = [self.view viewWithTag:tag];
            NSLog(@"%f", thatNeed.frame.origin.y);
            [self.scrollView scrollRectToVisible:CGRectMake(thatNeed.frame.origin.x, thatNeed.frame.origin.y + self.tableView.frame.size.height, thatNeed.frame.size.width, thatNeed.frame.size.height)  animated:YES];
            NSLog(@"%f", self.scrollView.frame.origin.y);
        }
        
    }
}

- (void) getSpec {
    
    self.namesSpec = [NSMutableArray array];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.vidal.ru/api/specialties" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSArray *responseObject) {
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

@end
