//
//  ListOfViewController.h
//  
//
//  Created by Anton Scherbakov on 10/04/16.
//
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "PharmaTableViewCell.h"
#import "SecondDocumentViewController.h"
#import "DocumentViewController.h"
#import "SecondModelViewController.h"

@interface ListOfViewController : SecondModelViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataBase;
@property (strong, nonatomic) NSString *activeID;
@property (strong, nonatomic) NSString *drug;
@property (nonatomic, strong) DBManager *dbManager;


@end
