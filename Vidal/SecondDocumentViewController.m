//
//  SecondDocumentViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 09/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "SecondDocumentViewController.h"

@interface SecondDocumentViewController ()

@end

@implementation SecondDocumentViewController {
    
    NSUserDefaults *ud;
    NSMutableIndexSet *toDelete;
    NSIndexPath *selectedRowIndex;
    BOOL open;
    CGFloat sizeCell;
    NSMutableDictionary *tapsOnCell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tapsOnCell = [NSMutableDictionary dictionary];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    toDelete = [NSMutableIndexSet indexSet];
    
    self.navigationItem.title = @"Препарат";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    
    NSInteger indexOfLatName = [self.dbManager.arrColumnNames indexOfObject:@"EngName"];
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
    NSInteger indexOfCompany = [self.dbManager.arrColumnNames indexOfObject:@"CompaniesDescription"];
    
    
    self.latName.text = [self clearString:[self.info objectAtIndex:indexOfLatName]];
    self.name.text = [self clearString:[self.info objectAtIndex:indexOfName]];
    
    if (![[self.info objectAtIndex:indexOfCompany] isEqualToString:@""]) {
        self.registred.text = [self clearString:[self.info objectAtIndex:indexOfCompany]];
        [toDelete addIndex:indexOfCompany];
    } else {
        [toDelete addIndex:indexOfCompany];
    }
    
            for (NSUInteger i = 0; i < [self.info count]; i++) {
                if ([[self.info objectAtIndex:i] isEqualToString:@""]
                    || [[self.info objectAtIndex:i] isEqualToString:@"0"]) {
                    [toDelete addIndex:i];
                }
            }
    
    NSInteger indexOfLetter = [self.dbManager.arrColumnNames indexOfObject:@"Letter"];
    NSInteger indexOfDocument = [self.dbManager.arrColumnNames indexOfObject:@"DocumentID"];
    NSInteger indexOfArticle = [self.dbManager.arrColumnNames indexOfObject:@"ArticleID"];
    NSInteger indexOfCategory = [self.dbManager.arrColumnNames indexOfObject:@"CategoryID"];
    NSInteger indexOfCode = [self.dbManager.arrColumnNames indexOfObject:@"CategoryCode"];
    NSInteger indexOfCatName = [self.dbManager.arrColumnNames indexOfObject:@"CategoryName"];
    
    NSInteger indexOfLevel = [self.dbManager.arrColumnNames indexOfObject:@"Level"];
    NSInteger indexOfcppid = [self.dbManager.arrColumnNames indexOfObject:@"ClPhPointerID"];
    NSInteger indexOfscppid = [self.dbManager.arrColumnNames indexOfObject:@"SrcClPhPointerID"];
    NSInteger indexOfPriority = [self.dbManager.arrColumnNames indexOfObject:@"ItsMainPriority"];
    NSInteger indexOfPharmaCode = [self.dbManager.arrColumnNames indexOfObject:@"Code"];
    NSInteger indexOfPharmaName = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
    NSInteger indexOfParent = [self.dbManager.arrColumnNames indexOfObject:@"ParentCode"];
    NSInteger indexOfShow = [self.dbManager.arrColumnNames indexOfObject:@"ShowInProduct"];
    
    if ([ud valueForKey:@"letterDrug"]) {
        
        [toDelete addIndex:indexOfLetter];
        [toDelete addIndex:indexOfCategory];
        [toDelete addIndex:indexOfCatName];
        [toDelete addIndex:indexOfCode];
        
    } else if ([ud valueForKey:@"pharmaList"]) {
        
        [toDelete addIndex:indexOfLevel];
        [toDelete addIndex:indexOfcppid];
        [toDelete addIndex:indexOfscppid];
        [toDelete addIndex:indexOfPriority];
        [toDelete addIndex:indexOfPharmaCode];
        [toDelete addIndex:indexOfPharmaName];
        [toDelete addIndex:indexOfParent];
        [toDelete addIndex:indexOfShow];
        
    }
    
    [toDelete addIndex:indexOfDocument];
    [toDelete addIndex:indexOfArticle];
    [toDelete addIndex:indexOfLatName];
    [toDelete addIndex:indexOfName];
    
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
    
    NSInteger indexOfDocument2 = [self.dbManager.arrColumnNames indexOfObject:@"DocumentID"];
    NSInteger indexOfcppid2 = [self.dbManager.arrColumnNames indexOfObject:@"ClPhPointerID"];
    
    if ([ud valueForKey:@"pharmaList"]) {
        
        [toDelete addIndex:indexOfDocument2];
        [toDelete addIndex:indexOfcppid2];
        [self.info removeObjectsAtIndexes:toDelete];
        [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
        
    }
    
            [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToFav:(UIButton *)sender {
    
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
    
    NSLog(@"%@", [ud objectForKey:@"favs"]);
    
}

- (void) changeButton: (NSString *) name image:(NSString *) image color: (UIColor *) color{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:color, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    [self.fav setAttributedTitle:result forState:UIControlStateNormal];
    [self.fav setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    self.fav.imageEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0);
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[tapsOnCell valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]] isEqualToString:@"1"]) {
        return UITableViewAutomaticDimension;
    } else {
        return 60.0;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dbManager.arrColumnNames count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.info == nil) {
        return nil;
    }
    
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
    
    cell.title.text = [self changeDescName:[self.dbManager.arrColumnNames objectAtIndex:indexPath.row]];
    cell.desc.text = [self clearString:[self.info objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[tapsOnCell valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]] isEqualToString:@"0"]) {
        
        for (NSString *value in [tapsOnCell allKeys]) {
            [tapsOnCell setObject:@"0" forKey:value];
        }
        
        [tapsOnCell setObject:@"1" forKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
        
    } else {
        [tapsOnCell setObject:@"0" forKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
    }
    
    [tableView beginUpdates];
    
    [tableView endUpdates];
    
}

- (IBAction)toInter:(UIButton *)sender {
    
    [ud setObject:[self clearToInter:self.name.text] forKey:@"toInter"];
    [self performSegueWithIdentifier:@"knowAbout" sender:self];
    
}

- (NSString *) clearToInter:(NSString *) input {
    
    NSString *text = input;
    
    text = [text stringByReplacingOccurrencesOfString:@"®" withString:@""];
    
    return text;
    
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
- (void) perfSeg:(DocsTableViewCell *)sender {
    
}

- (NSString *) changeDescName:(NSString *) input {
    
    NSString *output = input;
    
    if ([output isEqualToString:@"CompiledComposition"]) {
        return @"Описание состава и формы выпуска";
    } else if ([output isEqualToString:@"YearEdition"]) {
        return @"Год издания";
    } else if ([output isEqualToString:@"Elaboration"]) {
        return output;
    } else if ([output isEqualToString:@"PhInfluence"]) {
        return @"Фармакологическое действие";
    } else if ([output isEqualToString:@"PhKinetics"]) {
        return @"Фармакокинетика";
    } else if ([output isEqualToString:@"Dosage"]) {
        return @"Режим дозировки";
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
    
    NSString *text = self.name.text;
    
    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[text, @"Я узнал об этом препарате через приложение Видаль-кардиология", @"vidal.ru"]
     applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}
@end
