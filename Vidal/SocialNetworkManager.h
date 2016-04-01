//
//  SocialNetworkManager.h
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

@interface SocialNetworkManager : NSObject <VKSdkDelegate>

- (IBAction)redlogin:(UIButton *)sender;
- (IBAction)post:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *message;
@property (strong, nonatomic) IBOutlet FBSDKShareButton *buttonFB;
- (IBAction)okReg:(UIButton *)sender;
- (IBAction)postOK:(UIButton *)sender;

@end
