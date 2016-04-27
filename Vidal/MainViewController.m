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
        [self checkBool];
        [self getLink];
        [self getKey];
    }
    
    // Do any additional setup after loading the view.
}

/*

 ;sodghfsd;ofh;s
 sdifgousdh
 
 
 sdfdsh */

- (void) checkBool {
    NSLog(@"HELLOOOOOOOOOOO");
    if (!exists) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Архив начал скачиваться" message:@"Подождите 15-30 секунд. Элементы взаимодействия недоступны, пожалуйста, не выключайте приложение." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        self.name.enabled = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.revealViewController.panGestureRecognizer.enabled = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Архив скачался" message:@"Можете пользоваться приложением." preferredStyle:UIAlertControllerStyleAlert];
        
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

- (void) showAlert {
    
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
        
        [self downloadDB:[responseObject valueForKey:@"url"]];
        
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
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"vidalDatabase.zip"];
            NSLog(@"%@", documentsDirectory);
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                NSLog(@"File Saved !");
                exists = true;
                [self checkBool];
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
    [ud setObject:@"6057" forKey:@"comp"];
    [self performSegueWithIdentifier:@"toList" sender:self];
}

@end
