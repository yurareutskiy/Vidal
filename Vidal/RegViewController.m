//
//  RegViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 28/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "RegViewController.h"

typedef enum : NSUInteger {
    PickerViewSelectingNone,
    PickerViewSelectingDate,
    PickerViewSelectingPrimarySpec,
    PickerViewSelectingSecondSpec,
    PickerViewSelectingUniver,
    PickerViewSelectingDegree,
    PickerViewSelectingYearDegree,
} PickerViewSelectingType;

@interface RegViewController ()

@end

@implementation RegViewController {
    
    PickerViewSelectingType selectingType;
    UITapGestureRecognizer *singleTap;
    BOOL keyboard;
    CGPoint svos;
    NSString *monthYeah;
    NSString *job;
    NSString *secondJob;
    NSString *univer;
    NSString *degree;
    NSString *degreeYear;
    NSString *cityCheck;
    BOOL flag1;
    BOOL flag2;
    UITapGestureRecognizer *tap;
    CGFloat kh;
    NSUserDefaults *ud;
    NSMutableDictionary *paramsUpdate;
    CGFloat offset;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isProfileUpdate = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    offset = 0;
    
    monthYeah = @"0";
    job = @"0";
    univer = @"0";
    secondJob = @"0";
    degreeYear = @"0";
    degree = @"0";
    cityCheck = @"0";
    
    self.namesDegree = @[@"Нет", @"Кандидат наук", @"Доктор медицинских наук"];
    
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
    self.universityText.delegate = self;
    self.degreeText.delegate = self;
    self.secondSpecialiteText.delegate = self;
    self.yearDegreeText.delegate = self;
    
    selectingType = PickerViewSelectingNone;

    self.datePicker.hidden = true;
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    self.specialistPickerView.hidden = true;
    [self.specialistPickerView setBackgroundColor:[UIColor whiteColor]];
    self.toolbar.hidden = true;
    
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self.tableView2 setTag:2];
    self.tableView.hidden = true;
    self.tableView2.hidden = true;
    
    if (self.isProfileUpdate) {
        [self.doneButton setHidden:YES];
        [self.updateButton setHidden:NO];
    }
    
    self.year.text = @"1990";
    self.month.text = @"Января";
    self.day.text = @"1";
    
    svos = self.scrollView.contentOffset;
    
    self.agree.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.worker.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.agreementReadButton addTarget:self action:@selector(agreementLink:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getDataFromVidal:@"universities"];
    [self getDataFromVidal:@"specialties"];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEver)];
    [self.scrollView addGestureRecognizer:tap];
    
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.backView addGestureRecognizer:tapRecognizer];
    
    for (UILabel *name in self.nameLabels) {
        [name setFont:[UIFont systemFontOfSize:14.0]];
    }
    
    for (UIButton *button in self.buttonLabels) {
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    
    if ([ud objectForKey:@"email_temp"]) {
        self.emailText.text = [ud objectForKey:@"email_temp"];
    }
    if ([ud objectForKey:@"pass_temp"]) {
        self.passText.text = [ud objectForKey:@"pass_temp"];
    }
    
    // Do any additional setup after loading the view.
    

}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"%d", self.isProfileUpdate);
    
    if (self.isProfileUpdate) {
        [self configureForProfileUpdating];
    }
    
    [self.tableView.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView2.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView2 setBackgroundColor:[UIColor whiteColor]];
    

}

-(void)viewDidAppear:(BOOL)animated {
    if (self.isProfileUpdate) {
        CGSize size = self.scrollView.contentSize;
        size.height -= 150;
        self.scrollView.contentSize = size;
    }

}

