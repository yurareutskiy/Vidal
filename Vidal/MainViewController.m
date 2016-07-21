//
//  MainViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 28/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "MainViewController.h"
#import "OnboardingViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (strong, nonatomic) OnboardingViewController *onboardingVC;

@end

@implementation MainViewController {
    
    NSString *secret_key;
    NSUserDefaults *ud;
    BOOL exists;
    UIAlertController *alertController;
    BOOL isConnectionAvailable;
    NSString *url;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLabel:@"Vidal-кардиология"];
    ud = [NSUserDefaults standardUserDefaults];

    if ([[ud objectForKey:@"reg"] isEqualToString:@"0"]) {
        return;
    }
    
    [self checkConnection];
    [ud setValue:@"0" forKey:@"howTo"];
    [ud removeObjectForKey:@"toInter"];
    
    secret_key = @"uX04xN12Tk1654Qz";
    
    self.progress.hidden = YES;
    self.bgView.hidden = YES;
    
    self.progress.layer.cornerRadius = 12.0f;
    self.progress.layer.borderColor = [UIColor whiteColor].CGColor;
    self.progress.layer.borderWidth = 1.5f;
    [self.progress setProgress:0];
    self.progress.layer.masksToBounds = YES;
    self.progress.clipsToBounds = YES;
    
    self.bg.layer.masksToBounds = YES;
    NSLog(@"%@", [ud valueForKey:@"reg"]);
//    if ([[ud valueForKey:@"reg"] isEqualToString:@"1"]) {
        NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *directoryURL = [URLs firstObject];
        NSURL *databaseURL = [directoryURL URLByAppendingPathComponent:@"vidalDatabase.zip"];
        NSError *error = nil;
        exists = [databaseURL checkResourceIsReachableAndReturnError:&error];
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            isConnectionAvailable = false;
        } else {
            isConnectionAvailable = true;
        }
        NSLog(@"conne %d", isConnectionAvailable);

        if (!exists && isConnectionAvailable) {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

            if (appDelegate.registrationToken) {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                NSLog(@"%@", appDelegate.registrationToken);
                NSDictionary *params = @{
                                         @"token":[ud valueForKey:@"archToken"],
                                         @"username":[ud valueForKey:@"email"],
                                         @"id":appDelegate.registrationToken};
                [manager POST:@"http://www.vidal.ru/api/user/set-android-id" parameters:params
                      success:^(AFHTTPRequestOperation * _Nonnull operation, id responseObject) {
                          NSLog(@"%@", responseObject);
                          NSLog(@"%@ - %@ - %@", [ud valueForKey:@"archToken"], [ud valueForKey:@"email"], appDelegate.registrationToken);
                      } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                          NSLog(@"LOH");
                      }];
            }


            [self checkBool:@"Началась загрузка данных" mess:@"Пожалуйста, не выключайте приложение до окончания загрузки." down:NO amount:1];
            [self getLink];
        } else if (isConnectionAvailable == false) {
            return;
        } else {
            [self getLink];
        }
        
        [ud removeObjectForKey:@"workWith"];
        [ud removeObjectForKey:@"activeID"];
        [ud removeObjectForKey:@"pharmaList"];
        [ud removeObjectForKey:@"comp"];
        [ud removeObjectForKey:@"info"];
        [ud removeObjectForKey:@"from"];
        [ud removeObjectForKey:@"molecule"];
        [ud removeObjectForKey:@"letterDrug"];
        [ud removeObjectForKey:@"letterActive"];
        
//    }
//     Do any additional setup after loading the view.
}


