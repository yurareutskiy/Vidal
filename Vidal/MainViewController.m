//
//  MainViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 28/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) UIBarButtonItem *searchButton;

@end

@implementation MainViewController {
    
    NSString *secret_key;
    NSUserDefaults *ud;
    BOOL exists;
    UIAlertController *alertController;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:@"0" forKey:@"howTo"];
    [ud removeObjectForKey:@"toInter"];
    
    secret_key = @"uX04xN12Tk1654Qz";
    
    self.bg.layer.masksToBounds = YES;
    
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *directoryURL = [URLs firstObject];
    NSURL *databaseURL = [directoryURL URLByAppendingPathComponent:@"vidalDatabase.zip"];
    NSError *error = nil;
    exists = [databaseURL checkResourceIsReachableAndReturnError:&error];
    
    if (!exists) {
        [self checkBool:@"Архив начал скачиваться" mess:@"Подождите 15-30 секунд. Элементы взаимодействия недоступны, пожалуйста, не выключайте приложение." down:NO amount:1];
        [self getLink];
        [self downloadDB:[ud valueForKey:@"url"]];
        [self getKey];
        [ud setObject:[ud valueForKey:@"newVersion"] forKey:@"version"];
    } else {
        [self getLink];
        if (![[NSString stringWithFormat:@"%@", [ud objectForKey:@"version"]] isEqualToString:[NSString stringWithFormat:@"%@", [ud objectForKey:@"newVersion"]]]) {
            exists = false;
            [self checkBool:@"Доступна новая версия архива" mess:@"Скачать?" down:YES amount:2];
        } else {
            
        }
    }
    
    // Do any additional setup after loading the view.
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
                                        }
                                    }];
            [alertController addAction:ok];
        }
        
        if (butt == 2) {
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Отменить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     self.name.enabled = YES;
                                     self.navigationItem.leftBarButtonItem.enabled = YES;
                                     self.revealViewController.panGestureRecognizer.enabled = YES;
                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                     [ud setObject:[ud valueForKey:@"newVersion"] forKey:@"version"];
                                 }];
            [alertController addAction:ok];
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

- (void) getLink {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://www.vidal.ru/api/db/update" parameters:@{@"token":[ud valueForKey:@"archToken"], @"version":@"20160410", @"tag":@"cardio"} success:^(AFHTTPRequestOperation * _Nonnull operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        [ud setObject:[responseObject valueForKey:@"url"] forKey:@"url"];
        [ud setObject:[responseObject valueForKey:@"version"] forKey:@"newVersion"];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

- (void) getKey {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://www.vidal.ru/api/db/auth" parameters:@{@"token":[ud valueForKey:@"archToken"], @"version":@"20160410", @"tag":@"cardio"} success:^(AFHTTPRequestOperation * _Nonnull operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        NSString *pass = [[self md5:[NSString stringWithFormat:@"%@%@", secret_key,[responseObject valueForKey:@"key"]]] substringToIndex:16];
        NSLog(@"%@", [responseObject valueForKey:@"key"]);
        NSLog(@"%@", secret_key);
        [ud setObject:pass forKey:@"pass"];
        NSLog(@"%@", pass);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

- (void) downloadDB:(NSString *) link {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if (!exists) {
        NSLog(@"Downloading Started");
        NSString *urlToDownload = link;
        NSURL  *url = [NSURL URLWithString:urlToDownload];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"vidalDatabase.zip"];
            NSLog(@"%@", documentsDirectory);
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                NSLog(@"File Saved !");
                exists = true;
                [self checkBool:@"Архив скачался" mess:@"Можете пользоваться приложением." down:NO amount:1];
                ZipArchive *zipArchive = [[ZipArchive alloc] init];
                [zipArchive UnzipOpenFile:filePath];
                
                NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString  *documentsDirectory = [paths objectAtIndex:0];
                
                [zipArchive UnzipFileTo:documentsDirectory overWrite:YES];
                [zipArchive UnzipCloseFile];
            });
        } else {
            NSLog(@"Download failed");
        }
        } else {
            NSLog(@"OKay");
        }
        
    });
    
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
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.takeda.com.ru/"]];

}

- (IBAction)toVidal:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.vidal.ru"]];
    
}

- (IBAction)toList:(UIButton *)sender {
    [ud setObject:@"63" forKey:@"info"];
    [self performSegueWithIdentifier:@"toList" sender:self];
}

@end
