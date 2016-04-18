//
//  MainViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 28/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewController.h"
#import "AFNetworking.h"
#import "ZipArchive.h"
#import <CommonCrypto/CommonDigest.h>

@interface MainViewController : ModelViewController

@property (weak, nonatomic) IBOutlet UIImageView *bg;
- (IBAction)toTakeda:(UIButton *)sender;
- (IBAction)toVidal:(UIButton *)sender;
- (IBAction)toList:(UIButton *)sender;

@end