-(void)configureForProfileUpdating {
    paramsUpdate = [NSMutableDictionary dictionaryWithDictionary:@{@"username":[ud objectForKey:@"email"], @"token" : [ud objectForKey:@"archToken"]}];
    
    [self loadExistValueForFields];
    // Hide main title
    [self.mainLabel setText:@"Редактирование профиля"];
    
    // Hide checkboxes and link
    [self.check1 setHidden:YES];
    [self.check2 setHidden:YES];
    [self.agree setHidden:YES];
    [self.worker setHidden:YES];
    [self.agreementReadButton setHidden:YES];
    
    // Hide back button
    [self.backButton setHidden:YES];
    [self.doneButton setTitle:@"Обновить" forState:UIControlStateNormal];
    
    // Change link
    
    [self.emailText setUserInteractionEnabled:NO];
    [self.passText setUserInteractionEnabled:NO];
}

-(void)loadExistValueForFields {
    NSString *surname = [ud valueForKey:@"surname"];
    NSString *name = [ud valueForKey:@"manName"];
    NSString *email = [ud valueForKey:@"email"];
    NSString *bd = [ud valueForKey:@"birthDay"];
    NSString *city = [ud valueForKey:@"city"];
    NSString *spec = [ud valueForKey:@"spec"];
    NSString *univer = [ud valueForKey:@"university"];
    NSString *degree = [ud valueForKey:@"academicDegree"];
    NSString *yearDegree = [ud valueForKey:@"graduateYear"];
    NSString *secondSpec = [ud valueForKey:@"secondarySpecialty"];
    NSString *password = [ud valueForKey:@"pass_temp"];
    
    [self.nameText setText:surname];
    [self.surnameText setText:name];
    [self.emailText setText:email];
    [self.cityText setText:city];
    [self.special setText:spec];
    [self.universityText setText:univer];
    [self.degreeText setText:degree];
    [self.yearDegreeText setText:yearDegree];
    [self.secondSpecialiteText setText:secondSpec];
    [self.passText setText:password];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM.dd.yyyy"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:gmt];
    NSDate *date = [formatter dateFromString:bd];
    [self.datePicker setDate:date];
    
    NSArray *bdParts = [bd componentsSeparatedByString:@"."];
    if ([bdParts count] == 3) {
        [self.day setText:bdParts[0]];
        [self.year setText:bdParts[2]];
        NSString *monthName;
        if ([bdParts[1] isEqualToString:@"01"]) {
            monthName = @"Января";
        } else if ([bdParts[1] isEqualToString:@"02"]) {
            monthName = @"Февраля";
        } else if ([bdParts[1] isEqualToString:@"03"]) {
            monthName = @"Марта";
        } else if ([bdParts[1] isEqualToString:@"04"]) {
            monthName = @"Апреля";
        } else if ([bdParts[1] isEqualToString:@"05"]) {
            monthName = @"Мая";
        } else if ([bdParts[1] isEqualToString:@"06"]) {
            monthName = @"Июня";
        } else if ([bdParts[1] isEqualToString:@"07"]) {
            monthName = @"Июля";
        } else if ([bdParts[1] isEqualToString:@"08"]) {
            monthName = @"Августа";
        } else if ([bdParts[1] isEqualToString:@"09"]) {
            monthName = @"Сентября";
        } else if ([bdParts[1] isEqualToString:@"10"]) {
            monthName = @"Октября";
        } else if ([bdParts[1] isEqualToString:@"11"]) {
            monthName = @"Ноября";
        } else if ([bdParts[1] isEqualToString:@"12"]) {
            monthName = @"Декабря";
        }
        monthYeah = monthName;
        [self.month setText:monthName];
    }

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.namesCity.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
        }
    
        NSString *title;
        title = self.namesCity[indexPath.row];
        cell.textLabel.text = title;

        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.cityText.text = self.namesCity[indexPath.row];
    self.tableView2.hidden = true;
    cityCheck = self.namesCity[indexPath.row];
//        [self hideEver];
    [self.cityText resignFirstResponder];
    [self.scrollView addGestureRecognizer:tap];
    self.special.userInteractionEnabled = YES;
    self.special.enabled = YES;
    [paramsUpdate setObject:cityCheck forKey:@"profile[city]"];
    
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
            [self hideEver];
            [textField resignFirstResponder];
            [[self.view viewWithTag:i+1] becomeFirstResponder];
