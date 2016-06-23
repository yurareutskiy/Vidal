//
//  SearchViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 11/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

// ПОПРАВИТЬ DIDSELECTCELLAIINDEX
// НЕПРАВИЛЬНО ВЫБИРАЕТСЯ ИНДЕКС ЯЧЕЙКИ

#import "SearchViewController.h"

@interface SearchViewController ()

@property (nonatomic, strong) IMQuickSearch *quickSearch;
@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSMutableArray *moleculeSearch;
@property (nonatomic, strong) NSMutableArray *drugsSearch;
@property (nonatomic, strong) NSMutableArray *pharmaSearch;
@property (nonatomic, strong) NSMutableArray *prodSearch;

@property (nonatomic, strong) NSMutableArray *drugsFull;
@property (nonatomic, strong) NSMutableArray *moleculeFull;
@property (nonatomic, strong) NSMutableArray *pharmaFull;
@property (nonatomic, strong) NSMutableArray *prodFull;

@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *closeButton;

@property (nonatomic, strong) NSArray *FilteredResults;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableIndexSet *toDelete;

@end

@implementation SearchViewController {
    
    BOOL tableView1b;
    BOOL tableView2b;
    BOOL tableView3b;
    BOOL tableView4b;
    int index;
    int buttonNumber;
    
    NSUserDefaults *ud;
    NSString *next;
    
    NSString *nameToPass;
    NSString *countryToPass;
    NSString *addressToPass;
    NSString *emailToPass;
    NSString *phoneToPass;
    UIImage *imageToPass;
    
    NSString *levelToPass;
    NSString *parentToPass;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [NSMutableArray array];
    
    buttonNumber = 0;
    
    tableView2b = true;
    tableView1b = false;
    tableView3b = false;
    tableView4b = false;
    
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    self.tableView4.delegate = self;
    self.tableView4.dataSource = self;
    self.searchBar.delegate = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    self.moleculeSearch = [NSMutableArray array];
    self.drugsSearch = [NSMutableArray array];
    self.pharmaSearch = [NSMutableArray array];
    self.prodSearch = [NSMutableArray array];
    
    self.drugsFull = [NSMutableArray array];
    self.prodFull = [NSMutableArray array];
    self.pharmaFull = [NSMutableArray array];
    self.moleculeFull = [NSMutableArray array];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    [self loadData:@"select DocumentID, RusName from DocumentListView order by RusName"
         loadData2:@"select MoleculeID, RusName from SubDocumentListView order by RusName"
         loadData3:@"select ClPhPointerID, Name from ClinicoPhPointers where [Level] > 0 order by Code, [Level]"
         loadData4:@"select InfoPageID, RusName from ProducerListView order by RusName"];
    
    self.closeButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"close"] scaledToSize:CGSizeMake(20, 20)]
                                                        style:UIBarButtonItemStyleDone
                                                       target:self
                                                       action:@selector(close)];
    
    self.navigationItem.leftBarButtonItem = self.closeButton;
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    [self setUpQuickSearch:self.moleculeSearch];
    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    
    self.tableView2.hidden = false;
    self.tableView1.hidden = true;
    self.tableView3.hidden = true;
    self.tableView4.hidden = true;
    
    self.navigationItem.title = @"Поиск";

    [self.line1 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
    [self.line2 setBackgroundColor:[UIColor whiteColor]];
    [self.line3 setBackgroundColor:[UIColor whiteColor]];
    [self.line4 setBackgroundColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
    
    [self toDrugs:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FilteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
    }
    
    NSString *title;
    title = [self clearString:self.FilteredResults[indexPath.row]];
    if (!tableView4b) {
        title = [title capitalizedString];
    }
    cell.textLabel.text = title;

    return cell;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    if ([segue.identifier isEqualToString:@"toDoc"]) {
//        
//        DocumentViewController *dvc = [segue destinationViewController];
//        dvc.info = self.data;
//        dvc.dbManager = self.dbManager;
//        
//    } else
    if ([segue.identifier isEqualToString:@"toSecDoc"]) {
    
        SecondDocumentViewController *sdvc = [segue destinationViewController];
        sdvc.info = self.data;
        sdvc.dbManager = self.dbManager;
        
    } else if ([segue.identifier isEqualToString:@"toPharma"]) {
        
    } else if ([segue.identifier isEqualToString:@"toCompany"]) {
        
        CompanyViewController *cvc = [segue destinationViewController];
        
        cvc.name = nameToPass;
        cvc.country = countryToPass;
        cvc.address = addressToPass;
        cvc.email = emailToPass;
        cvc.phone = phoneToPass;
        cvc.logo = imageToPass;
        
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView1b) {
        
        for (int i = 0; i < [self.drugsSearch count]; i++) {
            if ([[self.drugsSearch objectAtIndex:i] isEqualToString:self.FilteredResults[indexPath.row]]) {
                index = i;
                break;
            }
        }
        
        next = [self.drugsFull[index] objectAtIndex:0];
        //        [ud setObject:next forKey:@"molecule"];
        [ud setObject:next forKey:@"id"];
        [ud setObject:@"А" forKey:@"letterDrug"];
        NSString *request = [NSString stringWithFormat:@"select * from DocumentListView doc where doc.DocumentID = %@", next];
        [self getInfo:request];
        
        [self.tableView2 deselectRowAtIndexPath:indexPath animated:NO];
        [self performSegueWithIdentifier:@"toSecDoc" sender:self];
        
    } else if (tableView2b) {
        for (int i = 0; i < [self.moleculeSearch count]; i++) {
            if ([[self.moleculeSearch objectAtIndex:i] isEqualToString:self.FilteredResults[indexPath.row]]) {
                index = i;
                break;
            }
        }
        
        next = [self.moleculeFull[index] objectAtIndex:0];
        //        [ud setObject:next forKey:@"molecule"];
        //        NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompaniesDescription, Molecule.MoleculeID, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозирования', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Molecule_Document ON Document.DocumentID = Molecule_Document.DocumentID INNER JOIN Molecule ON Molecule_Document.MoleculeID = Molecule.MoleculeID WHERE Document.DocumentID = %@", next];
        //        [self getInfo:request];
        [ud setObject:next forKey:@"activeID"];
        [self.tableView1 deselectRowAtIndexPath:indexPath animated:NO];
        [self performSegueWithIdentifier:@"toDoc" sender:self];

        
    } else if (tableView3b) {
        
        for (int i = 0; i < [self.pharmaSearch count]; i++) {
            if ([[self.pharmaSearch objectAtIndex:i] isEqualToString:self.FilteredResults[indexPath.row]]) {
                index = i;
                break;
            }
        }
        
        next = [self.pharmaFull[index] objectAtIndex:0];
//        [ud setObject:next forKey:@"molecule"];
        
        NSString *request = [NSString stringWithFormat:@"SELECT * FROM ClinicoPhPointers WHERE ClinicoPhPointers.ClPhPointerID = %@", next];
        [self getInfo:request];

        [self.tableView3 deselectRowAtIndexPath:indexPath animated:NO];
        [self performSegueWithIdentifier:@"toPharma" sender:self];
        
    } else if (tableView4b) {
        
        for (int i = 0; i < [self.prodSearch count]; i++) {
            if ([[self.prodSearch objectAtIndex:i] isEqualToString:self.FilteredResults[indexPath.row]]) {
                index = i;
                break;
            }
        }
        
        next = [self.prodFull[index] objectAtIndex:0];
        
        [ud setObject:next forKey:@"info"];
        
        [ud setObject:@"prod" forKey:@"howTo"];
        NSString *request = [NSString stringWithFormat:@"select * from ProducerListView where InfoPageID = %@", next];
        [self getInfo:request];
        [ud removeObjectForKey:@"howTo"];
        
        [self.tableView4 deselectRowAtIndexPath:indexPath animated:NO];
        [self performSegueWithIdentifier:@"toCompany" sender:self];
        
    }
    
}

-(void)loadData:(NSString *)req loadData2:(NSString *)req2 loadData3:(NSString *)req3 loadData4:(NSString *)req4{
    
    if (self.moleculeFull != nil) {
        self.moleculeFull = nil;
    }
    
    self.moleculeFull = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req2]];
    self.moleculeFull = [self.moleculeFull valueForKey:@"lowercaseString"];
    
    for (NSArray *key in self.moleculeFull) {
        [self.moleculeSearch addObject:[key objectAtIndex:1]];
    }
    
    if (self.drugsFull != nil) {
        self.drugsFull = nil;
    }
    
    self.drugsFull = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
    self.drugsFull = [self.drugsFull valueForKey:@"lowercaseString"];
    
    for (NSArray *key in self.drugsFull) {
        [self.drugsSearch addObject:[key objectAtIndex:1]];
    }
    
    if (self.pharmaFull != nil) {
        self.pharmaFull = nil;
    }
    
    self.pharmaFull = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req3]];
    
    for (NSArray *key in self.pharmaFull) {
        [self.pharmaSearch addObject:[key objectAtIndex:1]];
    }
    
    if (self.prodFull != nil) {
        self.prodFull = nil;
    }
    
    self.prodFull = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req4]];
    
    for (NSArray *key in self.prodFull) {
        [self.prodSearch addObject:[key objectAtIndex:1]];
    }
    
    // Reload the table view.
    [self.tableView1 reloadData];
    [self.tableView2 reloadData];
    [self.tableView3 reloadData];
    [self.tableView4 reloadData];
    
}

