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
    NSString *job;
    NSString *cityCheck;
    BOOL flag1;
    BOOL flag2;
    UITapGestureRecognizer *tap;
    CGFloat kh;
    NSUserDefaults *ud;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    monthYeah = @"0";
    job = @"0";
    cityCheck = @"0";
    
    flag1 = false;
    flag2 = false;
    
    self.scrollView.delegate = self;
    
    self.special.delegate = self;
    self.emailText.delegate = self;
    self.passText.delegate = self;
    self.surnameText.delegate = self;
    self.nameText.delegate = self;
    self.cityText.delegate = self;
    self.specialistPickerView.dataSource = self;
    self.specialistPickerView.delegate = self;
    

    self.datePicker.hidden = true;
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    self.specialistPickerView.hidden = true;
    [self.specialistPickerView setBackgroundColor:[UIColor whiteColor]];
    self.toolbar.hidden = true;
    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.tableView setTag:1];
    
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self.tableView2 setTag:2];
    self.tableView.hidden = true;
    self.tableView2.hidden = true;
    
    
    
    svos = self.scrollView.contentOffset;
    
    self.agree.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.worker.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    
    [self getSpec];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEver)];
    [self.scrollView addGestureRecognizer:tap];
    
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.backView addGestureRecognizer:tapRecognizer];
    
    // Do any additional setup after loading the view.
}

-(void) hideKeyboard {
    [self.view endEditing:YES];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setUpQuickSearch:(NSMutableArray *)work {
    // Create Filters
        IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:work keys:@[@"description"]];
        self.quickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter]];
}

- (void)filterResults {
    [self.quickSearch asynchronouslyFilterObjectsWithValue:((UITextField *)[self.view viewWithTag:5]).text completion:^(NSArray *filteredResults) {
            [self updateTableViewWithNewResults:filteredResults];
        }];
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
//    if (tableView.tag == 1) {
//        return self.FilteredResults.count - 1;
//    } else if (tableView.tag == 2) {
//        NSLog(@"%lu", (unsigned long)self.namesCity.count);
    
        return self.namesCity.count;
    
//    } else {
//        return 1;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (tableView.tag == 1) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
//        }
//    
//        // Set Content
//        NSString *title;
//        title = self.FilteredResults[indexPath.row + 1];
//        cell.textLabel.text = title;
//    
//        // Return Cell
//        return cell;
//    } else if (tableView.tag == 2) {
    
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
        }
        
        // Set Content
        NSString *title;
        title = self.namesCity[indexPath.row];
        cell.textLabel.text = title;
        
        // Return Cell
        return cell;
    
    
//    } else {
//        return nil;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (tableView.tag == 1) {
//        self.special.text = self.FilteredResults[indexPath.row + 1];
//        self.tableView.hidden = true;
//        for (NSDictionary *key in self.dictSpec) {
//            if ([[key objectForKey:@"doctorName"] isEqualToString:self.FilteredResults[indexPath.row + 1]]) {
//                job = [key objectForKey:@"id"];
//                break;
//            }
//        }
//        [self hideEver];
//        [self.scrollView addGestureRecognizer:tap];
//    } else if (tableView.tag == 2) {
    
        self.cityText.text = self.namesCity[indexPath.row];
        self.tableView2.hidden = true;
        cityCheck = self.namesCity[indexPath.row];
        [self hideEver];
        [self.scrollView addGestureRecognizer:tap];
    
