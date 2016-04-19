//
//  ProfileViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController {
    
    NSUserDefaults *ud;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setLabel:@"Профиль"];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    NSString *surname = [ud valueForKey:@"surname"];
    NSString *name = [ud valueForKey:@"manName"];
    NSString *email = [ud valueForKey:@"email"];
    NSString *bd = [ud valueForKey:@"birthDay"];
    NSString *city = [ud valueForKey:@"city"];
    NSString *spec = [ud valueForKey:@"spec"];
    
    [self.surname setText:surname];
    [self.name setText:name];
    [self.email setText:email];
    [self.bd setText:bd];
    [self.city setText:city];
    [self.spec setText:spec];
    
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

@end