#pragma MAKR - IMQuickSearch Methods

- (void)setUpQuickSearch:(NSMutableArray *)work {
    // Create Filters
    IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:work keys:@[@"description"]];
    self.quickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter]];
}

- (void)filterResults {
    // Asynchronously
    [self.quickSearch asynchronouslyFilterObjectsWithValue:self.searchBar.text completion:^(NSArray *filteredResults) {
        [self updateTableViewWithNewResults:filteredResults];
    }];
}

- (void)updateTableViewWithNewResults:(NSArray *)results {
    self.FilteredResults = results;
    [self.tableView1 reloadData];
    [self.tableView2 reloadData];
    [self.tableView3 reloadData];
    [self.tableView4 reloadData];
}

#pragma MARK - SearchBar Delegate

- (BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
    
    return YES;
}

#pragma MARK - Additional Methods

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) close {
    
    [ud removeObjectForKey:@"activeID"];
    [ud removeObjectForKey:@"from"];
    [ud removeObjectForKey:@"level"];
    [ud removeObjectForKey:@"parent2"];
    [ud removeObjectForKey:@"parent3"];
    [ud removeObjectForKey:@"parent4"];
    [ud removeObjectForKey:@"howTo"];
    [ud removeObjectForKey:@"molecule"];
    [ud removeObjectForKey:@"id"];
    [ud removeObjectForKey:@"info"];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)toDrugs:(UIButton *)sender {
    [self setUpQuickSearch:self.drugsSearch];
    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    
    [self.tableView1 reloadData];
    self.tableView1.hidden = false;
    self.tableView2.hidden = true;
    self.tableView3.hidden = true;
    self.tableView4.hidden = true;
    
    tableView1b = true;
    tableView2b = false;
    tableView3b = false;
    tableView4b = false;
    
    [UIView animateWithDuration:0.05 animations:^{
        [self.scrollView scrollRectToVisible:CGRectMake(0.0, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            [self.line2 setBackgroundColor:[UIColor whiteColor]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                [self.line2 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
                [self.line1 setBackgroundColor:[UIColor whiteColor]];
                [self.line3 setBackgroundColor:[UIColor whiteColor]];
                [self.line4 setBackgroundColor:[UIColor whiteColor]];
            }];
        }];
    }];
    
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.0];
}

