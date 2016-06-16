//
//  CompanyViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 24/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondModelViewController.h"

@interface CompanyViewController : SecondModelViewController

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *nameHid;
@property (strong, nonatomic) IBOutlet UILabel *countryHid;
@property (strong, nonatomic) IBOutlet UITextView *addressHid;
@property (strong, nonatomic) IBOutlet UILabel *emailHid;
@property (strong, nonatomic) IBOutlet UILabel *phoneHid;
@property (strong, nonatomic) IBOutlet UIButton *listBtn;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) UIImage *logo;

- (IBAction)toListDrugs:(UIButton *)sender;

@end
