//
//  CompanyViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 24/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "CompanyViewController.h"

@interface CompanyViewController ()

@end

@implementation CompanyViewController {
    
    NSUserDefaults *ud;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Компания";
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.nameHid.text = self.name;
    self.countryHid.text = self.country;
    self.addressHid.text = self.address;
    self.emailHid.text = self.email;
    self.phoneHid.text = self.phone;
    self.image.image = self.logo;
    
    NSLog(@"%@", self.name);
    
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

- (IBAction) toListDrugs:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toList" sender:self];
    
}

@end