- (IBAction)toMolecule:(UIButton *)sender {
    [self setUpQuickSearch:self.moleculeSearch];
    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    
    [self.tableView2 reloadData];
    self.tableView2.hidden = false;
    self.tableView1.hidden = true;
    self.tableView3.hidden = true;
    self.tableView4.hidden = true;
    
    tableView1b = false;
    tableView2b = true;
    tableView3b = false;
    tableView4b = false;
    
    [UIView animateWithDuration:0.05 animations:^{
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width / 4 * 1, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            [self.line4 setBackgroundColor:[UIColor whiteColor]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                [self.line1 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
                [self.line2 setBackgroundColor:[UIColor whiteColor]];
                [self.line3 setBackgroundColor:[UIColor whiteColor]];
                [self.line4 setBackgroundColor:[UIColor whiteColor]];
            }];
        }];
    }];
    
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.0];
}

- (IBAction)toPharma:(UIButton *)sender {
    [self setUpQuickSearch:self.pharmaSearch];
    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    
    [self.tableView3 reloadData];
    self.tableView1.hidden = true;
    self.tableView2.hidden = true;
    self.tableView3.hidden = false;
    self.tableView4.hidden = true;
    
    tableView2b = false;
    tableView1b = false;
    tableView3b = true;
    tableView4b = false;
    
    [UIView animateWithDuration:0.05 animations:^{
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width / 4 * 2, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            [self.line1 setBackgroundColor:[UIColor whiteColor]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                [self.line3 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
                [self.line2 setBackgroundColor:[UIColor whiteColor]];
                [self.line1 setBackgroundColor:[UIColor whiteColor]];
                [self.line4 setBackgroundColor:[UIColor whiteColor]];
            }];
            
        }];
    }];
    
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.0];
}