- (void) checkBool:(NSString *)title mess:(NSString *)mess down:(BOOL)down amount:(int)butt {
    NSLog(@"HELLOOOOOOOOOOO");
    if (!exists) {
        
        if (butt == 1 || butt == 2) {
        
            alertController = [UIAlertController alertControllerWithTitle:title message:mess preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                     if (down) {
                                         [self deleteFile];
                                         [self downloadDB:[ud valueForKey:@"url"]];
                                         [self getKey];
                                         [ud setObject:[ud valueForKey:@"newVersion"] forKey:@"version"];
                                     } else {
                                         [self performSegueWithIdentifier:@"onboarding" sender:nil];
                                     }
                                    }];
            [alertController addAction:ok];
        }
        
        if (butt == 2) {
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Напомнить позже" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     self.name.enabled = YES;
                                     self.navigationItem.leftBarButtonItem.enabled = YES;
                                     self.revealViewController.panGestureRecognizer.enabled = YES;
                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                     NSDate *now = [NSDate date];
                                     [ud setObject:(NSDate *)now forKey:@"date"];
                                     
                                 }];
            [alertController addAction:ok];
            
            UIAlertAction *decline = [UIAlertAction actionWithTitle:@"Отменить" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
            {
                self.name.enabled = YES;
                self.navigationItem.leftBarButtonItem.enabled = YES;
                self.revealViewController.panGestureRecognizer.enabled = YES;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [ud setObject:[ud valueForKey:@"newVersion"] forKey:@"version"];
            }];
            
            [alertController addAction:decline];
            
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        self.name.enabled = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.revealViewController.panGestureRecognizer.enabled = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    } else {
        
        alertController = [UIAlertController alertControllerWithTitle:title message:mess preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        self.name.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.revealViewController.panGestureRecognizer.enabled = YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
}

- (void) deleteFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"vidalDatabase.zip"];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (!success)
    {
        NSLog(@"1 Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    filePath = [documentsPath stringByAppendingPathComponent:@"vidal.cardio.db3"];
    success = [fileManager removeItemAtPath:filePath error:&error];
    if (!success)
    {
        NSLog(@"2 Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    filePath = [documentsPath stringByAppendingPathComponent:@"interactions.min.json"];
    success = [fileManager removeItemAtPath:filePath error:&error];
    if (!success)
    {
        NSLog(@"3 Could not delete file -:%@ ",[error localizedDescription]);
    }
    
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), digest); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (void)checkConnection {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"Reachability changed: %@", AFStringFromNetworkReachabilityStatus(status));
        
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"Reachable");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                // -- Not reachable -- //
                NSLog(@"Not Reachable");
                break;
        }
        
    }];
}

- (void) getLink {
    // TODO
    if (![[ud valueForKey:@"reg"] isEqualToString:@"0"]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSLog(@"%@", [ud valueForKey:@"archToken"]);
        [manager POST:@"http://www.vidal.ru/api/db/update-android" parameters:@{@"token":[ud valueForKey:@"archToken"], @"tag":@"cardio"} success:^(AFHTTPRequestOperation * _Nonnull operation, id responseObject) {
            
            NSLog(@"%@", responseObject);
            
            [ud setObject:[responseObject valueForKey:@"url"] forKey:@"url"];
            url = [responseObject valueForKey:@"url"];
            [ud setObject:[responseObject valueForKey:@"version"] forKey:@"newVersion"];
            
            if (!exists) {
                [self downloadDB:url];
                [self getKey];
                [ud setObject:[ud valueForKey:@"newVersion"] forKey:@"version"];
            } else {
                NSLog(@"%@ - %@", [ud objectForKey:@"version"], [ud objectForKey:@"newVersion"]);
                if (![[NSString stringWithFormat:@"%@", [ud objectForKey:@"version"]] isEqualToString:[NSString stringWithFormat:@"%@", [ud objectForKey:@"newVersion"]]]) {
                    if ([self compareDate]) {
                        exists = false;
                        [self checkBool:@"Доступна новая версия архива" mess:@"Скачать?" down:YES amount:2];
                    }
                }
            }
            
            
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
            NSLog(@"%@", error);
            
        }];

    }
    
}

- (BOOL) compareDate {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    NSInteger currentMonth = [components month];
    NSInteger currentDay = [components day];
    NSInteger currentHour = [components hour];
    
    NSDate *previous = (NSDate *)[ud objectForKey:@"date"];
    NSDateComponents *oldComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:previous];
    NSInteger prevMonth = [oldComponents month];
    NSInteger prevDay = [oldComponents day];
    NSInteger prevHour = [oldComponents hour];
    
    if (currentMonth > prevMonth || currentDay > prevDay || currentHour > prevHour + 6) {
        return YES;
    } else {
        return NO;
    }
}

