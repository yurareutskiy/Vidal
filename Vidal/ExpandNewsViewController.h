//
//  ExpandNewsViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 18/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewController.h"

@interface ExpandNewsViewController : ModelViewController
@property (strong, nonatomic) IBOutlet UILabel *newsText;
- (IBAction)backAction:(UIButton *)sender;

@end
