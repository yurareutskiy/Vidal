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
    [self.shareButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    self.navigationItem.title = @"Препарат";
    
    self.tableView.estimatedRowHeight = 60.0;
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    
            self.latName.text = [self clearString:[[[self.info objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"]];
            self.name.text = [self clearString:[[[self.info objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"]];
    
            NSString *string = [self clearString:[[[self.info objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"]];
            self.name.numberOfLines = 0;
            self.name.text = string;
            [self.name sizeToFit];
    
            if (![[[self.info objectAtIndex:0] objectAtIndex:2] isEqualToString:@""]) {
                self.registred.text = [self clearString:[[self.info objectAtIndex:0] objectAtIndex:2]];
                [toDelete addIndex:2];
            } else {
                [toDelete addIndex:2];
            }
    
            for (NSUInteger i = 0; i < [[self.info objectAtIndex:0] count]; i++) {
                if ([[[self.info objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
                    || [[[self.info objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
                    [toDelete addIndex:i];
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
    
    
            [toDelete addIndex:0];
            [toDelete addIndex:1];
    
            [[self.info objectAtIndex:0] removeObjectsAtIndexes:toDelete];
            [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
    
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    
    [tapsOnCell setObject:@"0" forKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
    
    cell.delegate = self;
    cell.expanded = @"0";
    cell.title.text = [self clearString:[self.dbManager.arrColumnNames objectAtIndex:indexPath.row]];
    cell.desc.text = [self clearString:[[self.info objectAtIndex:0] objectAtIndex:indexPath.row]];
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width - 40, 0)];
    NSString *string = [self clearString:[[self.info objectAtIndex:0] objectAtIndex:indexPath.row]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1.1];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:17.0]];
    [label setNumberOfLines:0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    sizeCell = label.frame.size.height + 95.0;
    NSLog(@"%f", sizeCell);
    
    [tableView beginUpdates];
    
    [tableView endUpdates];
    
}

//- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    selectedRowIndex = [indexPath copy];
//    
//    sizeCell = 60.0;
//    
//    [tableView beginUpdates];
//    
//    [tableView endUpdates];
//}

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
