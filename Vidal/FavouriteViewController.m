//
//  FavouriteViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "FavouriteViewController.h"

@interface FavouriteViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *arrPeopleInfo;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (nonatomic, strong) NSMutableArray *molecule;

-(void)loadData:(NSString *)req;

@end

@implementation FavouriteViewController {
    
    BOOL container;
    UITapGestureRecognizer *tap;
    NSUserDefaults *ud;
    NSMutableIndexSet *toDelete;
    NSIndexPath *selectedRowIndex;
    CGFloat sizeCell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    [ud removeObjectForKey:@"listOfDrugs"];
    
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.delegate = self;
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.dataSource = self;
    [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView setTag:2];
    
    
    toDelete = [NSMutableIndexSet indexSet];
    [self.tableView setTag:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    self.navigationItem.title = @"Избранное";
    
    container = false;
    self.containerView.hidden = true;
    self.darkView.hidden = true;
    
    tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(close)];
    
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    
    NSString *request = @"";
    NSArray *data = [NSArray arrayWithArray:[ud objectForKey:@"favs"]];
    NSLog(@"%@", [ud objectForKey:@"favs"]);
    NSLog(@"%@", data);
    if ([data count] == 1) {
        request = [NSString stringWithFormat:@"select * from DocumentListView where DocumentID = %@ order by RusName", [data objectAtIndex:0]];
    }
    if ([data count] > 1) {
        request = [NSString stringWithFormat:@"select * from DocumentListView where DocumentID = '%@'", [data objectAtIndex:0]];
        for (int i = 1; i < [data count]; i++) {
            request = [NSString stringWithFormat:@"%@ or DocumentID = %@", request, [data objectAtIndex:i]];
        }
        request = [NSString stringWithFormat:@"%@  order by RusName", request];
    }
    
    
    [self loadData:request];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [ud removeObjectForKey:@"molecule"];
    [ud removeObjectForKey:@"comp"];
}


- (void) search {
    [self performSegueWithIdentifier:@"toSearch" sender:self];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) close {
    self.containerView.hidden = true;
    container = false;
    [self.darkView removeGestureRecognizer:tap];
    self.darkView.hidden = true;
    
}

