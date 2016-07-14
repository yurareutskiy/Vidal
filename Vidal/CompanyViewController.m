//
//  CompanyViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 24/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "CompanyViewController.h"
#import "SearchViewController.h"
#import "StringFormatter.h"

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
    
    self.nameHid.text = [StringFormatter clearString:self.name];
    self.countryHid.text = self.country;
    self.addressHid.text = [self addPhonePrefix: self.address];
    if ([self.address containsString:@"Тел."] || [self.address containsString:@"Тел:"]) {
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

- (NSString*)addPhonePrefix:(NSString*)text {
    if ([text containsString:@"+7"]) {
        return text;
    }
    NSArray *keyWords = @[@"Тел.:", @"Факс:", @"Тел./Факс:", @"Tel.:", @"Fax:"];
    for (NSString *key in keyWords) {
        NSRange range = [text rangeOfString:key options:0];
        if (range.length != 0) {
            NSMutableString *mutableString = [NSMutableString stringWithString:text];
            NSInteger index = range.location + range.length;
            [mutableString insertString:@"+7 " atIndex: index];
            text = mutableString;
        }
    }
    return text;
}

- (IBAction) toListDrugs:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toList" sender:self];
    
}

- (void) search {
    SearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [vc setSearchType:SearchCompany];
    [self.navigationController pushViewController:vc animated:NO];
}

@end