- (IBAction)toProd:(UIButton *)sender {
    [self setUpQuickSearch:self.prodSearch];
    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    
    [self.tableView4 reloadData];
    self.tableView1.hidden = true;
    self.tableView2.hidden = true;
    self.tableView3.hidden = true;
    self.tableView4.hidden = false;
    
    tableView2b = false;
    tableView1b = false;
    tableView3b = false;
    tableView4b = true;
    
    [UIView animateWithDuration:0.05 animations:^{
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width / 4 * 3, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            [self.line3 setBackgroundColor:[UIColor whiteColor]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                [self.line4 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
                [self.line2 setBackgroundColor:[UIColor whiteColor]];
                [self.line3 setBackgroundColor:[UIColor whiteColor]];
                [self.line1 setBackgroundColor:[UIColor whiteColor]];
            }];
            
        }];
    }];
    
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.0];
    
    
    
}

- (NSString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
    text = [text stringByReplacingOccurrencesOfString:@"<TD colSpan=\"2\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    text = [text stringByReplacingOccurrencesOfString:@"<sup>&trade;</sup>" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"<SUP>&trade;</SUP>" withString:@"®"];
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
    text = [text stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
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
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return text;
    
}

- (void) getInfo:(NSString *)req {
    
    if (tableView1b) {
        
        if (self.data != nil) {
            self.data = nil;
        }
        self.data = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
        
        [ud setObject:[[self.data objectAtIndex:0] objectAtIndex:3] forKey:@"activeID"];
        [[self.data objectAtIndex:0] removeObjectAtIndex:3];
        [self.dbManager.arrColumnNames removeObjectAtIndex:3];
        [ud setObject:@"active" forKey:@"from"];
        
    } else if (tableView2b) {
        
        if (self.data != nil) {
            self.data = nil;
        }
        self.data = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
        self.data = [NSMutableArray arrayWithArray:[self.data objectAtIndex:0]];
        
    } else if (tableView3b) {
        
        if (self.data != nil) {
            self.data = nil;
        }
        self.data = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
        
        [ud setObject:[[self.data objectAtIndex:0] objectAtIndex:3] forKey:@"level"];
        
        if ([[ud objectForKey:@"level"] integerValue] == 1) {
            [ud setObject:[[self.data objectAtIndex:0] objectAtIndex:4] forKey:@"parent1"];
        } else if ([[ud objectForKey:@"level"] integerValue] == 2) {
            [ud setObject:[[self.data objectAtIndex:0] objectAtIndex:4] forKey:@"parent2"];
        } else if ([[ud objectForKey:@"level"] integerValue] == 3) {
            [ud setObject:[[self.data objectAtIndex:0] objectAtIndex:4] forKey:@"parent3"];
        }
        
        [ud setObject:@"search" forKey:@"howTo"];
        
    } else if (tableView4b) {
        
        if (self.data != nil) {
            self.data = nil;
        }
        self.data = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
        
        NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
        NSInteger indexOfRusName = [self.dbManager.arrColumnNames indexOfObject:@"CountryRusName"];
        NSInteger indexOfImage = [self.dbManager.arrColumnNames indexOfObject:@"Image"];
        NSInteger indexOfAddress = [self.dbManager.arrColumnNames indexOfObject:@"RusAddress"];
        NSInteger indexOfEmail = [self.dbManager.arrColumnNames indexOfObject:@"Email"];
        NSInteger indexOfPhone = [self.dbManager.arrColumnNames indexOfObject:@"PhoneNumber"];
        
        nameToPass = [self clearString:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:0] objectAtIndex:indexOfName]]];
        countryToPass = [self clearString:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:0] objectAtIndex:indexOfRusName]]];
        addressToPass = [self clearString:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:0] objectAtIndex:indexOfAddress]]];
        emailToPass = [self clearString:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:0] objectAtIndex:indexOfEmail]]];
        phoneToPass = [self clearString:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:0] objectAtIndex:indexOfPhone]]];
        imageToPass = [UIImage imageWithData:[[self.data objectAtIndex:0] objectAtIndex:indexOfImage]];

    }
    
}