//            [self.scrollView setContentOffset:self.view.frame.origin animated:YES];
            [self.scrollView addGestureRecognizer:tap];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 4) {
        self.namesCity = [NSMutableArray array];
//        self.special.userInteractionEnabled = NO;
//        self.special.enabled = NO;
        [self.tableView2 reloadData];
        self.cityText.text = @"";
        [self.scrollView removeGestureRecognizer:tap];
        self.tableView2.hidden = false;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
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
    if (textField.tag == 3 || textField.tag == 4) {
        svos = self.scrollView.contentOffset;
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.scrollView];
        pt = rc.origin;
        pt.x = self.scrollView.contentOffset.x;
        pt.y -= 200;
//        } else {
//            if (self.view.frame.size.height == 736) {
//                pt.y -= 200;
//            } else {
//                pt.y -= 180;
//            }
//        }
//        } else if (textField.tag == 6) {
//            pt.y = 0;
//        }
        [self.scrollView setContentOffset:pt animated:YES];
    }
    
    if (textField.tag != 5) {
        self.tableView.hidden = true;
    }
    
    if (textField.tag != 4) {
        self.tableView2.hidden = true;
    } else {
        [self.scrollView removeGestureRecognizer:tap];
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


- (IBAction)regButton:(UIButton *)sender {
    
    [self.indicator setHidden:NO];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *email = self.emailText.text;
    NSString *pass = [self reverse:self.passText.text];
    NSString *name = self.nameText.text;
    NSString *surname = self.surnameText.text;
    NSString *city = self.cityText.text;
    
    NSLog(@"%@ %@ %@ %@ %@", self.day.text, monthYeah, self.year.text, city, job);
    
    if ([self.universityText.text isEqualToString:@""]) {
        [self showAlert:@"Ошибка в данных" mess:@"Укажите учебное заведение" check:NO];
        return;
    }

    if ([self.yearDegreeText.text isEqualToString:@""]) {
        [self showAlert:@"Ошибка в данных" mess:@"Укажите дату окончания учебы" check:NO];
        return;
    }
    
    if ([self.degreeText.text isEqualToString:@""]) {
        [self showAlert:@"Ошибка в данных" mess:@"Укажите свою ученную степень" check:NO];
        return;
    }
    
    if ([self NSStringIsValidEmail:self.emailText.text] && ![self.emailText.text isEqualToString:@""]) {
        if ([self.passText.text length] >= 6 && [self.passText.text length] <= 255 && ![self hasRussianCharacters:self.passText.text]) {
            if (![self.surnameText.text isEqualToString:@""]) {
                if (![self.nameText.text isEqualToString:@""]) {
                    if (![monthYeah isEqualToString:@"0"] || self.isProfileUpdate) {
                        if (![cityCheck isEqualToString:@"0"] || [city length] > 0) {
                            if (job != 0) {
                                if ((flag1 && flag2) || self.isProfileUpdate) {

                                    
                                    } else if (!flag1) {
                                        [self showAlert:@"Ошибка в данных" mess:@"Пожалуйста, подтвердите, что вы являетесь работником здравоохранения" check:NO];
                                        return;
                                    } else {
                                        [self showAlert:@"Ошибка в данных" mess:@"Пожалуйста, подтвердите, что вы согласны с пользовательским соглашением" check:NO];
                                        return;
                                    }
                                }
                             else {
                                [self showAlert:@"Ошибка в данных" mess:@"Укажите специальность из списка" check:NO];
                                 return;
                            }
                        } else {
                            [self showAlert:@"Ошибка ввода данных" mess:@"Укажите город из списка" check:NO];
                            return;
                        }
                    } else {
                        [self showAlert:@"Ошибка ввода данных" mess:@"Укажите дату рождения" check:NO];
                        return;
                    }
                } else {
                    [self showAlert:@"Ошибка ввода данных" mess:@"Укажите имя" check:NO];
                    return;
                }
            } else {
                [self showAlert:@"Ошибка ввода данных" mess:@"Укажите фамилию" check:NO];
                return;
            }
        } else {
            [self showAlert:@"Ошибка ввода данных" mess:@"Пароль не должен содержать русских символов. Длина пароля должна быть от 6 до 255 символов." check:NO];
            return;
        }
            } else {
        [self showAlert:@"Ошибка ввода данных" mess:@"Введите валидный Email" check:NO];
        return;
    }
    
    if ([monthYeah length] > 2) {
        [self selectingDate];
    }
    
    NSMutableDictionary *parametrs = [NSMutableDictionary dictionaryWithDictionary:@{@"register[username]":email,
                                                                                     @"register[password]":pass,
                                                                                     @"register[firstName]":name,
                                                                                     @"register[lastName]":surname,
                                                                                     @"register[birthdate][day]":self.day.text,
                                                                                     @"register[birthdate][month]":monthYeah,
                                                                                     @"register[birthdate][year]":self.year.text,
                                                                                     @"register[city]":city,
                                                                                     @"register[primarySpecialty]":job,
                                                                                     @"register[graduateYear]":degreeYear,
                                                                                     @"register[academicDegree]":degree,
                                                                                     @"register[university]":univer}];
    if (secondJob != nil) {
        [parametrs setObject: secondJob forKey:@"register[secondarySpecialty]"];
    }
    
    if (self.isProfileUpdate) {
        
        
        
        [paramsUpdate setObject:self.nameText.text forKey:@"profile[firstName]"];
        [paramsUpdate setObject:self.surnameText.text forKey:@"profile[lastName]"];
        if ([[paramsUpdate allKeys] containsObject:@"profile[city]"] == NO) {
            [paramsUpdate setObject:[ud objectForKey:@"city"] forKey:@"profile[city]"];
        }
        if ([[paramsUpdate allKeys] containsObject:@"profile[primarySpecialty]"] == NO) {
            for (NSDictionary *spec in self.namesSpec) {
                if ([[spec objectForKey:@"title"] isEqualToString:[ud objectForKey:@"spec"]]) {
                    [paramsUpdate setObject:[spec objectForKey:@"id"] forKey:@"profile[primarySpecialty]"];
                    break;
                }
            }
        }
        if ([[paramsUpdate allKeys] containsObject:@"profile[secondarySpecialty]"] == NO && [ud objectForKey:@"secondarySpecialty"]) {
            for (NSDictionary *spec in self.namesSpec) {
                if ([[spec objectForKey:@"doctorName"] isEqualToString:[ud objectForKey:@"secondarySpecialty"]]) {
                    [paramsUpdate setObject:[spec objectForKey:@"id"] forKey:@"profile[secondarySpecialty]"];
                    break;
                }
            }
        }
        if ([[paramsUpdate allKeys] containsObject:@"profile[university]"] == NO && [ud objectForKey:@"university"]) {
            for (NSDictionary *spec in self.namesUniversities) {
                if ([[spec objectForKey:@"title"] isEqualToString:[ud objectForKey:@"university"]]) {
                    [paramsUpdate setObject:[spec objectForKey:@"id"] forKey:@"profile[university]"];
                    break;
                }
            }
        }
        if ([[paramsUpdate allKeys] containsObject:@"profile[graduateYear]"] == NO && [ud objectForKey:@"graduateYear"]) {
            [paramsUpdate setObject:[ud objectForKey:@"graduateYear"] forKey:@"profile[graduateYear]"];
        }
        if ([[paramsUpdate allKeys] containsObject:@"profile[academicDegree]"] == NO && [ud objectForKey:@"academicDegree"]) {
            [paramsUpdate setObject:[ud objectForKey:@"academicDegree"] forKey:@"profile[academicDegree]"];
        }
        
        
        NSLog(@"%@", paramsUpdate);
        
        [manager POST:@"http://www.vidal.ru/api/user/edit" parameters: paramsUpdate
         
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  [self.indicator setHidden:YES];
                  NSLog(@"Responce is :%@",responseObject);
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Ваш профиль успешно был отредактирован" preferredStyle:UIAlertControllerStyleAlert];
                  
                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }];
                  [alertController addAction:ok];
                  
                  [self presentViewController:alertController animated:YES completion:nil];
                  
              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                  [self.indicator setHidden:YES];
                  NSLog(@"%@", [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]  encoding:NSUTF8StringEncoding]);
                  NSError *errorJson;
                  NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableContainers error:&errorJson];
                  NSString *msgString = [NSMutableString stringWithString:@""];
                  for (NSString *partMessage in [dictResponse allValues]) {
                      msgString = [[msgString stringByAppendingString:partMessage] stringByAppendingString:@"\n"];
                  }
