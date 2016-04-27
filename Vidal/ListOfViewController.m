//
//  ListOfViewController.m
//  
//
//  Created by Anton Scherbakov on 10/04/16.
//
//

#import "ListOfViewController.h"

@interface ListOfViewController ()

@property (nonatomic, strong) NSMutableArray *arrPeopleInfo;
@property (nonatomic, strong) NSMutableArray *molecule;
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ListOfViewController {
    
    NSUserDefaults *ud;
    NSString *req;
    NSMutableIndexSet *toDelete;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    toDelete = [NSMutableIndexSet indexSet];
    
    NSLog(@"%@", self.childViewControllers);
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    [self refreshDb];
    
    
    
    // Do any additional setup after loading the view.
}

- (void) setNavBarTitle:(NSString *)name {
    
    self.navigationItem.title = name;
    
}

- (void) refreshDb {
    
    if ([ud valueForKey:@"activeID"]) {
        
        req = [NSString stringWithFormat:@"SELECT Product.DocumentID, Product.RusName FROM Document LEFT JOIN Molecule_Document ON Document.DocumentID = Molecule_Document.DocumentID LEFT JOIN Molecule ON Molecule_Document.MoleculeID = Molecule.MoleculeID INNER JOIN Product_Molecule ON Molecule.MoleculeID = Product_Molecule.MoleculeID INNER JOIN Product ON Product_Molecule.ProductID = Product.ProductID WHERE Molecule.MoleculeID = %@ ORDER BY Document.RusName", [ud valueForKey:@"activeID"]];
        
        [self setNavBarTitle:@"Препараты"];
        
        [self loadData:req];
        
    } else if ([ud objectForKey:@"molecule"]) {
        req = [NSString stringWithFormat:@"SELECT Product.DocumentID, Product.RusName AS 'Продукт', Molecule.RusName, Molecule.MoleculeID FROM Molecule INNER JOIN Product_Molecule ON Molecule.MoleculeID = Product_Molecule.MoleculeID INNER JOIN Product ON Product_Molecule.ProductID = Product.ProductID WHERE Molecule.MoleculeID = %@ ORDER BY Molecule.RusName", [ud objectForKey:@"molecule"]];
        
        [self setNavBarTitle:@"Препараты"];
        
        [self loadData:req];
    } else if ([ud valueForKey:@"pharmaList"]) {
        
        req = @"";
        
        [self setNavBarTitle:@"Фармакологические группы"];
        
        self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[ud valueForKey:@"pharmaList"]];
        
    } else if ([ud objectForKey:@"comp"]) {
        req = [NSString stringWithFormat:@"SELECT Document.DocumentID, Document.RusName FROM Document LEFT JOIN Document_InfoPage ON Document.DocumentID = Document_InfoPage.DocumentID LEFT JOIN InfoPage ON Document_InfoPage.InfoPageID = InfoPage.InfoPageID LEFT JOIN Product ON Document.DocumentID = Product.DocumentID WHERE InfoPage.InfoPageID = 63 GROUP BY Document.DocumentID"];
        
//        req = [NSString stringWithFormat:@"SELECT Product.DocumentID,  Product.RusName AS 'Продукт' FROM Product WHERE Product.CompanyID = %@ GROUP BY Product.DocumentID", [ud objectForKey:@"comp"]];
        
        [self setNavBarTitle:@"Такеда"];
        
        [self loadData:req];
    } else if ([ud valueForKey:@"workWith"]) {
        
        [self setNavBarTitle:@"Препараты"];
        
        req = @"";
        self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[ud valueForKey:@"workWith"]];
        
    }  else if ([ud valueForKey:@"workActive"]) {
        
        [self setNavBarTitle:@"Вещества"];
        
            req = @"";
            self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[ud valueForKey:@"workActive"]];
            
        
        
    } else if ([ud valueForKey:@"info"]) {
        
        req = [NSString stringWithFormat:@"SELECT Document.DocumentID, Document.RusName FROM Document INNER JOIN Document_InfoPage ON Document_InfoPage.DocumentID  = Document.DocumentID INNER JOIN InfoPage ON InfoPage.InfoPageID = Document_InfoPage.InfoPageID WHERE InfoPage.InfoPageID = %@", [ud valueForKey:@"info"]];
        
        [self loadData:req];
        
    } else {
        req = @"";
        [self loadData:req];
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self refreshDb];
    [self.tableView reloadData];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    if (self.isMovingFromParentViewController) {
        [ud setObject:@"drugs" forKey:@"from"];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrPeopleInfo.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        PharmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pharmaCell"];
        if (cell == nil) {
            cell = [[PharmaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        };
    
        NSInteger indexOfFirstname = [self.dataBase indexOfObject:@"RusName"];
        NSInteger indexOfCategory = [self.dataBase indexOfObject:@"Category"];
        
        // Set the loaded data to the appropriate cell labels.
        cell.name.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname]]];
        [cell.name setTextColor:[UIColor blackColor]];
        if ([ud valueForKey:@"workActive"] && ([self.activeID isEqualToString:@""] || self.activeID == nil)) {
            if (![[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@""]) {
                cell.category.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:2]]];
                [cell.category setTextColor:[UIColor lightGrayColor]];
            } else {
                cell.category.text = @"";
            }
        } else if ([ud valueForKey:@"activeID"]) {
            
            cell.name.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:1]]];
            [cell.name setTextColor:[UIColor blackColor]];
            cell.category.text = @"";
            
        } else if ([ud valueForKey:@"pharmaList"]) {
            cell.name.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:1]]];
            [cell.name setTextColor:[UIColor blackColor]];
            cell.category.text = @"";
        } else if ([ud valueForKey:@"comp"]) {
            cell.name.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:1]]];
            [cell.name setTextColor:[UIColor blackColor]];
            cell.category.text = @"";
        } else if ([ud valueForKey:@"info"]) {
            cell.name.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:1]]];
            [cell.name setTextColor:[UIColor blackColor]];
            cell.category.text = @"";
        } else {
            cell.category.text = @"";
        }
        
        return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if ([ud valueForKey:@"workWith"] || [ud valueForKey:@"comp"] || [ud valueForKey:@"pharmaList"] || [ud valueForKey:@"activeID"] || [ud valueForKey:@"info"]) {
        
            [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] forKey:@"drug"];
            [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] forKey:@"id"];
            NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompaniesDescription, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозирования', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document WHERE Document.DocumentID = %@", [ud objectForKey:@"drug"]];

            [self getMol:request];
            
        } else if ([ud valueForKey:@"workActive"]) {
            
                [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] forKey:@"drug"];
            
                NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompaniesDescription, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозирования', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Molecule_Document ON Document.DocumentID = Molecule_Document.DocumentID INNER JOIN Molecule ON Molecule_Document.MoleculeID = Molecule.MoleculeID WHERE Document.DocumentID = %@", [ud objectForKey:@"drug"]];
                //            INNER JOIN Product ON Document.DocumentID = Product.DocumentID
                NSLog(@"%@", request);
            
                [self getMol:request];
            [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:19] forKey:@"activeID"];
            
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData:(NSString *)req{
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
    
    if ([self.arrPeopleInfo count] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert title" message:@"Alert message" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [self.navigationController popViewControllerAnimated:YES];
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self.tableView reloadData];
    }
    
    // Reload the table view.
    
}

