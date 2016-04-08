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

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.regButton.layer.borderWidth = 1.0;
    self.regButton.layer.borderColor = [UIColor colorWithRed:148.0/255.0 green:0 blue:0 alpha:1.0].CGColor;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registration:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toReg" sender:self];
    
}

- (IBAction)login:(UIButton *)sender {
    
//    AFHTTPRequestSerializer *requestSerializerTry = [AFHTTPRequestSerializer serializer];
//    [requestSerializerTry setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setRequestSerializer:requestSerializerTry];
//    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    [manager setResponseSerializer:responseSerializer];
//    
//    NSDictionary *params = @{@"username":@"avscherbakov@icloud.com", //- email участника (bin@bk.ru)
//                             @"password":@"123456"}; //- его пароль в открытом виде (mySuperPw)
//    
//    [manager POST:@"http://vidal.ru/api/user/add" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"revealMenu"];
    [self presentViewController:vc animated:false completion:nil];
    
}

- (IBAction)withoutReg:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"withoutReg" sender:self];
    
}
@end
