//
//  SocialNetworkManager.m
//  Vidal
//
//  Created by Anton Scherbakov on 01/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "SocialNetworkManager.h"


@implementation SocialNetworkManager {
    
    VKAccessToken *tokenYeap;
    FBSDKShareLinkContent *content;
    NSUserDefaults *ud;
    NSString *signa;
    
}

- (void)viewDidLoad {
    //[super viewDidLoad];
    
    [VKSdk initializeWithDelegate:self andAppId:@"5378805"];
    ud = [NSUserDefaults standardUserDefaults];
    
    content = [[FBSDKShareLinkContent alloc] init];
    content.contentTitle = @"hello";
    content.contentDescription = @"hey, man";
    content.imageURL = [NSURL URLWithString:@"https://pp.vk.me/c631231/v631231562/1aa78/COSPODeXbsU.jpg"];
    self.buttonFB.shareContent = content;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    NSLog(@"%@", captchaError);
}

/**
 Notifies delegate about existing token has expired
 @param expiredToken old token that has expired
 */
- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    NSLog(@"%@", expiredToken);
}

/**
 Notifies delegate about user authorization cancelation
 @param authorizationError error that describes authorization error
 */
- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
    NSLog(@"%@", authorizationError);
}

/**
 Pass view controller that should be presented to user. Usually, it's an authorization window
 @param controller view controller that must be shown to user
 */

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    //[self presentViewController:controller animated:YES completion:nil];
}

/**
 Notifies delegate about receiving new access token
 @param newToken new token for API requests
 */
- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    NSLog(@"%@", newToken);
    tokenYeap = newToken;
}

/**
 Notifies delegate about receiving predefined token (initializeWithDelegate:andAppId:andCustomToken: token is not nil)
 @param token used token for API requests
 */
- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token {
    NSLog(@"%@", token);
    tokenYeap = token;
    [ud setObject:token.accessToken forKey:@"token"];
}

/**
 Notifies delegate about receiving new access token
 @param newToken new token for API requests
 */
- (void)vkSdkRenewedToken:(VKAccessToken *)newToken {
    NSLog(@"%@", newToken);
}

- (IBAction)redlogin:(UIButton *)sender {
    
    if ([VKSdk wakeUpSession])
    {
        //Start working
    } else {
        
        [VKSdk authorize:@[@"audio", @"photos", @"pages", @"messages", @"stats", @"wall", @"questions", @"email"]];
        
    }
    
}

- (IBAction)post:(UIButton *)sender {
    
    VKRequest *request = [[VKApi wall] post:@{@"owner_id" : @"16455562", @"message" : @"hello", @"access_token" : tokenYeap.accessToken}];
    [request executeWithResultBlock:^(VKResponse *response) {
        NSLog(@"OK");
    } errorBlock:^(NSError *error) {
        NSLog(@"failed %@", error);
    }];
}
- (IBAction)okReg:(UIButton *)sender {
    
    [OKSDK authorizeWithPermissions:@[@"VALUABLE_ACCESS"] success:^(NSArray *data) {
        signa = data[1];
        NSLog(@"%@", signa);
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (IBAction)postOK:(UIButton *)sender {
    
    
    
    //md5("st.attachment=" + attachment + secretKey);
    NSString *attach = @"{\"media\":[{\"text\":\"hello\",\"type\":\"text\"}]}";
    
    [OKSDK showWidget:@"WidgetMediatopicPost" arguments:@{@"st.attachment":attach} options:@{@"st.utext":@"on"} success:^(NSDictionary *data) {
        NSLog(@"%@", data);
    } error:^(NSError *commonError) {
        NSLog(@"%@", commonError);
    }];
    
}

@end
