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
    self.addressHid.editable = NO;
    self.addressHid.dataDetectorTypes = UIDataDetectorTypeAll;
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.nameHid.text = self.name;
    self.countryHid.text = self.country;
    self.addressHid.text = self.address;
    if ([self.address containsString:@"Тел.:"]) {
        [self.phoneHid setHidden:YES];
    } else {
        self.phoneHid.text = self.phone;
    }
    if ([self.address containsString:@"E-mail:"]) {
        [self.emailHid setHidden:YES];
    } else {
        self.emailHid.text = self.email;
    }
    
    NSLog(@"%@", self.logo);
    if (self.logo != nil) {
        self.image.image = self.logo;
    } else {
        self.image.image = [UIImage imageNamed:@"company"];
    }
    
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
