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

@interface ListOfViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *darkView;


@end
