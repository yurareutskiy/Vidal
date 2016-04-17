//
//  LoginViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 26/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    NSUserDefaults *ud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    self.emailInput.delegate = self;
    self.passInput.delegate = self;
    
    self.regButton.layer.borderWidth = 1.0;
    self.regButton.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0].CGColor;
    
    NSString *string = self.lead.text;
    self.lead.numberOfLines = 0;
    self.lead.text = string;
    [self.lead sizeToFit];

    // Do any additional setup after loading the view, typically from a nib.
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

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
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
    
    [self performSegueWithIdentifier:@"toReg" sender:self];
    
}

- (IBAction)login:(id)sender {
//    if ([self.emailInput.text isEqualToString:@""] || [self.passInput.text isEqualToString:@""]) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Неправильный данные" message:@"Повторите ввод" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
//                             {
//                                 //Do some thing here
//                                 [self.navigationController popViewControllerAnimated:YES];
//                                 
//                             }];
//        [alertController addAction:ok];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//    } else {

    NSString *email = self.emailInput.text;
    NSLog(@"%@", email);
    NSString *pass = [self reverse:self.passInput.text];
    NSLog(@"%@", pass);
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
        [manager POST:@"http://www.vidal.ru/api/user/auth" parameters:@{
                                                                        @"username":email,
                                                                        @"password":pass}
              success:^(AFHTTPRequestOperation * _Nonnull operation, id responseObject) {
            
            NSLog(@"%@", responseObject);
            [ud setObject:[responseObject valueForKey:@"token"] forKey:@"archToken"];
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"revealMenu"];
            [self presentViewController:vc animated:true completion:nil];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
            NSLog(@"%@", error);
            NSLog(@"%@", error.localizedDescription);
            
            NSLog(@"%@", operation.responseSerializer);
            NSLog(@"%@", operation.responseObject);
            NSLog(@"%@", operation.responseData);
            NSLog(@"%@", operation.responseString);
        }];
    
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
    
    [self performSegueWithIdentifier:@"withoutReg" sender:self];
    
}
@end
