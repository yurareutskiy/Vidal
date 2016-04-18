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
@property (nonatomic, strong) NSMutableArray *drugsFull;
@property (nonatomic, strong) NSMutableArray *moleculeFull;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *closeButton;
@property (nonatomic, strong) NSArray *FilteredResults;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableIndexSet *toDelete;

@end

@implementation SearchViewController {
    
    BOOL container;
    BOOL tableView1b;
    BOOL tableView2b;
    int index;
    NSUserDefaults *ud;
    UITapGestureRecognizer *tap;
    NSIndexPath *selectedRowIndex;
    NSString *next;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[super setLabel:@"Список препаратов"];
    
    self.data = [NSMutableArray array];
    self.toDelete = [NSMutableIndexSet indexSet];
    
    container = false;
    tableView1b = true;
    tableView2b = false;
    
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.searchBar.delegate = self;
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.delegate = self;
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.dataSource = self;
    [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView setTag:3];
    ((DocumentViewController *)self.childViewControllers.lastObject).tableView.delegate = self;
    ((DocumentViewController *)self.childViewControllers.lastObject).tableView.dataSource = self;
    [((DocumentViewController *)self.childViewControllers.lastObject).tableView setTag:4];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    self.moleculeSearch = [NSMutableArray array];
    self.drugsSearch = [NSMutableArray array];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    self.tableView1.hidden = true;
    self.tableView2.hidden = true;
    
    [self loadData:@"SELECT * FROM Document INNER JOIN Product ON Document.DocumentID = Product.ProductID ORDER BY Product.RusName"
         loadData2:@"SELECT * FROM Document INNER JOIN Molecule_Document ON Document.DocumentID = Molecule_Document.DocumentID INNER JOIN Molecule ON Molecule_Document.MoleculeID = Molecule.MoleculeID ORDER BY Molecule.RusName"];
    
    self.closeButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"close"] scaledToSize:CGSizeMake(20, 20)]
                                                        style:UIBarButtonItemStyleDone
                                                       target:self
                                                       action:@selector(close)];
    
    self.navigationItem.leftBarButtonItem = self.closeButton;
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    [self setUpQuickSearch:self.moleculeSearch];
    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    
    self.tableView1.hidden = false;
    self.tableView2.hidden = true;
    
    [self.button2 setBackgroundColor:[UIColor colorWithRed:183.0/255.0 green:1.0/255.0 blue:57.0/255.0 alpha:1]];
    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.button1 setTitleColor:[UIColor colorWithRed:183.0/255.0 green:1.0/255.0 blue:57.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.button1 setBackgroundColor:[UIColor whiteColor]];
    
    self.darkView.hidden = true;
    self.containerView1.hidden = true;
    self.containerView2.hidden = true;
    
    tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(closeContainer)];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeContainer {
    
    self.darkView.hidden = true;
    self.containerView2.hidden = true;
    self.containerView1.hidden = true;
    [self.view removeGestureRecognizer:tap];
    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1 || tableView.tag == 2) {
        return 60;
    } else if (tableView.tag == 3 || tableView.tag == 4) {
        if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
            return 140;
        } else {
            return 60;
        }
    } else {
        return 60;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1 || tableView.tag == 2){
        
        return self.FilteredResults.count;
        
    } else if (tableView.tag == 3 || tableView.tag == 4) {
        if ([self.data count] != 0) {
            NSInteger x = 0;
            for (int i = 0; i < [[self.data objectAtIndex:0] count]; i++) {
                if (![[[self.data objectAtIndex:0] objectAtIndex:i] isEqualToString:@""])
                    x++;
            }
        return x;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1 || tableView.tag == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
        }
        
        // Set Content
        NSString *title, *subtitle;
        title = self.FilteredResults[indexPath.row];
        subtitle = self.FilteredResults[indexPath.row];
        cell.textLabel.text = title;
        cell.detailTextLabel.text = subtitle;
        
        // Return Cell
        return cell;
        
    } else if (tableView.tag == 3 || tableView.tag == 4) {
        if ([self.data count] != 0) {
            if ([[[self.data objectAtIndex:0] objectAtIndex:indexPath.row] isEqualToString:@""]) {
                return nil;
            }
        
            DocsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell"];
            if (cell == nil) {
                cell = [[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"docCell"];
            };
        
            cell.title.text = [NSString stringWithFormat:@"%@", [self.dbManager.arrColumnNames objectAtIndex:indexPath.row]];
            cell.desc.text = [[self.data objectAtIndex:0] objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            return cell;
        } else {
            DocsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell"];
            if (cell == nil) {
                cell = [[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"docCell"];
            };
            return cell;
        }
    } else {
        return nil;
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1 || tableView.tag == 2) {
    if (tableView1b) {
        
        for (int i = 0; i < [self.moleculeSearch count]; i++) {
            if ([[self.moleculeSearch objectAtIndex:i] isEqualToString:self.FilteredResults[indexPath.row]]) {
                index = i;
                break;
            }
        }
        
        next = [self.moleculeFull[indexPath.row] objectAtIndex:26];
        [ud setObject:next forKey:@"molecule"];
        NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозировки', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Molecule_Document ON Document.DocumentID = Molecule_Document.DocumentID INNER JOIN Molecule ON Molecule_Document.MoleculeID = Molecule.MoleculeID WHERE Molecule.MoleculeID = %@", next];
        [self getInfo:request];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.darkView.hidden = false;
        self.containerView1.hidden = false;
        [self.view addGestureRecognizer:tap];
        
    } else if (tableView2b) {
        
        for (int i = 0; i < [self.drugsSearch count]; i++) {
            if ([[self.drugsSearch objectAtIndex:i] isEqualToString:self.FilteredResults[indexPath.row]]) {
                index = i;
                break;
            }
        }
        
        next = [self.drugsFull[indexPath.row] objectAtIndex:24];
        [ud setObject:next forKey:@"molecule"];
        NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозировки', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Product ON Document.DocumentID = Product.DocumentID WHERE Product.ProductID = %@", next];
        [self getInfo:request];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.darkView.hidden = false;
        self.containerView2.hidden = false;
        [self.view addGestureRecognizer:tap];
        
    }
    
    } else if (tableView.tag == 3 || tableView.tag == 4) {
        selectedRowIndex = [indexPath copy];
    
        [tableView beginUpdates];
            
        [tableView endUpdates];
    }
    
}

-(void)loadData:(NSString *)req loadData2:(NSString *)req2{
    
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
    
    // Reload the table view.
    [self.tableView1 reloadData];
    [self.tableView2 reloadData];
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
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)toDrugs:(UIButton *)sender {
    [self setUpQuickSearch:self.drugsSearch];
    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    [self.tableView2 reloadData];
    self.tableView2.hidden = false;
    self.tableView1.hidden = true;
    [self.button1 setBackgroundColor:[UIColor colorWithRed:183.0/255.0 green:1.0/255.0 blue:57.0/255.0 alpha:1]];
    [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor colorWithRed:183.0/255.0 green:1.0/255.0 blue:57.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.button2 setBackgroundColor:[UIColor whiteColor]];
    tableView2b = true;
    tableView1b = false;
}

- (IBAction)toMolecule:(UIButton *)sender {
    [self setUpQuickSearch:self.moleculeSearch];
    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    [self.tableView1 reloadData];
    self.tableView1.hidden = false;
    self.tableView2.hidden = true;
    [self.button2 setBackgroundColor:[UIColor colorWithRed:183.0/255.0 green:1.0/255.0 blue:57.0/255.0 alpha:1]];
    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor colorWithRed:183.0/255.0 green:1.0/255.0 blue:57.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.button1 setBackgroundColor:[UIColor whiteColor]];
    tableView2b = false;
    tableView1b = true;
}

- (void) getInfo:(NSString *)req {
    
    if (tableView1b) {
        
        if (self.data != nil) {
            self.data = nil;
        }
        self.data = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];

        for (NSUInteger i = 0; i < [[self.data objectAtIndex:0] count]; i++) {
            if ([[[self.data objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
                || [[[self.data objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
                [self.toDelete addIndex:i];
        }
    
        ((DocumentViewController *)self.childViewControllers.lastObject).latName.text = [[[self.data objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"];
        ((DocumentViewController *)self.childViewControllers.lastObject).name.text = [[[self.data objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"];
    
        [self.toDelete addIndex:0];
        [self.toDelete addIndex:1];
    
        [[self.data objectAtIndex:0] removeObjectsAtIndexes:self.toDelete];
        [self.dbManager.arrColumnNames removeObjectsAtIndexes:self.toDelete];
    
        [((DocumentViewController *)self.childViewControllers.lastObject).tableView reloadData];
        
    } else if (tableView2b) {
        
        if (self.data != nil) {
            self.data = nil;
        }
        self.data = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
        
        for (NSUInteger i = 0; i < [[self.data objectAtIndex:0] count]; i++) {
            if ([[[self.data objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
                || [[[self.data objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
                [self.toDelete addIndex:i];
        }
        
        ((SecondDocumentViewController *)self.childViewControllers.lastObject).latName.text = [[[self.data objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"];
        ((SecondDocumentViewController *)self.childViewControllers.lastObject).name.text = [[[self.data objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"];
        
        [self.toDelete addIndex:0];
        [self.toDelete addIndex:1];
        
        [[self.data objectAtIndex:0] removeObjectsAtIndexes:self.toDelete];
        [self.dbManager.arrColumnNames removeObjectsAtIndexes:self.toDelete];
        
        [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView reloadData];
        
    }
    
}
@end
