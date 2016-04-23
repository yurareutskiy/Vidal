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
#import "DocsTableViewCell.h"

@interface ListOfViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, DocsTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *containerView2;
@property (strong, nonatomic) IBOutlet UIView *darkView;


@end
