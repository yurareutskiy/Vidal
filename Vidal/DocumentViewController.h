//
//  DocumentViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 06/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *registred;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)toList:(UIButton *)sender;
- (IBAction)addToFav:(UIButton *)sender;
- (IBAction)toInter:(UIButton *)sender;


@end
