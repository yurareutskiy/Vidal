//
//  SecondDocumentViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 09/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "SecondDocumentViewController.h"
#import "SearchViewController.h"
#import "StringFormatter.h"

@interface SecondDocumentViewController ()

@property (strong, nonatomic) NSMutableArray *dataForCollection;
@property (strong, nonatomic) NSMutableArray *resultArray;

@end

@implementation SecondDocumentViewController {
    
    NSUserDefaults *ud;
    NSMutableIndexSet *toDelete;
    NSIndexPath *selectedRowIndex;
    BOOL open;
    CGFloat sizeCell;
    NSMutableDictionary *tapsOnCell;
    NSInteger indexOfBigCell;
    CGFloat sizeOfWeb;
    NSMutableDictionary *webViewsArray;
    NSMutableDictionary *sizesDictionary;
    NSInteger activeWebViewTag;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    activeWebViewTag = 0;
    sizesDictionary = [NSMutableDictionary dictionaryWithDictionary:@{}];
    webViewsArray = [NSMutableDictionary dictionaryWithDictionary:@{}];
    
    self.resultArray = [NSMutableArray array];
    tapsOnCell = [NSMutableDictionary dictionary];
    
    self.dataForCollection = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    toDelete = [NSMutableIndexSet indexSet];
    
    self.navigationItem.title = @"Препарат";
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [ud setObject:@"0" forKey:@"share"];
    
    if (self.drugID) {
        self.dbManager = [[DBManager alloc] init];
        NSString *request =   [NSString stringWithFormat: @"select doc.RusName as RusName, doc.CompiledComposition as CompiledComposition, doc.CategoryName  as Category, doc.PhInfluence as PhInfluence, doc.PhKinetics as PhKinetics, doc.Indication as Indication, doc.Dosage as Dosage, doc.SideEffects as SideEffects, doc.ContraIndication as ContraIndication, doc.Lactation as Lactation, doc.SpecialInstruction as SpecialInstruction, doc.OverDosage as OverDosage, doc.Interaction as Interaction, doc.PharmDelivery as PharmDelivery, doc.StorageCondition as StorageCondition, doc.Elaboration as Elaboration,  InfoPage.RusName as InfoPageName "
           "from DocumentListView doc "
           "INNER JOIN Document_InfoPage ON Document_InfoPage.DocumentID = doc.DocumentID "
           "INNER JOIN InfoPage ON InfoPage.InfoPageID = Document_InfoPage.InfoPageID "
           "where doc.DocumentID = '%@'", self.drugID];
        self.info = [[NSMutableArray arrayWithArray:[self.dbManager loadDataFromDB:request]] objectAtIndex:0];
        
        NSInteger nameIndex = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
        NSInteger elaborationIndex = [self.dbManager.arrColumnNames indexOfObject:@"Elaboration"];
        NSInteger companyNameIndex = [self.dbManager.arrColumnNames indexOfObject:@"InfoPageName"];
        [self.name setText:[StringFormatter clearString: [self.info objectAtIndex:nameIndex]]];
        [self.elaboration setText:[StringFormatter clearString: [self.info objectAtIndex:elaborationIndex]]];
        [self.registred setText:[StringFormatter clearString: [self.info objectAtIndex:companyNameIndex]]];
        NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
        [set addIndex:nameIndex];
        [set addIndex:elaborationIndex];
        [set addIndex:companyNameIndex];
        [self.info removeObjectsAtIndexes:set];
        [self.dbManager.arrColumnNames removeObjectsAtIndexes:set];
        
        
        
    } else {
        if ([[ud valueForKey:@"share"] isEqualToString:@"0"]) {
            
            toDelete = [NSMutableIndexSet indexSet];
            
            NSInteger indexOfPicture = [self.dbManager.arrColumnNames indexOfObject:@"Picture.Image"];
            if (indexOfPicture < 1000000) {
                NSMutableArray *array = self.dbManager.arrColumnNames;
                
                [self.info removeObjectAtIndex:indexOfPicture];
                [array removeObjectAtIndex:indexOfPicture];
                
                self.dbManager.arrColumnNames = array;
            }
            
            NSInteger indexOfLatName                = [self.dbManager.arrColumnNames indexOfObject:@"EngName"];
            NSInteger indexOfName                   = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
            NSInteger indexOfCompany                = [self.dbManager.arrColumnNames indexOfObject:@"InfoPageName"];
            NSInteger indexOfCompanyDescription     = [self.dbManager.arrColumnNames indexOfObject:@"CompaniesDescription"];
            NSInteger indexOfElaboration            = [self.dbManager.arrColumnNames indexOfObject:@"Elaboration"];
            
            self.latName.attributedText = [self clearString:[[self.info objectAtIndex:indexOfLatName] valueForKey:@"lowercaseString"]];
            self.name.attributedText = [self clearString:[self formatNameString:[[self.info objectAtIndex:indexOfName] lowercaseString]]];
            self.elaboration.attributedText = [self clearString:[[self.info objectAtIndex:indexOfElaboration] valueForKey:@"lowercaseString"]];
            
            if (indexOfCompany < [self.info count]) {
                if (![[self.info objectAtIndex:indexOfCompany] isEqualToString:@""]) {
                    self.registred.attributedText = [self clearString:[self.info objectAtIndex:indexOfCompany]];
                    if (indexOfCompany < 1000000) {
                        [toDelete addIndex:indexOfCompany];
                    }
                } else {
                    if (indexOfCompany < 1000000) {
                        [toDelete addIndex:indexOfCompany];
                    }
                }
            }
            
            
            for (NSUInteger i = 0; i < [self.info count]; i++) {
                if ([[self.info objectAtIndex:i] isEqualToString:@""]
                    || [[self.info objectAtIndex:i] isEqualToString:@"0"]) {
                    if (i < 1000000) {
                        [toDelete addIndex:i];
                    }
                }
            }
            
            NSInteger indexOfLetter = [self.dbManager.arrColumnNames indexOfObject:@"Letter"];
            NSInteger indexOfDocument = [self.dbManager.arrColumnNames indexOfObject:@"DocumentID"];
            NSInteger indexOfArticle = [self.dbManager.arrColumnNames indexOfObject:@"ArticleID"];
            NSInteger indexOfCategory = [self.dbManager.arrColumnNames indexOfObject:@"CategoryID"];
            NSInteger indexOfCode = [self.dbManager.arrColumnNames indexOfObject:@"CategoryCode"];
            NSInteger indexOfCatName = [self.dbManager.arrColumnNames indexOfObject:@"CategoryName"];
            
            //    NSInteger indexOfLevel = [self.dbManager.arrColumnNames indexOfObject:@"Level"];
            //    NSInteger indexOfcppid = [self.dbManager.arrColumnNames indexOfObject:@"ClPhPointerID"];
            //    NSInteger indexOfscppid = [self.dbManager.arrColumnNames indexOfObject:@"SrcClPhPointerID"];
            //    NSInteger indexOfPriority = [self.dbManager.arrColumnNames indexOfObject:@"ItsMainPriority"];
            //    NSInteger indexOfPharmaCode = [self.dbManager.arrColumnNames indexOfObject:@"Code"];
            //    NSInteger indexOfPharmaName = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
            //    NSInteger indexOfParent = [self.dbManager.arrColumnNames indexOfObject:@"ParentCode"];
            //    NSInteger indexOfShow = [self.dbManager.arrColumnNames indexOfObject:@"ShowInProduct"];
            //
            //    NSInteger indexOfInfoPage = [self.dbManager.arrColumnNames indexOfObject:@"InfoPageID"];
            
            if ([ud valueForKey:@"letterDrug"]) {
                
                if (indexOfCode < 1000000 && indexOfLetter < 1000000 && indexOfCategory < 1000000 && indexOfCatName < 1000000 && indexOfArticle) {
                    [toDelete addIndex:indexOfLetter];
                    [toDelete addIndex:indexOfCategory];
                    [toDelete addIndex:indexOfCatName];
                    [toDelete addIndex:indexOfCode];
                    [toDelete addIndex:indexOfArticle];
                    [toDelete addIndex:indexOfCompanyDescription];
                }
                
            } else if ([ud valueForKey:@"pharmaList"]) {
                
                indexOfDocument = [self.dbManager.arrColumnNames indexOfObject:@"DocumentListView.DocumentID"];
                
                //        [toDelete addIndex:indexOfLevel];
                //        [toDelete addIndex:indexOfcppid];
                //        [toDelete addIndex:indexOfscppid];
                //        [toDelete addIndex:indexOfPriority];
                //        [toDelete addIndex:indexOfPharmaCode];
                //        [toDelete addIndex:indexOfPharmaName];
                //        [toDelete addIndex:indexOfParent];
                //        [toDelete addIndex:indexOfShow];
                
            } else if ([ud valueForKey:@"activeID"]) {
                
                //        [toDelete addIndex:indexOfLetter];
                
            } else if ([ud valueForKey:@"info"] || [ud valueForKey:@"comp"]) {
                
                //        [toDelete addIndex:indexOfInfoPage];
                
            }
            if (indexOfDocument < 1000000 && indexOfLatName < 1000000 && indexOfName < 1000000 && indexOfElaboration < 1000000) {
                [toDelete addIndex:indexOfDocument];
                [toDelete addIndex:indexOfLatName];
                [toDelete addIndex:indexOfName];
                [toDelete addIndex:indexOfElaboration];
                [toDelete addIndex:indexOfCompanyDescription];
                
            }
            
            if ([((NSArray *)[ud objectForKey:@"favs"]) containsObject:[ud objectForKey:@"id"]]) {
                NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithString:@"Препарат в избранном" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255.0 green:0.0 blue:57.0/255.0 alpha:1], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
                
                [self.fav setAttributedTitle:resultText forState:UIControlStateNormal];
                [self.fav setImage:[UIImage imageNamed:@"favRed"] forState:UIControlStateNormal];
                self.fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
            } else {
                NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithString:@"Добавить в избранное" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
                
                [self.fav setAttributedTitle:resultText forState:UIControlStateNormal];
                [self.fav setImage:[UIImage imageNamed:@"favGrey"] forState:UIControlStateNormal];
                self.fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
            }
            
            [self.info removeObjectsAtIndexes:toDelete];
            [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
            
            
            toDelete = [NSMutableIndexSet indexSet];
            
            //    NSInteger indexOfDocument2 = [self.dbManager.arrColumnNames indexOfObject:@"DocumentID"];
            //    NSInteger indexOfcppid2 = [self.dbManager.arrColumnNames indexOfObject:@"ClPhPointerID"];
            
            if ([ud valueForKey:@"pharmaList"]) {
                
                //        [toDelete addIndex:indexOfDocument2];
                //        [toDelete addIndex:indexOfcppid2];
                [self.info removeObjectsAtIndexes:toDelete];
                [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
                
            }
        } else {
            [ud setObject:@"0" forKey:@"share"];
        }

    }
    
    
    indexOfBigCell = [self.dbManager.arrColumnNames indexOfObject:@"CompiledComposition"];
    [self.tableView reloadData];

    [self addBackButton];

}


- (void) addBackButton{
    
    //    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Back"]  landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void) backMethod {
    
    [self.navigationController popViewControllerAnimated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToFav:(UIButton *)sender {
    
    if (self.drugID) {
        [ud setObject:self.drugID forKey:@"id"];
    }
    
    if ([ud objectForKey:@"favs"] == nil) {
        
        [ud setObject:[NSArray array] forKey:@"favs"];
        [ud setObject:[[ud objectForKey:@"favs"] arrayByAddingObject:[ud objectForKey:@"id"]] forKey:@"favs"];
        
        UIColor *color = [UIColor colorWithRed:187.0/255.0 green:0.0/255.0 blue:57.0/255.0 alpha:1];
        
        [self changeButton:@"Препарат в избранном" image:@"favRed" color:color];
        self.fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
        
    } else {
        if (![((NSArray *)[ud objectForKey:@"favs"]) containsObject:[ud objectForKey:@"id"]]) {
            
            [ud setObject:[[ud objectForKey:@"favs"] arrayByAddingObject:[ud objectForKey:@"id"]] forKey:@"favs"];
            
            UIColor *color = [UIColor colorWithRed:187.0/255.0 green:0.0/255.0 blue:57.0/255.0 alpha:1];
            
            [self changeButton:@"Препарат в избранном" image:@"favRed" color:color];
            self.fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
            
        } else {
            
            NSMutableArray *check = [NSMutableArray arrayWithArray:[ud objectForKey:@"favs"]];
            [check removeObject:[ud objectForKey:@"id"]];
            [ud setObject:check forKey:@"favs"];
            
            UIColor *color = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1];

            
            [self changeButton:@"Добавить в избранное" image:@"favGrey" color:color];
            self.fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
            
        }
    }
    
}

- (void) changeButton: (NSString *) name image:(NSString *) image color: (UIColor *) color{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:color, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    [self.fav setAttributedTitle:result forState:UIControlStateNormal];
    [self.fav setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    self.fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0);
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[tapsOnCell valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]] isEqualToString:@"1"]) {
        if ([[sizesDictionary allKeys] containsObject:[NSString stringWithFormat:@"%d", indexPath.row + 100]]) {
            CGFloat height = [(NSNumber*)[sizesDictionary objectForKey:[NSString stringWithFormat:@"%d", indexPath.row + 100]] floatValue] + 80;
            return height;
        }
        return UITableViewAutomaticDimension;
    } else {
        return 60.0;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dbManager.arrColumnNames count];

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.info == nil) {
        return nil;
    }
    
    if (![[self.info objectAtIndex:indexPath.row] containsString:@"TABLE"]) {
    
        DocsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell" forIndexPath:indexPath];
        if (cell == nil) {
        cell = [[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"docCell"];
        };
    
        if (indexPath.row > 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, 1.0, self.view.frame.size.width + 5.0, 1.0)];
            [line setBackgroundColor:[UIColor colorWithRed:164.0/255.0 green:164.0/255.0 blue:164.0/255.0 alpha:1.0]];
            [cell addSubview:line];
        }
    
        [tapsOnCell setObject:@"0" forKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
        [cell.desc setHidden:NO];
        cell.delegate = self;
        cell.title.text = [self changeDescName:[self.dbManager.arrColumnNames objectAtIndex:indexPath.row]];
        cell.desc.attributedText = [self clearString:[self.info objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [self perfSeg2:cell];
    
        return cell;
        
    } else {
        
        CollectTableVieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CollectTableVieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectCell"];
        };
        
        UIWebView *webView;
        if ([[webViewsArray allKeys] containsObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]) {
            webView = [webViewsArray objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            sizeOfWeb = [(NSNumber*)[sizesDictionary objectForKey:[NSString stringWithFormat:@"%ld", webView.tag]] floatValue];


            [webView.constraints objectAtIndex:0].constant = sizeOfWeb;
        } else {
            webView = cell.webView;
            [webView setBackgroundColor:[UIColor whiteColor]];
            webView.delegate = self;
            webView.tag = 100 + indexPath.row;
            webView.scrollView.scrollEnabled = NO;
            [webView.scrollView setBounces:NO];
            
            NSMutableArray *dataArray = [NSMutableArray array];
            dataArray = [[[self.info objectAtIndex:indexPath.row] componentsSeparatedByString:@"</TABLE>"] mutableCopy];
            
            [webViewsArray setObject:webView forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];

        }
        NSString *tableString = [NSString stringWithFormat:@"<!Doctype html><html><head><meta charset='UTF-8'><style>body {color: rgb(164, 164, 164);} table{border-collapse:collapse}</style></head><body>%@</TABLE></body></html>",[self.info objectAtIndex:indexPath.row]];
        [webView loadHTMLString:tableString baseURL:nil];
        cell.webView = webView;
        
        
        if (indexPath.row > 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, 1.0, self.view.frame.size.width + 5.0, 1.0)];
            [line setBackgroundColor:[UIColor colorWithRed:164.0/255.0 green:164.0/255.0 blue:164.0/255.0 alpha:1.0]];
            [cell addSubview:line];
        }
        
        [tapsOnCell setObject:@"0" forKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
        
        cell.title.text = [self changeDescName:[self.dbManager.arrColumnNames objectAtIndex:indexPath.row]];
        
//        cell.desc.attributedText = [self clearString:[dataArray objectAtIndex:1]];
        [cell.desc setHidden:YES];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self perfSeg4:cell];

        
        [cell layoutIfNeeded];

        
        return cell;
        
    }

}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if ([[sizesDictionary allKeys] containsObject:[NSString stringWithFormat:@"%ld", webView.tag]] == NO) {

    
        
        CGRect frame = webView.frame;
        frame.size.height = 1;
        webView.frame = frame;
        CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        webView.frame = frame;
        
        sizeOfWeb = fittingSize.height;
        activeWebViewTag = webView.tag;
        [sizesDictionary setValue:[NSNumber numberWithFloat:sizeOfWeb] forKey:[NSString stringWithFormat:@"%ld", webView.tag]];
        [self.tableView reloadData];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if ([[tapsOnCell valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]] isEqualToString:@"0"]) {

        for (NSString *value in [tapsOnCell allKeys]) {
            [tapsOnCell setObject:@"0" forKey:value];
            if (indexPath.row != indexOfBigCell) {
                [self perfSeg2:[tableView cellForRowAtIndexPath:indexPath]];
            } else {
                [self perfSeg4:[tableView cellForRowAtIndexPath:indexPath]];
            }
        }
        
        [tapsOnCell setObject:@"1" forKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
        
        if (indexPath.row != indexOfBigCell) {
            [self perfSeg:[tableView cellForRowAtIndexPath:indexPath]];
        } else {
            [self perfSeg3:[tableView cellForRowAtIndexPath:indexPath]];
//            [tableView reloadData];
        }
        
    } else {
        [tapsOnCell setObject:@"0" forKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
        
        if (indexPath.row != indexOfBigCell) {
            [self perfSeg2:[tableView cellForRowAtIndexPath:indexPath]];
        } else {
            [self perfSeg4:[tableView cellForRowAtIndexPath:indexPath]];
        }
    }
    
    [tableView beginUpdates];
    
    [tableView endUpdates];
    

    
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    [self.tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:scrollPosition
                                 animated:YES];
    
}

//#pragma mark - Collection View
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return [self.resultArray count];
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return [[self.resultArray objectAtIndex:0] count];
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tableCell" forIndexPath:indexPath];
//    
//    cell.desc.text = [self clearString:[[self.resultArray objectAtIndex:indexPath.row] objectAtIndex:indexPath.section]];
//    
//    cell.layer.borderWidth=1.0f;
//    CGRect cellFrame = cell.frame;
//    cellFrame.size.width = self.tableView.frame.size.width / 2;
//    [cell setFrame:cellFrame];
//    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGSize newSize = CGSizeZero;
//    newSize.height = 40;
//    newSize.width = self.tableView.frame.size.width / 2 - 30;
//
//    return newSize;
//    
//}

- (IBAction)toInter:(UIButton *)sender {
    
    NSString *reqRaw = @"SELECT MoleculeListView.RusName AS Name FROM MoleculeListView "
                        "JOIN Product_Molecule ON Product_Molecule.MoleculeID = MoleculeListView.MoleculeID "
                        "JOIN Product ON Product.ProductID = Product_Molecule.ProductID "
                        "JOIN DocumentListView ON DocumentListView.DocumentID = Product.DocumentID "
                        "WHERE DocumentListView.RusName LIKE '";
    NSString *endRequest = @"%'";
    NSString *req = [NSString stringWithFormat:@"%@%@%@", reqRaw, [[self clearToInter:self.name.text] uppercaseString], endRequest];
    NSArray *requestResult = [[[DBManager alloc] init] loadDataFromDB:req];
    if ([requestResult count] > 0) {
        NSString *rawStringResult = requestResult[0][0];
        if (rawStringResult) {
            [ud setObject:[rawStringResult capitalizedString] forKey:@"toInter"];
            [self performSegueWithIdentifier:@"knowAbout" sender:self];
            [ud setObject:@"1" forKey:@"share"];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Нет данных" message:@"Для этого препарата не найдено веществ" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Нет данных" message:@"Для этого препарата не найдено веществ" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }

    
}

- (NSString *) clearToInter:(NSString *) input {
    
    NSString *text = input;
    
    text = [text stringByReplacingOccurrencesOfString:@"®" withString:@""];
    
    return text;
    
}

- (NSAttributedString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
    NSRange range = NSMakeRange(0, 1);
    if (![text isEqualToString:@""]) {
        text = [text stringByReplacingCharactersInRange:range withString:[[text substringToIndex:1] valueForKey:@"uppercaseString"]];
    }
    text = [text stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    text = [text stringByReplacingOccurrencesOfString:@"<sup>&trade;</sup>" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"<SUP>&trade;</SUP>" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"&trade;" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"&ge;" withString:@"≥"];
    text = [text stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
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
    text = [text stringByReplacingOccurrencesOfString:@"<TD colSpan=\"2\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
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
    text = [text stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([text containsString:@"[PRING]"]) {
        text = [text stringByReplacingOccurrencesOfString:@"[PRING]" withString:@"Вспомогательные вещества:"];
        NSMutableAttributedString *secondPart = [[NSMutableAttributedString alloc] initWithString:text];
    
        [secondPart beginEditing];
        
        [secondPart addAttribute:NSFontAttributeName
                           value:[UIFont italicSystemFontOfSize:17]
                           range:NSMakeRange(0, 25)];
        
        [secondPart addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:17]
                           range:NSMakeRange(25, [secondPart length] - 25)];
        
        [secondPart endEditing];
        
        NSAttributedString *space = [[NSAttributedString alloc] initWithString:@""];
        
        while ([secondPart.mutableString containsString:@"[PRING]"]) {
            NSRange range = [secondPart.mutableString rangeOfString:@"[PRING]"];
            [secondPart replaceCharactersInRange:range  withAttributedString:space];
        }
        
        return secondPart;
    } else {
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
        return attrText;
    }
}

- (void) perfSeg:(DocsTableViewCell *)sender {
    
    [sender rotateImage:M_PI_2];
    
}

- (void) perfSeg2:(DocsTableViewCell *)sender {
    
    [sender rotateImage:0];
    
}

- (void) perfSeg3:(CollectTableVieCell *)sender {
    
    [sender rotateImage:M_PI_2];
    
}

- (void) perfSeg4:(CollectTableVieCell *)sender {
    
    [sender rotateImage:0];
    
}

- (NSString *) changeDescName:(NSString *) input {
    
    NSString *output = input;
    
    if ([output isEqualToString:@"CompiledComposition"]) {
        return @"Форма выпуска, состав и упаковка";
    } else if ([output isEqualToString:@"YearEdition"]) {
        return @"Год издания";
    } else if ([output isEqualToString:@"Elaboration"]) {
        return output;
    } else if ([output isEqualToString:@"PhInfluence"]) {
        return @"Фармакологическое действие";
    } else if ([output isEqualToString:@"PhKinetics"]) {
        return @"Фармакокинетика";
    } else if ([output isEqualToString:@"Dosage"]) {
        return @"Режим дозирования";
    } else if ([output isEqualToString:@"OverDosage"]) {
        return @"Передозировка";
    } else if ([output isEqualToString:@"Interaction"]) {
        return @"Лекарственное взаимодействие";
    } else if ([output isEqualToString:@"Lactation"]) {
        return @"При беременности, родах и лактации";
    } else if ([output isEqualToString:@"SideEffects"]) {
        return @"Побочное действие";
    } else if ([output isEqualToString:@"StorageCondition"]) {
        return @"Условия и сроки хранения";
    } else if ([output isEqualToString:@"Indication"]) {
        return @"Показания к применению";
    } else if ([output isEqualToString:@"ContraIndication"]) {
        return @"Противопоказания";
    } else if ([output isEqualToString:@"SpecialInstruction"]) {
        return @"Особые указания";
    } else if ([output isEqualToString:@"PharmDelivery"]) {
        return @"Условия отпуска из аптек";
    } else if ([output isEqualToString:@"Category"]) {
        return @"Категория препарата";
    } else {
        return output;
    }
}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return (((DocsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).desc.frame.origin.y + ((DocsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).desc.frame.size.height + 10.0);
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)share:(UIButton *)sender {
//    
//    [ud setObject:@"1" forKey:@"share"];
//    
//    NSString *text = self.name.text;
//
//    UIActivityViewController *controller =
//    [[UIActivityViewController alloc]
//     initWithActivityItems:@[text, @"Я узнал об этом препарате через приложение Видаль-кардиология", @"vidal.ru"]
//     applicationActivities:nil];
//    
//    [self presentViewController:controller animated:YES completion:nil];

    NSString *textToShare = self.name.text;
    NSURL *myWebsite = [NSURL URLWithString:@"http://vidal.ru"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypeMessage,
                                   UIActivityTypePrint,
                                   UIActivityTypeMail,
                                   UIActivityTypeCopyToPasteboard,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToTwitter,
                                   UIActivityTypePostToFacebook];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}


- (void) search {
    SearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [vc setSearchType:SearchDrug];
    [self.navigationController pushViewController:vc animated:NO];
}


@end
