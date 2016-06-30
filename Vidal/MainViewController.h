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
#import "AppDelegate.h"

@interface MainViewController : ModelViewController

@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *systemInfoLabel;

- (IBAction)toTakeda:(UIButton *)sender;
- (IBAction)toVidal:(UIButton *)sender;
- (IBAction)toList:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *name;


@end