- (void) getMol:(NSString *)mol {
    
    if (self.molecule != nil) {
        self.molecule = nil;
    }
    self.molecule = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:mol]];

    
    if ([ud valueForKey:@"workWith"] || [ud valueForKey:@"comp"] || [ud valueForKey:@"pharmaList"] || [ud valueForKey:@"activeID"] || [ud valueForKey:@"info"]) {
        
        [self performSegueWithIdentifier:@"toSecDoc" sender:self];
        
    } else if ([ud valueForKey:@"workActive"]) {
        
        [ud setObject:@"active" forKey:@"from"];
        [self performSegueWithIdentifier:@"toDoc" sender:self];
        
    }
    
}

- (NSString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
    NSRange range = NSMakeRange(0, 1);
    text = [text stringByReplacingCharactersInRange:range withString:[[text substringToIndex:1] valueForKey:@"uppercaseString"]];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toSecDoc"]) {
        
        SecondDocumentViewController *sdvc = [segue destinationViewController];
        
        sdvc.info = self.molecule;
        sdvc.dbManager = self.dbManager;
        
    } else if ([segue.identifier isEqualToString:@"toDoc"]) {
        
        DocumentViewController *dvc = [segue destinationViewController];
        
        dvc.self.activeID = self.activeID;
        dvc.info = self.molecule;
        dvc.columns = self.dbManager.arrColumnNames;
        
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// CEMETERY OF CODE

//        ((DocumentViewController *)self.childViewControllers.lastObject).latName.text = [[[self.molecule objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"];
//
//        ((DocumentViewController *)self.childViewControllers.lastObject).name.text = [[[self.molecule objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"];
//
//        NSString *string = [[[self.molecule objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"];
//        ((DocumentViewController *)self.childViewControllers.lastObject).name.numberOfLines = 0;
//        ((DocumentViewController *)self.childViewControllers.lastObject).name.text = string;
//        [((DocumentViewController *)self.childViewControllers.lastObject).name sizeToFit];
//
//
//        for (NSUInteger i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
//            if ([[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
//                || [[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
//                [toDelete addIndex:i];
//        }
//
//        [toDelete addIndex:0];
//        [toDelete addIndex:1];
//
//        [[self.molecule objectAtIndex:0] removeObjectsAtIndexes:toDelete];
//        [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
//
//        [((DocumentViewController *)self.childViewControllers.lastObject).tableView reloadData];




//        ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).latName.text = [self clearString:[[[self.molecule objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"]];
//        ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).name.text = [self clearString:[[[self.molecule objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"]];
//
//        NSString *string = [self clearString:[[[self.molecule objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"]];
//        ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).name.numberOfLines = 0;
//        ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).name.text = string;
//        [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).name sizeToFit];
//
//        if (![[[self.molecule objectAtIndex:0] objectAtIndex:2] isEqualToString:@""]) {
//            ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).registred.text = [self clearString:[[self.molecule objectAtIndex:0] objectAtIndex:2]];
//            [toDelete addIndex:2];
//        } else {
//            [toDelete addIndex:2];
//        }
//
//        for (NSUInteger i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
//            if ([[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
//                || [[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
//                [toDelete addIndex:i];
//        }
//
//        if ([((NSArray *)[ud objectForKey:@"favs"]) containsObject:[ud objectForKey:@"id"]]) {
//            NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithString:@"Препарат в избранном" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255.0 green:0.0 blue:57.0/255.0 alpha:1], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
//
//            [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav setAttributedTitle:resultText forState:UIControlStateNormal];
//            [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav setImage:[UIImage imageNamed:@"favRed"] forState:UIControlStateNormal];
//            ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0);
//        } else {
//            NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithString:@"Добавить в избранное" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
//
//            [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav setAttributedTitle:resultText forState:UIControlStateNormal];
//            [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav setImage:[UIImage imageNamed:@"favGrey"] forState:UIControlStateNormal];
//            ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0);
//        }
//
//
//        [toDelete addIndex:0];
//        [toDelete addIndex:1];
//
//        [[self.molecule objectAtIndex:0] removeObjectsAtIndexes:toDelete];
//        [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
//
//        [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).tableView reloadData];



//- (void) close {
//
//    if ([[ud valueForKey:@"screen"] isEqualToString:@"1"]) {
//        [ud removeObjectForKey:@"listOfDrugs"];
//    }
//
//    if (rly) {
//        [ud removeObjectForKey:@"listOfDrugs"];
//    }
//
//    [self refreshDb];
//
//
//
//    self.containerView.hidden = true;
//    self.containerView2.hidden = true;
//    container = false;
//    [self.darkView removeGestureRecognizer:tap];
//    self.darkView.hidden = true;
//
//    open = false;
//    [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).tableView reloadData];
//    [((DocumentViewController *)[self.childViewControllers objectAtIndex:1]).tableView reloadData];
//
//}



//- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView.tag == 2 || tableView.tag == 3){
//        selectedRowIndex = [indexPath copy];
//
//        open = false;
//
//        sizeCell = [self labelSize:[[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row]] + 60.0;
//
//        [tableView beginUpdates];
//
//        [tableView endUpdates];
//    } else {
//        NSLog(@"hello");
//    }
//}



//    }} else if (tableView.tag == 2 || tableView.tag == 3){
//        selectedRowIndex = [indexPath copy];
//        if (!open) {
//            open = true;
//            DocsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            [self perfSeg:cell];
//
//        } else {
//            open = false;
//            DocsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            [self perfSeg:cell];
//        }
//
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.containerView.frame.size.width - 40, 0)];
//        NSString *string = [self clearString:[[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row]];
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:0.1];
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//        label.attributedText = attributedString;
//        label.lineBreakMode = NSLineBreakByWordWrapping;
//        label.textAlignment = NSTextAlignmentLeft;
//        label.numberOfLines = 0;
//        label.font = [UIFont fontWithName:@"Lucida Grande-Regular" size:17.f];
//        [label sizeToFit];
//        sizeCell = label.frame.size.height + 60.0;
//        NSLog(@"%f", sizeCell);
//
//        [tableView beginUpdates];
//
//        [tableView endUpdates];
//    } else {
//        NSLog(@"hello");
//    }