- (IBAction)left:(UIButton *)sender {
    
    if (buttonNumber == 0) {
        
        buttonNumber = 3;
        [self toProd:nil];
//        [UIView animateWithDuration:0.05 animations:^{
//            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width / 4 * 3, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.05 animations:^{
//                [self.line2 setBackgroundColor:[UIColor whiteColor]];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.05 animations:^{
//                    [self.line4 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
//                }];
//            }];
//        }];
        
    } else if (buttonNumber == 1) {
        
        buttonNumber = 0;
        [self toDrugs:nil];

//        [UIView animateWithDuration:0.05 animations:^{
//            [self.scrollView scrollRectToVisible:CGRectMake(0.0, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.05 animations:^{
//                [self.line1 setBackgroundColor:[UIColor whiteColor]];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.05 animations:^{
//                    [self.line2 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
//                }];
//            }];
//        }];
        
    } else if (buttonNumber == 2) {
        
        buttonNumber = 1;
        [self toMolecule:nil];

//        [UIView animateWithDuration:0.05 animations:^{
//            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width / 4 * 1, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.05 animations:^{
//                [self.line3 setBackgroundColor:[UIColor whiteColor]];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.05 animations:^{
//                    [self.line1 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
//                }];
//            }];
//        }];
        
    } else if (buttonNumber == 3) {
        
        buttonNumber = 2;
        [self toPharma:nil];
//        [UIView animateWithDuration:0.05 animations:^{
//            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width / 4 * 2, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.05 animations:^{
//                [self.line4 setBackgroundColor:[UIColor whiteColor]];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.05 animations:^{
//                    [self.line3 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
//                }];
//            }];
//        }];
        
    }
    
}
- (IBAction)right:(UIButton *)sender {
    
    if (buttonNumber == 0) {
        
        buttonNumber = 1;
        [self toMolecule:nil];


        
//        [UIView animateWithDuration:0.05 animations:^{
//            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width / 4 * 1, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.05 animations:^{
//                [self.line2 setBackgroundColor:[UIColor whiteColor]];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.05 animations:^{
//                    [self.line1 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
//                }];
//            }];
//        }];
        
        
        
    } else if (buttonNumber == 1) {
        
        buttonNumber = 2;
        [self toPharma:nil];

//        [UIView animateWithDuration:0.05 animations:^{
//            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width / 4 * 2, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.05 animations:^{
//                [self.line1 setBackgroundColor:[UIColor whiteColor]];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.05 animations:^{
//                    [self.line3 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
//                }];
//                
//            }];
//        }];
        
        
        
    } else if (buttonNumber == 2) {
        
        buttonNumber = 3;
        [self toProd:nil];
//        [UIView animateWithDuration:0.05 animations:^{
//            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width / 4 * 3, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.05 animations:^{
//                [self.line3 setBackgroundColor:[UIColor whiteColor]];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.05 animations:^{
//                    [self.line4 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
//                }];
//                
//            }];
//        }];
        
    } else if (buttonNumber == 3) {
        
        buttonNumber = 0;
        [self toDrugs:nil];

//        [UIView animateWithDuration:0.05 animations:^{
//            [self.scrollView scrollRectToVisible:CGRectMake(0.0, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.05 animations:^{
//                [self.line4 setBackgroundColor:[UIColor whiteColor]];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.05 animations:^{
//                    [self.line2 setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:0 blue:57.0/255.0 alpha:1.0]];
//                }];
//            }];
//        }];
    }
    
}

@end
