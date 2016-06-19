//
//  AboutViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import "DBManager.h"
#import "SecondDocumentViewController.h"

@interface AboutViewController : ModelViewController
@property (strong, nonatomic) IBOutlet UILabel *takeda;
@property (strong, nonatomic) IBOutlet UILabel *drug;
@property (strong, nonatomic) IBOutlet UIButton *image;
@property (strong, nonatomic) IBOutlet UILabel *name;

- (IBAction)toList:(UIButton *)sender;
- (IBAction)right:(UIButton *)sender;
- (IBAction)left:(UIButton *)sender;
- (IBAction)toPreparat:(UIButton *)sender;

@end
