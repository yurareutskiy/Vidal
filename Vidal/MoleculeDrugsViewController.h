//
//  MoleculeDrugsViewController.h
//  Vidal
//
//  Created by Test Account on 06/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "DocumentViewController.h"

@interface MoleculeDrugsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *darkView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