//    }
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
        if (textField.tag == 4) {
            self.tableView2.hidden = true;
            [textField resignFirstResponder];
            
//            self.tableView.hidden = true;
            
            [self.scrollView setContentOffset:self.view.frame.origin animated:YES];
            [self.scrollView addGestureRecognizer:tap];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
//    if (textField.tag == 5) {
//        [self.scrollView removeGestureRecognizer:tap];
//        [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
//        self.tableView.hidden = false;
//    } else
    
    if (textField.tag == 4) {
        [self.scrollView removeGestureRecognizer:tap];
        self.tableView2.hidden = false;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField.tag == 5) {
//        [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
//    } else
    
    if (textField.tag == 4) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [manager GET:[NSString stringWithFormat:@"http://www.vidal.ru/ajax/city?term=%@", [self urlencode:self.cityText.text]] parameters:nil
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  NSLog(@"Responce is :%@",responseObject);
                  self.namesCity = [[NSMutableArray alloc] initWithArray:responseObject];
                  [self.tableView2 reloadData];
              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                  NSLog(@"%@", error);
              }];
        
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag >= 3) {
        svos = self.scrollView.contentOffset;
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.scrollView];
        pt = rc.origin;
        pt.x = self.scrollView.contentOffset.x;
        if (self.view.frame.size.height == 736) {
            pt.y -= 200;
        } else {
            pt.y -= 180;
        }
        [self.scrollView setContentOffset:pt animated:YES];
    }
    
    if (textField.tag != 5) {
        self.tableView.hidden = true;
    }
    
    if (textField.tag != 4) {
        self.tableView2.hidden = true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button1:(UIButton *)sender {
    
    if (!flag1) {
        flag1 = true;
        [self.check1 setImage:[UIImage imageNamed:@"checkedSquare"] forState:UIControlStateNormal];
    } else {
        flag1 = false;
        [self.check1 setImage:[UIImage imageNamed:@"uncheckedSquare"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)button2:(UIButton *)sender {
    
    if (!flag2) {
        flag2 = true;
        [self.check2 setImage:[UIImage imageNamed:@"checkedSquare"] forState:UIControlStateNormal];
    } else {
        flag2 = false;
        [self.check2 setImage:[UIImage imageNamed:@"uncheckedSquare"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)callDatePicker:(UIButton*)sender {
    
    [self hideEver];
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
    
    NSLog(@"%@ %@ %@ %@ %@", self.day.text, monthYeah, self.year.text, city, job);
    
    if ([self NSStringIsValidEmail:self.emailText.text] && ![self.emailText.text isEqualToString:@""]) {
        if ([self.passText.text length] >= 6 && [self.passText.text length] <= 255 && ![self hasRussianCharacters:self.passText.text]) {
            if (![self.surnameText.text isEqualToString:@""]) {
                if (![self.nameText.text isEqualToString:@""]) {
                    if (![monthYeah isEqualToString:@"0"]) {
                        if (![cityCheck isEqualToString:@"0"]) {
                            if (job != 0) {
                                if (flag1 && flag2) {
                                    [self showAlert:@"Мы выслали вам письмо" mess:@"Подтвердите регистрацию" check:YES];
                                } else {
                                    [self showAlert:@"Ошибка в данных" mess:@"Поставьте галочки" check:NO];
                                }
                            } else {
                                [self showAlert:@"Ошибка в данных" mess:@"Укажите специальность из списка" check:NO];
                            }
                        } else {
                            [self showAlert:@"Ошибка ввода данных" mess:@"Укажите город из списка" check:NO];
                        }
                    } else {
                        [self showAlert:@"Ошибка ввода данных" mess:@"Укажите дату рождения" check:NO];
                    }
                } else {
                    [self showAlert:@"Ошибка ввода данных" mess:@"Укажите имя" check:NO];
                }
            } else {
                [self showAlert:@"Ошибка ввода данных" mess:@"Укажите фамилию" check:NO];
            }
        } else {
            [self showAlert:@"Ошибка ввода данных" mess:@"Пароль не должен содержать русских символов. Длина пароля должна быть от 6 до 255 символов." check:NO];
        }
    } else {
        [self showAlert:@"Ошибка ввода данных" mess:@"Введите валидный Email" check:NO];
    }

    
    [manager POST:@"http://www.vidal.ru/api/user/add" parameters:
     @{@"register[username]":email,
    @"register[password]":pass,
    @"register[firstName]":name,
    @"register[lastName]":surname,
    @"register[birthdate][day]":self.day.text,
    @"register[birthdate][month]":monthYeah,
    @"register[birthdate][year]":self.year.text,
    @"register[city]":city,
    @"register[primarySpecialty]":job}
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              NSLog(@"Responce is :%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
     
     - (void) showAlert:(NSString *)alert  mess:(NSString *)mess check:(BOOL) yep {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alert message:mess preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             if (yep) {
                                 if ([[ud valueForKey:@"reg"] isEqualToString:@"1"]) {
                                     [self.navigationController popViewControllerAnimated:YES];
                                 } else if ([[ud valueForKey:@"reg"] isEqualToString:@"0"]) {
                                     [self performSegueWithIdentifier:@"toFullApp" sender:self];
                                 }
                             }
                             
                         }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)hasRussianCharacters:(NSString *) input {
    
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"];
    return [input rangeOfCharacterFromSet:set].location != NSNotFound;
    
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
    
    if ([[ud valueForKey:@"reg"] isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([[ud valueForKey:@"reg"] isEqualToString:@"0"]) {
        [self performSegueWithIdentifier:@"back" sender:self];
    }
    
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
    
    
    self.specialistPickerView.hidden = true;
    self.toolbar.hidden = true;
    self.special.text = self.namesSpec[[self.specialistPickerView selectedRowInComponent:0] + 1];
    for (NSDictionary *key in self.dictSpec) {
        if ([[key objectForKey:@"doctorName"] isEqualToString:self.namesSpec[[self.specialistPickerView selectedRowInComponent:0] + 1]]) {
            job = [key objectForKey:@"id"];
            break;
        }
    }
    NSLog(@"%d %@", (int)[self.specialistPickerView selectedRowInComponent:0], self.namesSpec[[self.specialistPickerView selectedRowInComponent:0]]);
    [self hideEver];
    [self.scrollView addGestureRecognizer:tap];
    
}

- (IBAction)showPicker:(UIButton *)sender {
    
    self.specialistPickerView.hidden = false;
    self.toolbar.hidden = false;
    
}

- (NSString *)urlencode:(NSString *) input {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[input UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (void) getSpec {
    
    self.namesSpec = [NSMutableArray array];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.vidal.ru/api/specialties" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSArray *responseObject) {
        
        self.dictSpec = [[NSMutableArray alloc] initWithArray:responseObject];
        NSLog(@"%@", self.dictSpec);
        for (NSDictionary *key in self.dictSpec) {
            [self.namesSpec addObject:[key objectForKey:@"doctorName"]];
        }
        self.namesSpec = [[self.namesSpec sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
//        [self setUpQuickSearch:self.namesSpec];
//        self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
        
        [self.specialistPickerView reloadAllComponents];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}

- (void) hideEver {
    [UIView animateWithDuration:0.3 animations:^{
        [self.emailText resignFirstResponder];
        [self.passText resignFirstResponder];
        [self.surnameText resignFirstResponder];
        [self.nameText resignFirstResponder];
        [self.cityText resignFirstResponder];
        [self.special resignFirstResponder];
        self.tableView.hidden = true;
        self.specialistPickerView.hidden = true;
        self.toolbar.hidden = true;
        
        CGPoint point = self.scrollView.frame.origin;
        if (self.view.frame.size.height == 568) {
            point.y = self.datePicker.frame.origin.y - 240;
        } else {
            point.y = 0;
        }
        [self.scrollView setContentOffset:point animated:YES];

        
    }];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.namesSpec count] - 1;
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.namesSpec[row + 1];
    
}





@end