//                  [self showAlert:@"Ошибка" mess:@"Проверьте введенные данные" check:NO];
                  [self showAlert:@"Ошибка" mess:msgString check:NO];
              }];
    } else {
        [manager POST:@"http://www.vidal.ru/api/user/add" parameters: parametrs
         
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  [self.indicator setHidden:YES];
                  NSLog(@"Responce is :%@",responseObject);
                  [ud setObject:self.emailText.text forKey:@"email_temp"];
                  [ud setObject:self.passText.text forKey:@"pass_temp"];
                  [self showAlert:@"Мы выслали вам письмо" mess:@"Подтвердите регистрацию" check:YES];
                  [ud setObject:@"1" forKey:@"reg"];
              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                  [self.indicator setHidden:YES];
                  NSLog(@"%@", error);
                  [self showAlert:@"Ошибка" mess:@"Проверьте введенные данные" check:NO];
              }];
    }
    
    
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

    NSLog(@"%@", [ud valueForKey:@"reg"]);
    if ([[ud valueForKey:@"reg"] isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([[ud valueForKey:@"reg"] isEqualToString:@"0"]) {
        [self performSegueWithIdentifier:@"back" sender:self];
    }
    
}

#pragma mark - Picker View Select

- (IBAction)getData:(UIBarButtonItem *)sender {
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + offset)];
    
    self.datePicker.hidden = true;
    self.toolbar.hidden = true;

    switch (selectingType) {
        case PickerViewSelectingUniver:
            [self selectingData:univer];
            self.universityText.text = [self.pickerViewData[[self.specialistPickerView selectedRowInComponent:0]] objectForKey:@"title"];
            [paramsUpdate setObject:univer forKey:@"profile[university]"];
            break;
        case PickerViewSelectingDate:
            [self selectingDate];
            break;
        case PickerViewSelectingPrimarySpec:
            [self selectingData:job];
            self.special.text = [self.pickerViewData[[self.specialistPickerView selectedRowInComponent:0]] objectForKey:@"doctorName"];
            [paramsUpdate setObject:job forKey:@"profile[primarySpecialty]"];
            break;
        case PickerViewSelectingSecondSpec:
            [self selectingData:secondJob];
            self.secondSpecialiteText.text = [self.pickerViewData[[self.specialistPickerView selectedRowInComponent:0]] objectForKey:@"doctorName"];
            [paramsUpdate setObject:secondJob forKey:@"profile[secondarySpecialty]"];
            break;
        case PickerViewSelectingDegree:
            [self selectingDegree];
            break;
        case PickerViewSelectingYearDegree:
            [self selectingDegreeYear];
            break;
        default:
            break;
    }
    
    [self hideEver];
    [self.scrollView addGestureRecognizer:tap];
    
}

