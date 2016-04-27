//
//  SecondDocumentViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 09/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocsTableViewCell.h"
#import "DBManager.h"
#import "SecondModelViewController.h"

@interface SecondDocumentViewController : SecondModelViewController <UITableViewDelegate, UITableViewDataSource, DocsTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *registred;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *latName;
@property (strong, nonatomic) IBOutlet UIButton *fav;

@property (strong, nonatomic) NSMutableArray *info;
@property (strong, nonatomic) DBManager *dbManager;

- (IBAction)addToFav:(UIButton *)sender;
- (IBAction)toInter:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)share:(UIButton *)sender;

@end
