//
//  ExpandNewsViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 18/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewController.h"
#import "SocialNetworkManagerVC.h"
#import "AFNetworking.h"

@interface ExpandNewsViewController : ModelViewController
@property (strong, nonatomic) IBOutlet UILabel *newsText;
- (IBAction)backAction:(UIButton *)sender;
- (IBAction)shareNews:(UIButton *)sender;
@property (nonatomic, retain) NSString *newsId;
@property (strong, nonatomic) IBOutlet UILabel *newsTitle;
@property (strong, nonatomic) IBOutlet UILabel *date;
- (id) initWithURLString:(NSString*) urlString;

@end