- (void) setLabel:(NSString *)label {
    UILabel* labelName = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    labelName.textAlignment = NSTextAlignmentLeft;
    labelName.text = NSLocalizedString(label, @"");
    labelName.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = labelName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1){
        return 100;
    } else if (tableView.tag == 2) {
        if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
            return sizeCell;
        } else {
            return 60;
        }
    } else {
        return 60;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrPeopleInfo count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    if (tableView.tag == 1) {
    static NSString *CellIdentifier = @"favCell";
    FavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[FavTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
        
        [[cell.favButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
    NSInteger indexOfComp = [self.dbManager.arrColumnNames indexOfObject:@"CompaniesDescription"];
    
        cell.delegate = self;
    [cell setTag:indexPath.row];
        
    // Set the loaded data to the appropriate cell labels.
        cell.name.text = [self clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName]];
        if (![[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfComp] isEqualToString:@""]) {
        cell.information.text = [self clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfComp]];
        } else {
            cell.information.text = @"Нет информации о производителе";
        }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
} else if (tableView.tag == 2){
        
        if (self.molecule == nil) {
            return nil;
        }
        
        DocsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell"];
        if (cell == nil) {
            cell = [[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"docCell"];
        };
        
        cell.title.text = [self clearString:[NSString stringWithFormat:@"%@", [self.dbManager.arrColumnNames objectAtIndex:indexPath.row]]];
        cell.desc.text = [self clearString:[[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        return nil;
    }

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSInteger indexOfDocumentID = [self.dbManager.arrColumnNames indexOfObject:@"DocumentID"];
    
        self.molecule = [NSMutableArray arrayWithArray:[self.arrPeopleInfo objectAtIndex:indexPath.row]];
        [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfDocumentID] forKey:@"id"];
        [self performSegueWithIdentifier:@"toSecDoc" sender:self];

}

-(void)loadData:(NSString *)req{
    // Form the query.
    NSString *query = [NSString stringWithFormat:req];
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if ([self.arrPeopleInfo count] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Пустой список" message:@"Вы не добавляли препараты в избранное" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [self.navigationController popViewControllerAnimated:YES];
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    // Reload the table view.
    [self.tableView reloadData];
    
}

- (void) getMol:(NSString *)mol {
    
    if (self.molecule != nil) {
        self.molecule = nil;
    }
    self.molecule = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:mol]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toSecDoc"]) {
        
        SecondDocumentViewController *sdvc = [segue destinationViewController];
        
        sdvc.info = self.molecule;
        sdvc.dbManager = self.dbManager;
        
    }
    
}
//    for (NSUInteger i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
//        if ([[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
//            || [[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
//            [toDelete addIndex:i];
//    }
//    
//    if ([((NSArray *)[ud objectForKey:@"favs"]) containsObject:[ud objectForKey:@"id"]]) {
//        NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithString:@"Препарат в избранном" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255.0 green:0.0 blue:57.0/255.0 alpha:1], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
//        
//        [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav setAttributedTitle:resultText forState:UIControlStateNormal];
//        [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav setImage:[UIImage imageNamed:@"favRed"] forState:UIControlStateNormal];
//        ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0);
//    } else {
//        NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithString:@"Добавить в избранное" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
//        
//        [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav setAttributedTitle:resultText forState:UIControlStateNormal];
//        [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav setImage:[UIImage imageNamed:@"favGrey"] forState:UIControlStateNormal];
//        ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0);
//    }
//
//    
//    ((SecondDocumentViewController *)self.childViewControllers.lastObject).latName.text = [self clearString:[[[self.molecule objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"]];
//    ((SecondDocumentViewController *)self.childViewControllers.lastObject).name.text = [self clearString:[[[self.molecule objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"]];
//    
//    if (![[[self.molecule objectAtIndex:0] objectAtIndex:2] isEqualToString:@""]) {
//        ((SecondDocumentViewController *)self.childViewControllers.lastObject).registred.text = [self clearString:[[self.molecule objectAtIndex:0] objectAtIndex:2]];
//        [toDelete addIndex:2];
//    } else {
//        [toDelete addIndex:2];
//    }
//    
//    [toDelete addIndex:0];
//    [toDelete addIndex:1];
//    
//    [[self.molecule objectAtIndex:0] removeObjectsAtIndexes:toDelete];
//    [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
//    
//    [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView reloadData];
    

- (void) del:(FavTableViewCell *)sender {
    
    
    NSMutableArray *check = [NSMutableArray arrayWithArray:[ud objectForKey:@"favs"]];
    NSLog(@"%@", check);
    [check removeObjectAtIndex:sender.tag];
    NSLog(@"%@", check);
    [self.arrPeopleInfo removeObjectAtIndex:sender.tag];
    NSLog(@"%@", self.arrPeopleInfo);
    [ud setObject:check forKey:@"favs"];
    
    [self.tableView reloadData];
    
}

- (NSString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
    text = [text stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    text = [text stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    text = [text stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"»"];
    text = [text stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    text = [text stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"&-nb-sp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"–"];
    text = [text stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"–"];
    text = [text stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    text = [text stringByReplacingOccurrencesOfString:@"&loz;" withString:@"◊"];
    text = [text stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    text = [text stringByReplacingOccurrencesOfString:@"<SUP>&reg;</SUP>" withString:@"®"];
    text = [text stringByReplacingOccurrencesOfString:@"<sup>&reg;</sup>" withString:@"®"];
    text = [text stringByReplacingOccurrencesOfString:@"<P>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<B>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<I>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<TR>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<TD>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</P>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</B>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<BR />" withString:@"\n"];
    text = [text stringByReplacingOccurrencesOfString:@"<FONT class=\"F7\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</FONT>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</I>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</TR>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</TD>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<TABLE width=\"100%\" border=\"1\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</TABLE>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</SUB>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<SUB>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<P class=\"F7\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    
    return text;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
