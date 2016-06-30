//
//  ListOfViewController.m
//
//
//  Created by Anton Scherbakov on 10/04/16.
//
//

#import "ListOfViewController.h"
#import "SearchViewController.h"
#import "StringFormatter.h"

@interface ListOfViewController ()

@property (nonatomic, strong) NSMutableArray *arrPeopleInfo;
@property (nonatomic, strong) NSMutableArray *molecule;
@property (strong, nonatomic) NSString *req;
@property (assign, nonatomic) SearchType seatchType;

@end

@implementation ListOfViewController {
    
    NSUserDefaults *ud;
    NSMutableIndexSet *toDelete;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    toDelete = [NSMutableIndexSet indexSet];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    [self refreshDb];
    
    // Do any additional setup after loading the view.
}

- (void) setNavBarTitle:(NSString *)name {
    
    self.navigationItem.title = name;
    self.navigationItem.leftBarButtonItem.title = @"";
    
}

- (void) refreshDb {
    
    if ([ud valueForKey:@"activeID"]) {
        
        self.req = [NSString stringWithFormat:@"select doc.DocumentID as DocumentID, doc.RusName as RusName, doc.EngName as EngName, doc.Elaboration as Elaboration, doc.CompaniesDescription as CompaniesDescription, doc.CompiledComposition as CompiledComposition, doc.CategoryName  as Category, doc.PhInfluence as PhInfluence, doc.PhKinetics as PhKinetics, doc.Indication as Indication, doc.Dosage as Dosage, doc.SideEffects as SideEffects, doc.ContraIndication as ContraIndication, doc.Lactation as Lactation, doc.SpecialInstruction as SpecialInstruction, doc.OverDosage as OverDosage, doc.Interaction as Interaction, doc.PharmDelivery as PharmDelivery, doc.StorageCondition as StorageCondition, InfoPage.RusName as InfoPageName from DocumentListView  doc INNER JOIN Document_InfoPage ON Document_InfoPage.DocumentID = doc.DocumentID INNER JOIN InfoPage ON InfoPage.InfoPageID = Document_InfoPage.InfoPageID  where exists(	select 1 from Product_Molecule pm 	inner join Product pr on pr.ProductID = pm.ProductID 	where pr.DocumentID = doc.DocumentID and pm.MoleculeID = %@) order by doc.RusName", [ud valueForKey:@"activeID"]];
        
        [self setNavBarTitle:@"Препараты"];
        
        self.seatchType = SearchDrug;
        
        [self loadData:self.req];
        
    } else if ([ud objectForKey:@"molecule"]) {
        self.req = [NSString stringWithFormat:@"SELECT Product.DocumentID, Product.RusName AS 'Продукт', Product.EngName, Molecule.RusName, Molecule.MoleculeID FROM Molecule INNER JOIN Product_Molecule ON Molecule.MoleculeID = Product_Molecule.MoleculeID INNER JOIN Product ON Product_Molecule.ProductID = Product.ProductID WHERE Molecule.MoleculeID = %@ ORDER BY Molecule.RusName", [ud objectForKey:@"molecule"]];
        
        [self setNavBarTitle:@"Препараты"];
        self.seatchType = SearchDrug;
        
        [self loadData:self.req];
    } else if ([ud valueForKey:@"pharmaList"]) {
        
        self.req = [NSString stringWithFormat:@"SELECT DocumentListView.DocumentID, RusName, EngName, CompaniesDescription, Elaboration, CompiledComposition, CategoryName as Category, PhInfluence, PhKinetics, Indication, Dosage, SideEffects, ContraIndication, Lactation, SpecialInstruction, OverDosage, Interaction, PharmDelivery, StorageCondition FROM DocumentListView INNER JOIN Document_ClPhPointers ON DocumentListView.DocumentID = Document_ClPhPointers.DocumentID INNER JOIN ClinicoPhPointers ON Document_ClPhPointers.ClPhPointerID = ClinicoPhPointers.ClPhPointerID WHERE ClinicoPhPointers.ClPhPointerID = %@", [ud valueForKey:@"pharmaList"]];
        
        [self setNavBarTitle:@"Фармакологические группы"];
        self.seatchType = SearchPharmGroup;
        [self loadData:self.req];
        
    } else if ([ud valueForKey:@"letterDrug"]) {
        
        [self setNavBarTitle:@"Препараты"];
        self.seatchType = SearchDrug;

        self.req = [NSString stringWithFormat:@"select DocumentListView.DocumentID as DocumentID, DocumentListView.RusName as RusName, DocumentListView.EngName as EngName, DocumentListView.CompaniesDescription as CompaniesDescription, DocumentListView.Elaboration as Elaboration, DocumentListView.CompiledComposition as CompiledComposition, DocumentListView.CategoryName as Category, DocumentListView.PhInfluence as PhInfluence, DocumentListView.PhKinetics as PhKinetics, DocumentListView.Indication as Indication, DocumentListView.Dosage as Dosage, DocumentListView.SideEffects as SideEffects, DocumentListView.ContraIndication as ContraIndication, DocumentListView.Lactation as Lactation, DocumentListView.SpecialInstruction as SpecialInstruction, DocumentListView.OverDosage as OverDosage, DocumentListView.Interaction as Interaction, DocumentListView.PharmDelivery as PharmDelivery, DocumentListView.StorageCondition as StorageCondition , InfoPage.RusName as InfoPageName from DocumentListView LEFT JOIN Document_InfoPage ON Document_InfoPage.DocumentID = DocumentListView.DocumentID LEFT JOIN InfoPage ON InfoPage.InfoPageID = Document_InfoPage.InfoPageID where Letter = '%@' order by DocumentListView.RusName", [ud valueForKey:@"letterDrug"]];

        [self loadData:self.req];
        
    }  else if ([ud valueForKey:@"letterActive"]) {
        
        [self setNavBarTitle:@"Активные вещества"];
        self.seatchType = SearchMolecule;
        
        self.req = [NSString stringWithFormat:@"select * from SubDocumentListView where Letter = '%@' OR Letter = '%@' order by RusName", [[ud valueForKey:@"letterActive"] valueForKey:@"uppercaseString"], [[ud valueForKey:@"letterActive"] valueForKey:@"lowercaseString"]];
        
        [self loadData:self.req];
        
    } else if ([ud valueForKey:@"info"] || [ud valueForKey:@"comp"]) {
        
        self.req = [NSString stringWithFormat:@"select DocumentID, RusName, EngName, Elaboration, CompaniesDescription, CompiledComposition, PhInfluence, PhKinetics, Indication, Dosage, SideEffects, ContraIndication, Lactation, SpecialInstruction, OverDosage, Interaction, PharmDelivery, StorageCondition from ProducerDocListView where InfoPageID = %@ order by RusName", [ud valueForKey:@"info"]];
        
        [self loadData:self.req];
        self.seatchType = SearchDrug;
        
    } else {
        self.req = @"";
        [self loadData:self.req];
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self refreshDb];
    [self.tableView reloadData];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    if (self.isMovingFromParentViewController) {
        [ud setObject:@"drugs" forKey:@"from"];
        [ud setObject:@"back" forKey:@"howTo"];
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
    
    // Set the loaded data to the appropriate cell labels.
    [cell.name setTextColor:[UIColor blackColor]];
    
    if ([ud valueForKey:@"letterDrug"]) {
        
        NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
        NSInteger indexOfCategory = [self.dbManager.arrColumnNames indexOfObject:@"Category"];
        NSInteger indexOfElaboration = [self.dbManager.arrColumnNames indexOfObject:@"Elaboration"];
        NSInteger indexOfEngName = [self.dbManager.arrColumnNames indexOfObject:@"InfoPageName"];
        
        cell.elaboration.text = [StringFormatter clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfElaboration]];
        cell.name.text = [self formatNameString: [StringFormatter clearString:[[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname] lowercaseString]]];
        cell.category.text = [StringFormatter clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCategory]];
        cell.latName.text = [StringFormatter clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfEngName]];
        
        
        
    } else if ([ud valueForKey:@"activeID"]) {
        
        NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
        NSInteger indexOfCategory = [self.dbManager.arrColumnNames indexOfObject:@"Category"];
        NSInteger indexOfElaboration = [self.dbManager.arrColumnNames indexOfObject:@"Elaboration"];
        NSInteger indexOfPageName = [self.dbManager.arrColumnNames indexOfObject:@"InfoPageName"];
        cell.elaboration.text = [StringFormatter clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfElaboration]];
        cell.name.text = [self formatNameString: [StringFormatter clearString:[[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname] lowercaseString]]];
        cell.category.text = [StringFormatter clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCategory]];
        cell.latName.text = [StringFormatter clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfPageName]]];
        
    } else if ([ud valueForKey:@"letterActive"]) {
        
        NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
        NSInteger indexOfCategory = [self.dbManager.arrColumnNames indexOfObject:@"CategoryName"];
        NSInteger indexOfEngName = [self.dbManager.arrColumnNames indexOfObject:@"LatName"];
        
        
        cell.name.text = [StringFormatter clearString:[[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname] lowercaseString]];
        cell.category.text = [StringFormatter clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCategory]];
        cell.latName.text = [StringFormatter clearString:[[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfEngName]] valueForKey:@"lowercaseString"]];
        
    } else if ([ud valueForKey:@"info"] || [ud valueForKey:@"comp"]) {
        
        NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
        NSInteger indexOfElaboration = [self.dbManager.arrColumnNames indexOfObject:@"Elaboration"];
        NSInteger indexOfEngName = [self.dbManager.arrColumnNames indexOfObject:@"EngName"];
        
        cell.elaboration.text = [StringFormatter clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfElaboration]];
        cell.name.text = [self formatNameString: [StringFormatter clearString:[[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName] lowercaseString]]];
        cell.category.text = @"";
        cell.latName.text = [StringFormatter clearString:[[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfEngName]] valueForKey:@"lowercaseString"]];
        
    } else if ([ud valueForKey:@"pharmaList"]) {
        
        NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
        NSInteger indexOfCategory = [self.dbManager.arrColumnNames indexOfObject:@"Category"];
        NSInteger indexOfElaboration = [self.dbManager.arrColumnNames indexOfObject:@"Elaboration"];
        NSInteger indexOfEngName = [self.dbManager.arrColumnNames indexOfObject:@"EngName"];
        
        cell.elaboration.text = [StringFormatter clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfElaboration]];
        cell.name.text = [StringFormatter clearString:[[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName]] valueForKey:@"lowercaseString"]];
        cell.category.text = [StringFormatter clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCategory]]];
        cell.latName.text = [StringFormatter clearString:[[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfEngName]] valueForKey:@"lowercaseString"]];
        
    }
    
    else if ([ud valueForKey:@"workActive"] && ([self.activeID isEqualToString:@""] || self.activeID == nil)) {
        if (![[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@""]) {
            cell.category.text = [StringFormatter clearString:[[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:2]] valueForKey:@"lowercaseString"]];
            [cell.category setTextColor:[UIColor lightGrayColor]];
        } else {
            cell.category.text = @"";
        }
    } else if ([ud valueForKey:@"activeID"]) {
        
        cell.name.text = [StringFormatter clearString:[[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:1]] valueForKey:@"lowercaseString"]];
        [cell.name setTextColor:[UIColor blackColor]];
        cell.category.text = @"";
        
    } else if ([ud valueForKey:@"pharmaList"]) {
        cell.name.text = [StringFormatter clearString:[[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:1]] valueForKey:@"lowercaseString"]];
        [cell.name setTextColor:[UIColor blackColor]];
        cell.category.text = @"";
    } else if ([ud valueForKey:@"comp"]) {
        cell.name.text = [StringFormatter clearString:[[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:2]] valueForKey:@"lowercaseString"]];
        [cell.name setTextColor:[UIColor blackColor]];
        cell.category.text = @"";
    } else if ([ud valueForKey:@"info"]) {
        cell.name.text = [StringFormatter clearString:[[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:2]] valueForKey:@"lowercaseString"]];
        [cell.name setTextColor:[UIColor blackColor]];
        cell.category.text = @"";
    } else {
        cell.category.text = @"";
    }
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([ud valueForKey:@"letterDrug"] || [ud valueForKey:@"comp"] || [ud valueForKey:@"pharmaList"] || [ud valueForKey:@"activeID"] || [ud valueForKey:@"info"]) {
        
        NSInteger indexOfDocumentID;
        
        if ([ud valueForKey:@"pharmaList"]) {
            indexOfDocumentID = [self.dbManager.arrColumnNames indexOfObject:@"DocumentListView.DocumentID"];
        } else {
            indexOfDocumentID = [self.dbManager.arrColumnNames indexOfObject:@"DocumentID"];
        }
        
        
        
        self.molecule = [NSMutableArray arrayWithArray:[self.arrPeopleInfo objectAtIndex:indexPath.row]];
        [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfDocumentID] forKey:@"id"];
        [self performSegueWithIdentifier:@"toSecDoc" sender:self];
        
    } else if ([ud valueForKey:@"letterActive"]) {
        
        NSInteger indexOfDocumentID = [self.dbManager.arrColumnNames indexOfObject:@"MoleculeID"];
        
        [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfDocumentID] forKey:@"activeID"];
        [self performSegueWithIdentifier:@"toDoc" sender:self];
        
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Нет таких препаратов" message:@"Попробуйте нажать на другую букву" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [self.navigationController popViewControllerAnimated:YES];
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        if (([ud valueForKey:@"info"] || [ud valueForKey:@"comp"]) && [[ud valueForKey:@"info"] isEqualToString:@"63"]) {
            NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
            for (NSArray *element in self.arrPeopleInfo) {
                if ([element[indexOfName] isEqualToString:@"КАРДИОМАГНИЛ"]) {
                    NSArray *object = [element copy];
                    [self.arrPeopleInfo removeObject:element];
                    [self.arrPeopleInfo insertObject:object atIndex:0];
                    break;
                }
            }
        }
        [self.tableView reloadData];
    }
    
    // Reload the table view.
    
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toSecDoc"]) {
        
        SecondDocumentViewController *sdvc = [segue destinationViewController];
        
        sdvc.info = self.molecule;
        sdvc.dbManager = self.dbManager;
        
    }
    
}



- (void) search {
    SearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [vc setSearchType:self.seatchType];
    [self.navigationController pushViewController:vc animated:NO];
}

@end
