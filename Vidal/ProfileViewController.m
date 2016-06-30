//
//  ProfileViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ProfileViewController.h"
#import "RegViewController.h"
#import "LoginViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController {
    
    NSUserDefaults *ud;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setLabel:@"Профиль"];
    
    ud = [NSUserDefaults standardUserDefaults];
    [self loadData];
    
    
    NSLog(@"%f", self.changeButton.imageView.image.size.width);
    [self.changeButton setImage:[self imageWithImage:[UIImage imageNamed:@"edit"] scaledToSize:CGSizeMake(16, 20)]  forState:UIControlStateNormal];
    NSLog(@"%f", self.changeButton.imageView.image.size.width);
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"edit"] scaledToSize:CGSizeMake(20, 20)]
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(editButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)editButtonAction:(id)sender {
    RegViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    vc.isProfileUpdate = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateUserData];
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

- (IBAction)change:(UIButton *)sender {
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.vidal.ru/profile"]];

    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (IBAction)logOut:(id)sender {
    [ud setValue:@"1" forKey:@"reg"];
    [ud setObject:@"1" forKey:@"wasExit"];
    [self performSegueWithIdentifier:@"logout" sender:nil];
}

- (void)updateUserData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *email = [ud objectForKey:@"email"];
    NSString *token = [ud objectForKey:@"archToken"];
    
    [manager POST:@"http://www.vidal.ru/api/profile" parameters:@{
                                                                    @"username":email,
                                                                    @"token":token}
          success:^(AFHTTPRequestOperation * _Nonnull operation, id responseObject) {
              
              NSLog(@"%@", responseObject);
              
              [ud setObject:[responseObject valueForKey:@"lastName"] forKey:@"surname"];
              [ud setObject:[responseObject valueForKey:@"firstName"] forKey:@"manName"];
              [ud setObject:[responseObject valueForKey:@"birthdate"] forKey:@"birthDay"];
              [ud setObject:[responseObject valueForKey:@"city"] forKey:@"city"];
              [ud setObject:[responseObject valueForKey:@"primarySpecialty"] forKey:@"spec"];
              NSString *nullString;
              NSLog(@"%@", nullString);
              NSLog(@"%@", [responseObject valueForKey:@"secondarySpecialty"]);
              if ([[responseObject valueForKey:@"secondarySpecialty"] isKindOfClass:[NSNull class]] == NO) {
                  [ud setObject:[responseObject valueForKey:@"secondarySpecialty"] forKey:@"secondarySpecialty"];
              } else {
                  [ud setObject:@"-" forKey:@"secondarySpecialty"];
              }
              [ud setObject:[responseObject valueForKey:@"academicDegree"] forKey:@"academicDegree"];
              [ud setObject:[responseObject valueForKey:@"university"] forKey:@"university"];
              [ud setObject:[responseObject valueForKey:@"graduateYear"] forKey:@"graduateYear"];
              
              [self loadData];

              
          } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
              
              [self showAlert:@"Ошибка входа" mess:@"Проверьте правильность данных" check:NO];
          }];

}

/*
 about = "<null>";
 academicDegree = "\U041a\U0430\U043d\U0434\U0438\U0434\U0430\U0442 \U043d\U0430\U0443\U043a";
 birthdate = "30.01.1985";
 city = "\U041c\U043e\U0441\U043a\U0432\U0430";
 country = "\U0420\U043e\U0441\U0441\U0438\U044f";
 created = "15.04.2016";
 dissertation = "<null>";
 educationType = "\U041e\U0447\U043d\U0430\U044f";
 firstName = Yuriy;
 graduateYear = 2015;
 icq = "<null>";
 jobAchievements = "<null>";
 jobPlace = "<null>";
 jobPosition = "<null>";
 jobPublications = "<null>";
 jobSite = "<null>";
 jobStage = "<null>";
 lastName = Reutskiy;
 oldUser = 0;
 phone = "<null>";
 primarySpecialty = "\U0410\U043a\U0443\U0448\U0435\U0440\U0441\U0442\U0432\U043e \U0438 \U0433\U0438\U043d\U0435\U043a\U043e\U043b\U043e\U0433\U0438\U044f";
 professionalInterests = "<null>";
 region = "\U041c\U043e\U0441\U043a\U0432\U0430 \U0438 \U041c\U043e\U0441\U043a\U043e\U0432\U0441\U043a\U0430\U044f \U043e\U0431\U043b.";
 school = "<null>";
 secondarySpecialty = "\U0410\U0439\U0442\U0438-\U0441\U043f\U0435\U0446\U0438\U0430\U043b\U0438\U0441\U0442 \U0432 \U043c\U0435\U0434\U0438\U0446\U0438\U043d\U0435";
 specialization = "<null>";
 surName = "<null>";
 university = "\U0421\U0435\U0432\U0435\U0440\U043d\U044b\U0439 \U0433\U043e\U0441\U0443\U0434\U0430\U0440\U0441\U0442\U0432\U0435\U043d\U043d\U044b\U0439 \U043c\U0435\U0434\U0438\U0446\U0438\U043d\U0441\U043a\U0438\U0439 \U0443\U043d\U0438\U0432\U0435\U0440\U0441\U0438\U0442\U0435\U0442";
 username = "yurareutskiy@gmail.com";

 
 university
 graduateYear
 secondarySpecialty
 academicDegree
 */

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

- (void)loadData {
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
    
    [self.surname setText:surname];
    [self.name setText:name];
    [self.email setText:email];
    [self.bd setText:bd];
    [self.city setText:city];
    [self.spec setText:spec];
    [self.universityText setText:univer];
    [self.degreeText setText:degree];
    [self.degreeYearText setText:yearDegree];
    [self.secondSpecText setText:secondSpec];

}





@end