- (void)selectingDate {
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
    [paramsUpdate setObject:self.year.text forKey:@"profile[birthdate][year]"];
    [paramsUpdate setObject:self.day.text forKey:@"profile[birthdate][day]"];
    [paramsUpdate setObject:monthYeah forKey:@"profile[birthdate][month]"];
    NSLog(@"%@", monthYeah);
}

- (void)selectingDegree {
    NSString *degreeText = self.degreeText.text;
    
    degree = self.namesDegree[[self.specialistPickerView selectedRowInComponent:0]];
    self.degreeText.text = degree;
    [paramsUpdate setObject:degree forKey:@"profile[academicDegree]"];
}

- (void)selectingDegreeYear {
    degreeYear = self.pickerViewData[[self.specialistPickerView selectedRowInComponent:0]];
    self.yearDegreeText.text = degreeYear;
    [paramsUpdate setObject:degreeYear forKey:@"profile[graduateYear]"];

}


- (void)selectingData:(NSString*)targetProperty {
    NSDictionary *object = self.pickerViewData[[self.specialistPickerView selectedRowInComponent:0]];
    targetProperty = [object objectForKey:@"id"];
    if (selectingType == PickerViewSelectingUniver) {
        univer = targetProperty;
    } else if (selectingType == PickerViewSelectingPrimarySpec) {
        job = targetProperty;
    } else if (selectingType == PickerViewSelectingSecondSpec) {
        secondJob = targetProperty;
    }
    NSLog(@"%@", targetProperty);
}

