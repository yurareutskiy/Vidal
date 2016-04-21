//
//  FourthViewController.m
//  Vidal
//
//  Created by Test Account on 05/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController ()

@property (nonatomic, strong) NSMutableArray *arrPeopleInfo;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *tryArray;
@property (nonatomic, strong) NSMutableArray *molecule;
@property (strong, nonatomic) UIBarButtonItem *searchButton;

@end

@implementation FourthViewController{
    BOOL container;
    UITapGestureRecognizer *tap;
    NSUserDefaults *ud;
    NSMutableIndexSet *toDelete;
    BOOL isEmptyDrugsList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isEmptyDrugsList = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    [self setLabel:@"Фармакологические группы"];
    
    self.containerView.hidden = true;
    self.darkView.hidden = true;
    container = false;
    
    tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(close)];
    
    
    NSInteger level = [[ud objectForKey:@"level"] integerValue];
    NSString *req = [NSString stringWithFormat:@"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = %ld AND ClinicoPhPointers.ParentCode = '%@' ORDER BY ClinicoPhPointers.Name", level + 1, [ud objectForKey:@"parent"]];
    
    [self loadData:req];
    
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
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

- (void) setLabel:(NSString *)label {
    UILabel* labelName = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    labelName.textAlignment = NSTextAlignmentLeft;
    labelName.text = NSLocalizedString(label, @"");
    labelName.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = labelName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrPeopleInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PharmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pharmaCell" forIndexPath:indexPath];
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.name.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger pointID = [self.dbManager.arrColumnNames indexOfObject:@"ClPhPointerID"];
    NSString *pointIDStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:pointID]];
    //[self segueToBe:indexPath.row request:@""];
    
    
    NSString *request = [NSString stringWithFormat:@"SELECT Document.DocumentID, Document.RusName, Document.EngName, Document.CompaniesDescription, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозировки', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Document_ClPhPointers ON Document.DocumentID = Document_ClPhPointers.DocumentID INNER JOIN ClinicoPhPointers ON Document_ClPhPointers.ClPhPointerID = ClinicoPhPointers.ClPhPointerID WHERE ClinicoPhPointers.ClPhPointerID = %@", pointIDStr];
    [self getMol:request];
    
    if (isEmptyDrugsList) {
        return;
    } else {
        [self performSegueWithIdentifier:@"toList" sender:self];
    }
//    
//    if (!container) {
//        self.containerView.hidden = false;
//        container = true;
//        self.darkView.hidden = false;
//        [self.darkView addGestureRecognizer:tap];
//        [ud setObject:pointIDStr forKey:@"id"];
//    }
    
    
}

-(void)loadData:(NSString *)req{
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

- (void) close {
    self.containerView.hidden = true;
    container = false;
    [self.darkView removeGestureRecognizer:tap];
    self.darkView.hidden = true;
    
}

- (void) getMol:(NSString *)mol {
    if (self.molecule != nil) {
        self.molecule = nil;
    }
    self.molecule = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:mol]];
    if ([self.molecule count] != 0) {
        [ud setObject:self.molecule forKey:@"pharmaList"];
        
        for (NSUInteger i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
            if ([[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
                || [[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
                [toDelete addIndex:i];
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
        isEmptyDrugsList = true;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Неправильный данные" message:@"Повторите ввод" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
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

@end
