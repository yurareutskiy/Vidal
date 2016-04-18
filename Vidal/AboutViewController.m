//
//  AboutViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController {
    NSUserDefaults *ud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    self.navigationItem.title = @"О Такеда";
    
    NSString *string1 = self.takeda.text;
    self.takeda.numberOfLines = 0;
    self.takeda.text = string1;
    [self.takeda sizeToFit];
    
    NSString *string2 = self.drug.text;
    self.drug.numberOfLines = 0;
    self.drug.text = string2;
    [self.drug sizeToFit];
    
    [super setLabel:@"О Такеда"];
    
    // Do any additional setup after loading the view.
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

- (IBAction)toList:(UIButton *)sender {
    
    [ud setObject:@"6057" forKey:@"comp"];
    [self performSegueWithIdentifier:@"toList" sender:self];
    
}
@end