- (void) getKey {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://www.vidal.ru/api/db/auth" parameters:@{@"token":[ud valueForKey:@"archToken"], @"version":@"20160410", @"tag":@"cardio"} success:^(AFHTTPRequestOperation * _Nonnull operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        NSString *pass;
        if ([[responseObject valueForKey:@"key"] isEqualToString:@""]) {
            pass = @"";
        } else {
            pass = [[self md5:[NSString stringWithFormat:@"%@%@", secret_key,[responseObject valueForKey:@"key"]]] substringToIndex:16];
        }
        
        NSLog(@"%@", [responseObject valueForKey:@"key"]);
        NSLog(@"%@", secret_key);
        [ud setObject:pass forKey:@"pass"];
        NSLog(@"%@", pass);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

- (void) downloadDB:(NSString *) link {
    
    self.progress.hidden = NO;
    self.bgView.hidden = NO;
    
    NSLog(@"LINK - %@", link);
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if (!exists) {
        NSLog(@"Downloading Started");
            self.progress.hidden = NO;
            self.bgView.hidden = NO;
        NSString *urlToDownload = link;
        NSURL *url = [NSURL URLWithString:urlToDownload];
        __block NSData *urlData = [NSData data];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            self.progress.progress = (float)totalBytesRead / totalBytesExpectedToRead;

        }];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                urlData = [NSData dataWithData:[operation responseData]];
                
                if (urlData) {
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    
                    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"vidalDatabase.zip"];
                    NSLog(@"%@", documentsDirectory);
                    [ud setObject:@"2" forKey:@"reg"];
                    
                    
                    //saving is done on main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [urlData writeToFile:filePath atomically:YES];
                        NSLog(@"File Saved !");
                        exists = true;
                        [self checkBool:@"Данные успешно загружены!" mess:@"Вы можете пользоваться приложением." down:NO amount:1];
                        ZipArchive *zipArchive = [[ZipArchive alloc] init];
                        [zipArchive UnzipOpenFile:filePath];
                        
                        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString  *documentsDirectory = [paths objectAtIndex:0];
                        
                        [zipArchive UnzipFileTo:documentsDirectory overWrite:YES];
                        [zipArchive UnzipCloseFile];
                        [alertController dismissViewControllerAnimated:NO completion:nil];
                        [self.onboardingVC changeDoneButtonWithType:YES];
                    });
                } else {
                    NSLog(@"Download failed");
                }
                [self.progress setProgress:0];
                self.progress.hidden = YES;
                self.bgView.hidden = YES;
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                if (self.onboardingVC) {
                    [self.onboardingVC dismissViewControllerAnimated:NO completion:^{
                        [ud setValue:@"1" forKey:@"reg"];
                        [ud setObject:@"1" forKey:@"wasExit"];
                        [ud setObject:@"1" forKey:@"noConnection"];
                        [self performSegueWithIdentifier:@"back" sender:nil];
                    }];
                } else {
                    [ud setValue:@"1" forKey:@"reg"];
                    [ud setObject:@"1" forKey:@"wasExit"];
                    [ud setObject:@"1" forKey:@"noConnection"];
                    [self performSegueWithIdentifier:@"back" sender:nil];
                }

            }];
            
            [operation start];
        }});
    
}

- (void) search {
    [self performSegueWithIdentifier:@"toSearch" sender:self];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

- (IBAction)toTakeda:(UIButton *)sender {
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.takeda.com.ru/"]];
    [self performSegueWithIdentifier:@"takeda" sender:nil];

}

- (IBAction)toVidal:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"about" sender:nil];    
}

- (IBAction)toList:(UIButton *)sender {
    [ud setObject:@"63" forKey:@"info"];
    [self performSegueWithIdentifier:@"toList" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"onboarding"]) {
        self.onboardingVC = segue.destinationViewController;
    }
}


@end
