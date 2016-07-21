//
//  PharmaViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "PharmaViewController.h"
#import "SearchViewController.h"
#import "PharmaDetailViewController.h"

@interface PharmaViewController ()

@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *molecule;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (nonatomic, strong) NSMutableArray *secondArray;
@property (nonatomic, strong) NSArray *tryArray;
@property (nonatomic, strong) NSMutableArray *data;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;

@end

@implementation PharmaViewController {

    NSUserDefaults *ud;
    NSString *req;
    BOOL isEmptyDrugsList;

}

#pragma mark - viewLoads

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    ud = [NSUserDefaults standardUserDefaults];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    self.navigationItem.title = @"Фармакологические группы";
    
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
                                                            style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(search)];
    
    if ([ud valueForKey:@"level"] != 0 && ![[ud valueForKey:@"howTo"] isEqualToString:@"search"]) {
        [self addBackButton];
    }
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
    if ([[ud valueForKey:@"howTo"] isEqualToString:@"search"]) {
        [self customNavBar];
    } else {
        [ud removeObjectForKey:@"level"];
        [self customNavBar];
        [self configureMenu];
    }
    [ud removeObjectForKey:@"workWith"];
    [ud removeObjectForKey:@"workActive"];
    [ud removeObjectForKey:@"activeID"];
    [ud removeObjectForKey:@"pharmaList"];
    [ud removeObjectForKey:@"comp"];
    [ud removeObjectForKey:@"info"];
    [ud removeObjectForKey:@"from"];
    [ud removeObjectForKey:@"molecule"];
    [ud removeObjectForKey:@"letterActive"];
    [ud removeObjectForKey:@"letterDrug"];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
    if (![[ud valueForKey:@"howTo"] isEqualToString:@"back"]) {
        [self refreshDb];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [ud removeObjectForKey:@"howTo"];
//    [ud removeObjectForKey:@"level"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrPeopleInfo count];
}

#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PharmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pharmaCell" forIndexPath:indexPath];

    cell.name.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:2]]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[ud valueForKey:@"howTo"] isEqualToString:@"search"]) {
        [ud removeObjectForKey:@"howTo"];
    }
    isEmptyDrugsList = false;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *parentStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:1]];
    NSString *levelStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:3]];
    NSString *pointIDStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0]];
    
    NSString *req2 = [NSString stringWithFormat:@"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = %d AND ClinicoPhPointers.ParentCode = '%@' ORDER BY ClinicoPhPointers.Name", (int)[levelStr integerValue] + 1, parentStr];
    
    BOOL goNext = [self checkData:req2];
    
    if (!goNext) {
        
        NSString *request = [NSString stringWithFormat:@"SELECT * FROM Document INNER JOIN Document_ClPhPointers ON Document.DocumentID = Document_ClPhPointers.DocumentID INNER JOIN ClinicoPhPointers ON Document_ClPhPointers.ClPhPointerID = ClinicoPhPointers.ClPhPointerID WHERE ClinicoPhPointers.ClPhPointerID = %@", pointIDStr];
        [self getMol:request];
        
        if (isEmptyDrugsList) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Для данной группы осутствуют препараты и дркгие группы" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        } else {
//            [ud setObject:self.molecule forKey:@"pharmaList"];
            [ud setObject:pointIDStr forKey:@"pharmaList"];
            [self performSegueWithIdentifier:@"pharma_segue" sender:indexPath];
//            [self performSegueWithIdentifier:@"toList" sender:self];

        }
    } else if (goNext){
//        [ud setObject:levelStr forKey:@"level"];
//        
//        if ([[ud objectForKey:@"level"] integerValue] == 1) {
//            [ud setObject:parentStr forKey:@"parent2"];
//        } else if ([[ud objectForKey:@"level"] integerValue] == 2) {
//            [ud setObject:parentStr forKey:@"parent3"];
//        } else if ([[ud objectForKey:@"level"] integerValue] == 3) {
//            [ud setObject:parentStr forKey:@"parent4"];
//        }
        
        [self performSegueWithIdentifier:@"pharma_segue" sender:indexPath];
        
//        [self addBackButton];
//        [self refreshDb];
//        [self reloadTableView];
    }
    
}