//- (CGFloat) labelSize:(NSString *)text  {
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 0)];
//    NSString *string = text;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:0.5];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//    label.attributedText = attributedString;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    label.numberOfLines = 0;
//    label.font = [UIFont fontWithName:@"Lucida_Grande-Regular" size:17.f];
//    [label sizeToFit];
//    CGFloat result = label.frame.size.height;
//
//    return result;
//}



//    } else if (tableView.tag == 2 || tableView.tag == 3){
//
//        if (self.molecule == nil) {
//            return nil;
//        }
//
//        DocsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell" forIndexPath:indexPath];
//        if (cell == nil) {
//            cell = [[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"docCell"];
//        };
//
//        cell.delegate = self;
//        cell.expanded = @"0";
//        cell.title.text = [self clearString:[self.dbManager.arrColumnNames objectAtIndex:indexPath.row]];
//        cell.desc.text = [self clearString:[[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row]];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        return cell;
//
//    } else {
//        return nil;
//    }


//    if (tableView.tag == 1) {
//        return [self.arrPeopleInfo count];
//    } else if (tableView.tag == 2 || tableView.tag == 3){
//        NSInteger x = 0;
//        for (int i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
//            if (![[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""])
//                x++;
//        }
//        return x;
//    } else {
//        return 1;
//    }