#pragma mark - Picker View Others



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

- (void)getDataFromVidal:(NSString*)type {
    __block NSMutableArray *dataArray = [NSMutableArray array];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[@"http://www.vidal.ru/api/" stringByAppendingString:type] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSArray *responseObject) {
        
        NSArray *dict = [[NSArray alloc] initWithArray:responseObject];
        NSLog(@"%@", dict);

        if ([type isEqualToString:@"specialties"]) {
            self.namesSpec = [responseObject sortedArrayUsingComparator:^(NSDictionary *item1, NSDictionary *item2) {
                NSString *age1 = [item1 objectForKey:@"doctorName"];
                NSString *age2 = [item2 objectForKey:@"doctorName"];
                return [age1 compare:age2 options:NSCaseInsensitiveSearch];
            }];
        } else if ([type isEqualToString:@"universities"]) {
            self.namesUniversities = [responseObject sortedArrayUsingComparator:^(NSDictionary *item1, NSDictionary *item2) {
                NSString *age1 = [item1 objectForKey:@"title"];
                NSString *age2 = [item2 objectForKey:@"title"];
                return [age1 compare:age2 options:NSCaseInsensitiveSearch];
            }];
        }

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
        self.tableView2.hidden = true;
        self.specialistPickerView.hidden = true;
        self.toolbar.hidden = true;
        self.special.userInteractionEnabled = YES;
        self.special.enabled = YES;

        
        svos = self.scrollView.contentOffset;
        CGPoint pt;
        pt.x = svos.x;
        pt.y = 0;
//        [self.scrollView setContentOffset:pt animated:YES];
    }];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerViewData count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *returnValue = @"";
    if (selectingType == PickerViewSelectingUniver || selectingType == PickerViewSelectingPrimarySpec || selectingType == PickerViewSelectingSecondSpec) {
        NSDictionary *object = self.pickerViewData[row];
        NSString *key = @"title";
        if ([[object allKeys] containsObject:@"doctorName"]) {
            key = @"doctorName";
        }
        returnValue = [object objectForKey:key];
    } else if (selectingType == PickerViewSelectingYearDegree || selectingType == PickerViewSelectingDegree) {
        returnValue = self.pickerViewData[row];
    }

    return returnValue;
//    return [NSString stringWithFormat:@"%d", row];
}

- (IBAction)agreementLink:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://vidal.ru/eula"]];
}

#pragma mark - Actions


- (IBAction)callDatePicker:(UIButton*)sender {
    selectingType = PickerViewSelectingDate;
    [self showPickerView:self.datePicker WithButton:sender];
}

