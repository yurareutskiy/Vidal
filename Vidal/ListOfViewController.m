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
    BOOL container;
    UITapGestureRecognizer *tap;
    NSString *req;
    NSMutableIndexSet *toDelete;
    NSIndexPath *selectedRowIndex;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    toDelete = [NSMutableIndexSet indexSet];
    [self.tableView setTag:1];
    
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.delegate = self;
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.dataSource = self;
    [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView setTag:2];
    
    self.containerView.hidden = true;
    self.darkView.hidden = true;
    container = false;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(close)];
    if ([ud objectForKey:@"molecule"]) {
    req = [NSString stringWithFormat:@"SELECT Product.DocumentID, Product.RusName AS 'Продукт', Molecule.RusName, Molecule.MoleculeID FROM Molecule INNER JOIN Product_Molecule ON Molecule.MoleculeID = Product_Molecule.MoleculeID INNER JOIN Product ON Product_Molecule.ProductID = Product.ProductID WHERE Molecule.MoleculeID = %@ ORDER BY Molecule.RusName", [ud objectForKey:@"molecule"]];
    } else if ([ud objectForKey:@"comp"]) {
        req = [NSString stringWithFormat:@"SELECT Product.DocumentID,  Product.RusName AS 'Продукт' FROM Product WHERE Product.CompanyID = %@ ORDER BY Product.RusName", [ud objectForKey:@"comp"]];
    }
    
    [self loadData:req];
    
    // Do any additional setup after loading the view.
}

- (void) viewDidDisappear:(BOOL)animated {
    [ud removeObjectForKey:@"molecule"];
    [ud removeObjectForKey:@"comp"];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1){
        return 60;
    } else if (tableView.tag == 2) {
        if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
            return 400;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
    PharmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pharmaCell"];
    if (cell == nil) {
        cell = [[PharmaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    };
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"Продукт"];
        
        // Set the loaded data to the appropriate cell labels.
    cell.name.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname]];
        
    return cell;
    } else if (tableView.tag == 2){
        
        if (self.molecule == nil) {
            return nil;
        }
        
        DocsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell"];
        if (cell == nil) {
            cell = [[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"docCell"];
        };
        
        cell.title.text = [NSString stringWithFormat:@"%@", [self.dbManager.arrColumnNames objectAtIndex:indexPath.row]];
        cell.desc.text = [[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        return nil;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!container) {
        self.containerView.hidden = false;
        container = true;
        self.darkView.hidden = false;
        [self.darkView addGestureRecognizer:tap];
        
        [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] forKey:@"drug"];
        NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозировки', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document WHERE Document.DocumentID = %@", [ud objectForKey:@"drug"]];
        //            INNER JOIN Product ON Document.DocumentID = Product.DocumentID
        NSLog(@"%@", request);
        [self getMol:request];
    }} else if (tableView.tag == 2){
        selectedRowIndex = [indexPath copy];
        
        [tableView beginUpdates];
        
        [tableView endUpdates];
    } else {
        NSLog(@"hello");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) close {
    self.containerView.hidden = true;
    container = false;
    [self.darkView removeGestureRecognizer:tap];
    self.darkView.hidden = true;
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert title" message:@"Alert message" preferredStyle:UIAlertControllerStyleAlert];
        
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
    
    for (NSUInteger i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
        if ([[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
            || [[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
            [toDelete addIndex:i];
    }
    
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).latName.text = [[[self.molecule objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"];
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).name.text = [[[self.molecule objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"];
    
    [toDelete addIndex:0];
    [toDelete addIndex:1];
    
    [[self.molecule objectAtIndex:0] removeObjectsAtIndexes:toDelete];
    [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
    
    [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView reloadData];
    
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
