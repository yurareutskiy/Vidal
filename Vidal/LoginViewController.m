//
//  LoginViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 26/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "LoginViewController.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface LoginViewController ()

@end

@implementation LoginViewController {
    NSUserDefaults *ud;
    BOOL isConnectionAvailable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
//    if ([[ud valueForKey:@"reg"] isEqualToString:@"2"]) {
//        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"revealMenu"];
//        [self presentViewController:vc animated:NO completion:nil];
//    }
    
    self.emailInput.delegate = self;
    self.passInput.delegate = self;
    
    self.regButton.layer.borderWidth = 1.0;
    self.regButton.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0].CGColor;
    
    NSString *string = self.lead.text;
    self.lead.numberOfLines = 0;
    self.lead.text = string;
    [self.lead sizeToFit];

    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable || [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        isConnectionAvailable = false;
    } else {
        isConnectionAvailable = true;
    }
    
    if ([ud objectForKey:@"wasExit"] == nil) {
        [self showAlert:@"Внимание!" mess:@"При первом входе в приложение требуется скачать объемное количество информации (30Мб)." check:NO];
    } else {
//        [self showAlert:@"Отсутствует Интернет-соединение" mess:@"Попробуйте зайти позже" check:NO];
    }
    
    if (IS_IPHONE_5) {
        [self.regHeight setConstant:45.0];
        [self.logHeight setConstant:45.0];
    }

    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [ud setObject:@"1" forKey:@"reg"];
    if ([ud objectForKey:@"email_temp"] && [ud objectForKey:@"pass_temp"]) {
        self.emailInput.text = [ud objectForKey:@"email_temp"];
        self.passInput.text = [ud objectForKey:@"pass_temp"];
    }
}


-(void)viewWillDisappear:(BOOL)animated {
    [ud setObject:self.emailInput.text forKey:@"email_temp"];
    [ud setObject:self.passInput.text forKey:@"pass_temp"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -(self.email.frame.origin.y - 10.0);
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (![self NSStringIsValidEmail:self.emailInput.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Неправильный формат логина" message:@"Введите почту" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [self.navigationController popViewControllerAnimated:YES];
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    } else {
        
        NSInteger i = textField.tag;
        
        if (textField.tag == 1) {
            [[self.view viewWithTag:2] becomeFirstResponder];
            i += 1;
        }else {
            [[self.view viewWithTag:i] resignFirstResponder];
            [self login:self];
        }
        return YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.emailInput resignFirstResponder];
        [self.passInput resignFirstResponder];
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registration:(UIButton *)sender {
    
    [ud setObject:@"1" forKey:@"reg"];
    [ud setObject:self.emailInput.text forKey:@"email_temp"];
    [ud setObject:self.passInput.text forKey:@"pass_temp"];
    [self performSegueWithIdentifier:@"toReg" sender:self];
    
}


- (IBAction)login:(id)sender {
    if ([self NSStringIsValidEmail:self.emailInput.text] && ![self.emailInput.text isEqualToString:@""]) {
        if ([self.passInput.text length] >= 6 && [self.passInput.text length] <= 255 && ![self hasRussianCharacters:self.passInput.text]) {
            NSString *email = self.emailInput.text;
            NSString *pass = [self reverse:self.passInput.text];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [manager POST:@"http://www.vidal.ru/api/user/auth" parameters:@{
                                                                            @"username":email,
                                                                            @"password":pass}
                  success:^(AFHTTPRequestOperation * _Nonnull operation, id responseObject) {
                      
                      NSLog(@"%@", responseObject);
                      
                      [ud setObject:[responseObject valueForKey:@"lastName"] forKey:@"surname"];
                      [ud setObject:[responseObject valueForKey:@"firstName"] forKey:@"manName"];
                      [ud setObject:self.emailInput.text forKey:@"email"];
                      [ud setObject:[responseObject valueForKey:@"birthdate"] forKey:@"birthDay"];
                      [ud setObject:[responseObject valueForKey:@"city"] forKey:@"city"];
                      [ud setObject:[responseObject valueForKey:@"primarySpecialty"] forKey:@"spec"];
                      if ([responseObject valueForKey:@""] != nil) {
                          [ud setObject:[responseObject valueForKey:@"secondarySpecialty"] forKey:@"secondarySpecialty"];
                      } else {
                          [ud setObject:@"-" forKey:@"secondarySpecialty"];
                      }                      [ud setObject:[responseObject valueForKey:@"academicDegree"] forKey:@"academicDegree"];
                      [ud setObject:[responseObject valueForKey:@"university"] forKey:@"university"];
                      [ud setObject:[responseObject valueForKey:@"graduateYear"] forKey:@"graduateYear"];
                      
                      [ud setObject:[responseObject valueForKey:@"token"] forKey:@"archToken"];
                      UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"revealMenu"];
                      [self presentViewController:vc animated:true completion:nil];
                      
                  } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                      
                      [self showAlert:@"Ошибка входа" mess:@"Проверьте правильность данных" check:NO];
                  }];

        } else {
            [self showAlert:@"Ошибка ввода данных" mess:@"Пароль не должен содержать русских символов. Длина пароля должна быть от 6 до 255 символов." check:NO];
        }
    } else {
        [self showAlert:@"Ошибка ввода данных" mess:@"Введите валидный Email" check:NO];
    }
}
        
- (BOOL)hasRussianCharacters:(NSString *) input {
            
            NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"];
            return [input rangeOfCharacterFromSet:set].location != NSNotFound;
            
        }

- (void) showAlert:(NSString *)alert  mess:(NSString *)mess check:(BOOL) yep {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alert message:mess preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             if (yep) {
                                 [self.navigationController popViewControllerAnimated:YES];
                             }
                             
                         }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
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

- (IBAction)withoutReg:(UIButton *)sender {
    [ud setObject:@"0" forKey:@"reg"];
    UIStoryboard *stb = [UIStoryboard storyboardWithName:@"LogOutStoryboard" bundle:nil];
    UIViewController *vc = [stb instantiateViewControllerWithIdentifier:@"revealMenu1"];
    [self presentViewController:vc animated:true completion:nil];
    
}

- (IBAction)forget:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.vidal.ru/password-reset"]];
    
}


@end