#pragma mark - DBManager

-(void)loadData:(NSString *)req {
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
    
    if ([self.arrPeopleInfo count] == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Нет данных" message:@"Отсутствует информация о группе" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        [self reloadTableView];
    }
    
    // Reload the table view.
}

-(BOOL)checkData:(NSString *)req {
    
    // Get the results.
    if (self.tryArray != nil) {
        self.tryArray = nil;
    }
    self.tryArray = [[NSArray alloc] initWithArray:[[[DBManager alloc] init] loadDataFromDB:req]];
    
    if ([self.tryArray count] == 0){
        return NO;
    } else {
        return YES;
    }
}

- (void) getMol:(NSString *)mol {
    if (self.molecule != nil) {
        self.molecule = nil;
    }
    self.molecule = [[NSMutableArray alloc] initWithArray:[[[DBManager alloc] init] loadDataFromDB:mol]];
    
    if ([self.molecule count] == 0) {
        isEmptyDrugsList = true;
        [self refreshDb];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Нет данных" message:@"Отсутствует информация о группе" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}


- (void) refreshDb {
    
    if (_level == 0) {
        req = @"select * from ClinicoPhPointers where [Level] = 1 order by Name";
    } else {
        req = [NSString stringWithFormat:@"select * from ClinicoPhPointers where ParentCode = '%@' order by Name", _code];
    }
    
    [self loadData:req];
    
}

#pragma mark - Additional Methods

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (void) search
{
    [self performSegueWithIdentifier:@"toSearch" sender:self];
}

- (NSString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
    text = [text stringByReplacingOccurrencesOfString:@"<TD colSpan=\"2\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"<sup>&trade;</sup>" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"<SUP>&trade;</SUP>" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"&trade;" withString:@"™"];
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
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return text;
    
}

- (void) addBackButton{

//    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Back"]  landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    
    self.navigationItem.leftBarButtonItem = self.backButton;
    
}

- (void) backMethod {
    
    [ud setInteger:([[ud objectForKey:@"level"] integerValue] - 1) forKey:@"level"];
    [self refreshDb];
    if ([[ud objectForKey:@"level"] integerValue] == 0) {
        self.navigationItem.leftBarButtonItem = nil;
        [self configureMenu];
    }
}

- (void) reloadTableView {
    
    [UIView transitionWithView:self.tableView
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.tableView reloadData];
                    } completion:nil];
    
}

- (void)customNavBar {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:183.0/255.0 green:0.0/255.0 blue:57.0/255.0 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    
}

- (void)configureMenu {
    
    self.reveal = self.revealViewController;
    
    if (!self.reveal || self.level != 0) {
        return;
    }
    
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"burger"] scaledToSize:CGSizeMake(20, 20)]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self.revealViewController
                                                      action:@selector(revealToggle:)];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toList"]) {
        
        ListOfViewController *lovc = [segue destinationViewController];
        
        lovc.dbManager = self.dbManager;
        
    }  else if ([segue.identifier isEqualToString:@"toSearch"]) {
        SearchViewController *vc = [segue destinationViewController];
        [vc setSearchType:SearchPharmGroup];
    } else if ([segue.identifier isEqualToString:@"pharma_segue"]) {
        PharmaDetailViewController *vc = [segue destinationViewController];
        NSInteger indexCode = [self.dbManager.arrColumnNames indexOfObject:@"Code"];
        NSInteger indexName = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
        NSString *code = [[self.arrPeopleInfo objectAtIndex:[(NSIndexPath*)sender row]] objectAtIndex:indexCode];
        NSString *name = [[self.arrPeopleInfo objectAtIndex:[(NSIndexPath*)sender row]] objectAtIndex:indexName];
        vc.parentCode = code;
//        vc.pharmaName = name;
//        vc.level = self.level + 1;
    }
    
}

@end
