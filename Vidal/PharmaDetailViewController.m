//
//  PharmaDetailViewController.m
//  Vidal
//
//  Created by Yura Reutskiy Work on 6/24/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "PharmaDetailViewController.h"
#import "DBManager.h"
#import "PharmaTableViewCell.h"
#import "ListOfViewController.h"
#import "PharmaViewController.h"
#import "StringFormatter.h"
#import "SearchViewController.h"

@interface PharmaDetailViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *sourceArray;


@end

@implementation PharmaDetailViewController {
    
    NSUserDefaults *ud;
//    NSString *req;
//    BOOL isEmptyDrugsList;
//    NSInteger level;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];

    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];

    self.navigationItem.title = @"Фармакологические группы";
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(search)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    [self refreshDb];
    
    [self.mainTitleLabel setText:self.pharmaName];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load data

- (void) refreshDb {
    NSString *req = @"SELECT DocumentListView.*, InfoPage.RusName as InfoPageName FROM DocumentListView "
                     "INNER JOIN Document_InfoPage ON Document_InfoPage.DocumentID = DocumentListView.DocumentID "
                    "INNER JOIN InfoPage ON InfoPage.InfoPageID = Document_InfoPage.InfoPageID   WHERE DocumentListView.CategoryCode LIKE '";

    req = [[req stringByAppendingString:self.parentCode] stringByAppendingString:@"%' ORDER BY DocumentListView.RusName"];
    [self loadData:req];
    
}


-(void)loadData:(NSString *)req {
    
    self.sourceArray = [self.dbManager loadDataFromDB:req];
    
    if ([self.sourceArray count] == 0) {
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Нет данных" message:@"Отсутствует информация о группе" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
//                             {
//                                 
//                             }];
//        [alertController addAction:ok];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        [self.table reloadData];
    }
    
    // Reload the table view.
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sourceArray count];
}

- (PharmaTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    PharmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[PharmaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
    NSInteger indexOfElaboration = [self.dbManager.arrColumnNames indexOfObject:@"Elaboration"];
    NSInteger indexOfEngName = [self.dbManager.arrColumnNames indexOfObject:@"InfoPageName"];
    
    cell.elaboration.text = [StringFormatter clearString:[[self.sourceArray objectAtIndex:indexPath.row] objectAtIndex:indexOfElaboration]];
    cell.name.text = [self formatNameString:[StringFormatter clearString:[[NSString stringWithFormat:@"%@", [[self.sourceArray objectAtIndex:indexPath.row] objectAtIndex:indexOfName]] valueForKey:@"lowercaseString"]]];

    cell.latName.text = [StringFormatter clearString:[NSString stringWithFormat:@"%@", [[self.sourceArray objectAtIndex:indexPath.row] objectAtIndex:indexOfEngName]]];

    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger indexOfDocumentID = [self.dbManager.arrColumnNames indexOfObject:@"DocumentID"];
    
    self.molecule = [NSMutableArray arrayWithArray:[self.sourceArray objectAtIndex:indexPath.row]];

    
    [ud setObject:[[self.sourceArray objectAtIndex:indexPath.row] objectAtIndex:indexOfDocumentID] forKey:@"id"];
    [self performSegueWithIdentifier:@"toList" sender:indexPath];
}


#pragma mark - Additional Methods

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (void) search {
    [self performSegueWithIdentifier:@"toSearch" sender:self];
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toList"]) {
        
        NSInteger row = [(NSIndexPath*)sender row];
        
        SecondDocumentViewController *sdvc = [segue destinationViewController];

        NSInteger indexOfId = [self.dbManager.arrColumnNames indexOfObject:@"DocumentID"];
        sdvc.drugID = [NSString stringWithFormat:@"%@", [[self.sourceArray objectAtIndex:row] objectAtIndex:indexOfId]];
        
    } else if ([segue.identifier isEqualToString:@"pharm"]) {
        PharmaViewController *vc = [segue destinationViewController];
        
        vc.level = _level;
        vc.code = _parentCode;
    }  else if ([segue.identifier isEqualToString:@"toSearch"]) {
        SearchViewController *vc = [segue destinationViewController];
        [vc setSearchType:SearchPharmGroup];
    }
    
}

-(IBAction)showListGroupsActions:(id)sender {
    [self performSegueWithIdentifier:@"pharm" sender:nil];
}


- (NSString*)formatNameString:(NSString*)name {
    NSArray *parts = [name componentsSeparatedByString:@" "];
    for (int i = 0; i < [parts count]; i++) {
        if (i == 1 || i == 2) {
            NSString *partString = parts[i];
            if ([partString length] <= 3) {
                partString = [partString uppercaseString];
            } else {
                partString = [partString capitalizedString];
            }
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:parts];
            [tempArray setObject:partString atIndexedSubscript:i];
            parts = tempArray;
        }
    }
    name = [parts componentsJoinedByString:@" "];
    
    return name;
}


@end
