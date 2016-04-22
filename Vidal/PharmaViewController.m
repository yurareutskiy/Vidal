//
//  PharmaViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "PharmaViewController.h"

@interface PharmaViewController ()

@property (nonatomic, strong) NSArray *firstSectionStrings;
@property (nonatomic, strong) NSArray *secondSectionStrings;
@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) NSMutableIndexSet *expandableSections;
@property (nonatomic, strong) NSMutableArray *arrPeopleInfo;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *tryArray;
@property (nonatomic, strong) NSMutableArray *molecule;
@property (strong, nonatomic) UIBarButtonItem *searchButton;

@end

@implementation PharmaViewController {

    BOOL container;
    UITapGestureRecognizer *tap;
    NSUserDefaults *ud;
    NSString *req;
    NSMutableIndexSet *toDelete;
    NSIndexPath *selectedRowIndex;
    CGFloat sizeCell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.delegate = self;
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.dataSource = self;
    [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView setTag:2];
    
    ud = [NSUserDefaults standardUserDefaults];
        [ud removeObjectForKey:@"info"];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    [super setLabel:@"Фармакологические группы"];
    
    toDelete = [NSMutableIndexSet indexSet];
    
    self.containerView.hidden = true;
    self.darkView.hidden = true;
    container = false;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(close)];
    
    
    //    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
    //                                                         style:UIBarButtonItemStyleDone
    //                                                        target:self
    //                                                        action:@selector(search)];
    
    //    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    // Do any additional setup after loading the view.
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    req = @"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = 1 ORDER BY ClinicoPhPointers.Name";
    
    
    
    [self loadData:req];
    
}

#pragma mark - SLExpandableTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1){
        return 67;
    } else if (tableView.tag == 2) {
        if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
            return sizeCell + 7;
        } else {
            return 67;
        }
    } else {
        return 67;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return [self.arrPeopleInfo count];
    } else if (tableView.tag == 2){
        NSInteger x = 0;
        for (int i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
            if (![[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""])
                x++;
        }
        return x;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        
            PharmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pharmaCell" forIndexPath:indexPath];
            
            NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
            
            // Set the loaded data to the appropriate cell labels.
        cell.name.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname]]];
            
            return cell;
        
        } else if (tableView.tag == 2){
        
        if ([[[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row] isEqualToString:@""]) {
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self segueToBe:indexPath.row];
    [self loadData:req];
    
    
}

- (void) segueToBe:(NSInteger)xid {
    
    NSInteger product = [self.dbManager.arrColumnNames indexOfObject:@"ShowInProduct"];
    NSInteger parent = [self.dbManager.arrColumnNames indexOfObject:@"Code"];
    NSInteger level = [self.dbManager.arrColumnNames indexOfObject:@"Level"];
    NSInteger pointID = [self.dbManager.arrColumnNames indexOfObject:@"ClPhPointerID"];
    
    // Set the loaded data to the appropriate cell labels.
    
    NSString *productStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:product]];
    NSString *parentStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:parent]];
    NSString *levelStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:level]];
    NSString *pointIDStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:pointID]];
    
    NSString *req2 = [NSString stringWithFormat:@"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = %ld AND ClinicoPhPointers.ParentCode = '%@' ORDER BY ClinicoPhPointers.Name", [levelStr integerValue] + 1, parentStr];
    
    BOOL goNext = [self checkData:req2];
    
    if (!goNext) {
        
        NSString *request = [NSString stringWithFormat:@"SELECT Document.DocumentID, Document.RusName, Document.EngName, Document.CompaniesDescription, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозировки', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Document_ClPhPointers ON Document.DocumentID = Document_ClPhPointers.DocumentID INNER JOIN ClinicoPhPointers ON Document_ClPhPointers.ClPhPointerID = ClinicoPhPointers.ClPhPointerID WHERE ClinicoPhPointers.ClPhPointerID = %@", pointIDStr];
        [self getMol:request];

        [self performSegueWithIdentifier:@"toList" sender:self];
        
//        if (!container) {
//            self.containerView.hidden = false;
//            container = true;
//            self.darkView.hidden = false;
//            [self.darkView addGestureRecognizer:tap];
//        }
        
        
    } else if (goNext){
        [ud setObject:levelStr forKey:@"level"];
        [ud setObject:parentStr forKey:@"parent"];
        [self performSegueWithIdentifier:@"toLevel" sender:self];
        NSLog(@"%d %@", levelStr.intValue + 1, parentStr);
    }
    
}

-(void)loadData:(NSString *)req {
    // Form the query.
    NSString *query = [NSString stringWithFormat:req];
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tableView reloadData];
}

-(BOOL)checkData:(NSString *)req {
    // Form the query.
    NSString *query = [NSString stringWithFormat:req];
    
    // Get the results.
    if (self.tryArray != nil) {
        self.tryArray = nil;
    }
    self.tryArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if ([self.tryArray count] == 0){
        return NO;
    } else {
        return YES;
    }
}

- (void) close {
    self.containerView.hidden = true;
    container = false;
    [self.darkView removeGestureRecognizer:tap];
    self.darkView.hidden = true;
    [((UITableView *)[self.view viewWithTag:2]) deselectRowAtIndexPath:selectedRowIndex animated:YES];
}

- (void) getMol:(NSString *)mol {
    if (self.molecule != nil) {
        self.molecule = nil;
    }
    self.molecule = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:mol]];
    if ([self.molecule count] != 0) {
    for (NSUInteger i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
        if ([[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""] || [[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"]) {
            [toDelete addIndex:i];
        }
    }
    
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).latName.text = [[[self.molecule objectAtIndex:0] objectAtIndex:2] valueForKey:@"lowercaseString"];
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).name.text = [[[self.molecule objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"];
    if (![[[self.molecule objectAtIndex:0] objectAtIndex:3] isEqualToString:@""]) {
        ((SecondDocumentViewController *)self.childViewControllers.lastObject).registred.text = [[self.molecule objectAtIndex:0] objectAtIndex:2];
        [toDelete addIndex:2];
    }

    [ud setObject:[[self.molecule objectAtIndex:0] objectAtIndex:0] forKey:@"id"];
    [toDelete addIndex:0];
    [toDelete addIndex:1];
    
    [[self.molecule objectAtIndex:0] removeObjectsAtIndexes:toDelete];
    [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
    
        if ([((NSArray *)[ud objectForKey:@"favs"]) containsObject:[ud objectForKey:@"id"]]) {
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:((SecondDocumentViewController *)self.childViewControllers.lastObject).fav.titleLabel.text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255.0 green:0.0 blue:57.0/255.0 alpha:1], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
            
            [((SecondDocumentViewController *)self.childViewControllers.lastObject).fav setAttributedTitle:result forState:UIControlStateNormal];
            [((SecondDocumentViewController *)self.childViewControllers.lastObject).fav setImage:[UIImage imageNamed:@"favRed"] forState:UIControlStateNormal];
        } else {
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:((SecondDocumentViewController *)self.childViewControllers.lastObject).fav.titleLabel.text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
            
            [((SecondDocumentViewController *)self.childViewControllers.lastObject).fav setAttributedTitle:result forState:UIControlStateNormal];
            [((SecondDocumentViewController *)self.childViewControllers.lastObject).fav setImage:[UIImage imageNamed:@"favGrey"] forState:UIControlStateNormal];
        }
        
    [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView reloadData];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Пустая категория" message:@"Для этой категории отсутствуют препараты" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