- (IBAction)selectYearDegreeAction:(id)sender {
    selectingType = PickerViewSelectingYearDegree;
    NSMutableArray *dateArray = [NSMutableArray array];
    for (NSInteger i = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]]; i >= 1900; i--) {
        [dateArray addObject:[NSString stringWithFormat:@"%lu", i]];
    }
    self.pickerViewData = dateArray;
    [self showPickerView:self.specialistPickerView WithButton:sender];
    NSString *yearDegree = self.yearDegreeText.text;
    for (int i = 0; i < [self.pickerViewData count]; i++) {
        NSString *tempDict = self.pickerViewData[i];
        if ([tempDict isEqual:yearDegree]) {
            [self.specialistPickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }

}

- (IBAction)selectSecondSpecialateAction:(id)sender {
    selectingType = PickerViewSelectingSecondSpec;
    self.pickerViewData = self.namesSpec;
    [self showPickerView:self.specialistPickerView WithButton:sender];
    NSString *secondSpecialist = self.secondSpecialiteText.text;
    for (int i = 0; i < [self.pickerViewData count]; i++) {
        NSDictionary *tempDict = self.pickerViewData[i];
        if ([[tempDict objectForKey:@"title"] isEqual:secondSpecialist]) {
            [self.specialistPickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
}

- (IBAction)selectDegreeAction:(id)sender {
    selectingType = PickerViewSelectingDegree;
    self.pickerViewData = self.namesDegree;
    [self showPickerView:self.specialistPickerView WithButton:sender];
    NSString *degree = self.degreeText.text;
    for (int i = 0; i < [self.pickerViewData count]; i++) {
        NSString *tempDict = self.pickerViewData[i];
        if ([tempDict isEqual:degree]) {
            [self.specialistPickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
}


- (IBAction)showPicker:(UIButton *)sender {
    selectingType = PickerViewSelectingPrimarySpec;
    self.pickerViewData = self.namesSpec;
    [self showPickerView:self.specialistPickerView WithButton:sender];
    NSString *specialist = self.special.text;
    for (int i = 0; i < [self.pickerViewData count]; i++) {
        NSDictionary *tempDict = self.pickerViewData[i];
        if ([[tempDict objectForKey:@"title"] isEqual:specialist]) {
            [self.specialistPickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
}

- (IBAction)selectUniverAction:(id)sender {
    selectingType = PickerViewSelectingUniver;
    self.pickerViewData = self.namesUniversities;
    [self showPickerView:self.specialistPickerView WithButton:sender];
    NSString *university = self.universityText.text;
    for (int i = 0; i < [self.pickerViewData count]; i++) {
        NSDictionary *tempDict = self.pickerViewData[i];
        if ([[tempDict objectForKey:@"title"] isEqual:university]) {
            [self.specialistPickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
}




- (void)showPickerView:(UIView*)picker WithButton:(UIView*)sender {
    [self hideEver];
    [self.specialistPickerView selectRow:0 inComponent:0 animated:NO];
    picker.hidden = false;
    self.toolbar.hidden = false;
    if ([picker isKindOfClass:[UIPickerView class]]) {
        [(UIPickerView*)picker reloadComponent:0];
    }
    [self fieldIsVisibleWithRect:sender.frame];
}


#pragma mark - ScrollView calculates

- (void)fieldIsVisibleWithRect:(CGRect)targetField {
    static const NSInteger pickerViewHeight = 256;
    CGPoint currentOffset = self.scrollView.contentOffset;
    const NSInteger screenHeight = self.view.frame.size.height;
    const NSInteger visibleHeight = screenHeight - pickerViewHeight;
    CGRect visibleRect = CGRectMake(0, currentOffset.y, self.view.frame.size.height, visibleHeight);
    if (CGRectContainsRect(visibleRect, targetField) == NO) {
        offset = visibleRect.origin.y + visibleHeight - targetField.origin.y - targetField.size.height - 30;
        if (offset > self.scrollView.contentOffset.y) {
            offset = 0;
            return;
        }
        currentOffset.y -= offset;
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = currentOffset;
        }];
    }
}


@end