//    if (tableView.tag == 1){
//        return 60;
//    } else if (tableView.tag == 2 || tableView.tag == 3) {
//        if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
//            if (open) {
//                return sizeCell;
//            } else {
//                return 60;
//            }
//        } else {
//            return 60;
//        }
//    } else {
//        return 60;
//    }


//- (void) viewWillDisappear:(BOOL)animated {
//
//    [ud removeObjectForKey:@"listOfDrugs"];
//
//
//    [ud removeObjectForKey:@"pharmaList"];
//    [ud removeObjectForKey:@"molecule"];
//    [ud removeObjectForKey:@"comp"];
////    [ud removeObjectForKey:@"workWith"];
//    if ([ud valueForKey:@"listOfDrugs"]) {
//
//    } else {
//        [ud removeObjectForKey:@"workActive"];
//    }
//
//    if ([[ud valueForKey:@"screen"] isEqualToString:@"2"]) {
////        [ud removeObjectForKey:@"listOfDrugs"];
//        rly = true;
//    }
//}

//    if ([[ud valueForKey:@"screen"] isEqualToString:@"2"]) {
//        [ud removeObjectForKey:@"listOfDrugs"];
//        [ud setValue:@"1" forKey:@"screen"];
//    } else if ([[ud valueForKey:@"screen"] isEqualToString:@"1"] && [ud valueForKey:@"listOfDrugs"]) {
//
//    } else {
//        [ud removeObjectForKey:@"workActive"];
//    }

