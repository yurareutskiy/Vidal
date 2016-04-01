//
//  SocialNetworkManagerVC.h
//  Vidal
//
//  Created by Anton Scherbakov on 01/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VKSdk.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "OKSDK.h"
#import <CommonCrypto/CommonDigest.h>

@interface SocialNetworkManagerVC : UIViewController <VKSdkDelegate>

@property (strong, nonatomic) IBOutlet FBSDKShareButton *buttonFB;

- (IBAction)vkButton:(UIButton *)sender;
- (IBAction)okButton:(UIButton *)sender;
- (IBAction)fbButton:(UIButton *)sender;

@end