//- (void) viewWillDisappear:(BOOL)animated {
//
//    [ud removeObjectForKey:@"pharmaList"];
//    [ud removeObjectForKey:@"info"];
//    [ud removeObjectForKey:@"molecule"];
//    [ud removeObjectForKey:@"comp"];
//    [ud removeObjectForKey:@"workWith"];
//    if ([ud valueForKey:@"listOfDrugs"]) {
//
//    } else {
//        [ud removeObjectForKey:@"workActive"];
//    }
//
//}

//    ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).tableView.delegate = self;
//    ((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).tableView.dataSource = self;
//    [((SecondDocumentViewController *)[self.childViewControllers objectAtIndex:0]).tableView setTag:2];
//
//    ((DocumentViewController *)[self.childViewControllers objectAtIndex:1]).tableView.delegate = self;
//    ((DocumentViewController *)[self.childViewControllers objectAtIndex:1]).tableView.dataSource = self;
//    [((DocumentViewController *)[self.childViewControllers objectAtIndex:1]).tableView setTag:3];


//    if ([ud valueForKey:@"listOfDrugs"] && [ud valueForKey:@"workACtive"] && [[ud valueForKey:@"screen"] isEqualToString:@"2"]) {
//        [ud removeObjectForKey:@"listOfDrugs"];
//    } else if ([ud valueForKey:@"workACtive"] && [[ud valueForKey:@"screen"] isEqualToString:@"1"]) {
//        [ud removeObjectForKey:@"workActive"];
//    }


//    self.containerView2.hidden = true;
//    self.containerView.hidden = true;
//    self.darkView.hidden = true;
//    container = false;


//    tap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(close)];

//    open = false;
//    rly = false;

//    BOOL container;
//    UITapGestureRecognizer *tap;
//    NSIndexPath *selectedRowIndex;
//    CGFloat sizeCell;
//    BOOL open;
//    BOOL rly;


//            self.containerView.hidden = false;
//            container = true;
//            self.darkView.hidden = false;
//            [self.darkView addGestureRecognizer:tap];


//- (void) perfSeg:(DocsTableViewCell *)sender {
//    if (open) {
//        sender.image.transform = CGAffineTransformMakeRotation(M_PI_2);
//    } else {
//        sender.image.transform = CGAffineTransformMakeRotation(0.0);
//    }
//}


//                self.containerView2.hidden = false;
//                container = true;
//                self.darkView.hidden = false;
//                [self.darkView addGestureRecognizer:tap];

//        if ([ud valueForKey:@"listOfDrugs"]) {
//
//            [ud setValue:@"2" forKey:@"screen"];
//
////            req = [NSString stringWithFormat:@"SELECT Document.*, ClinicoPhPointers.Name as Category FROM Document LEFT JOIN Molecule_Document ON Document.DocumentID = Molecule_Document.DocumentID LEFT JOIN Molecule ON Molecule_Document.MoleculeID = Molecule.MoleculeID LEFT JOIN Document_ClPhPointers ON Document.DocumentID = Document_ClPhPointers.DocumentID LEFT JOIN ClinicoPhPointers ON ClinicoPhPointers.ClPhPointerID = Document_ClPhPointers.SrcClPhPointerID WHERE Molecule.MoleculeID = %@", [ud objectForKey:@"listOfDrugs"]];
//
//            req = [NSString stringWithFormat:@"SELECT Product.DocumentID, Product.RusName FROM Document LEFT JOIN Molecule_Document ON Document.DocumentID = Molecule_Document.DocumentID LEFT JOIN Molecule ON Molecule_Document.MoleculeID = Molecule.MoleculeID INNER JOIN Product_Molecule ON Molecule.MoleculeID = Product_Molecule.MoleculeID INNER JOIN Product ON Product_Molecule.ProductID = Product.ProductID WHERE Molecule.MoleculeID = %@ ORDER BY Document.RusName", [ud objectForKey:@"listOfDrugs"]];
//
//
//            [self loadData:req];
//        } else {

//            [ud setValue:@"1" forKey:@"screen"];

@end
