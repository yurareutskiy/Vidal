//
//  DocumentViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 06/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "DocumentViewController.h"

@interface DocumentViewController ()

@end

@implementation DocumentViewController {
    
    NSUserDefaults *ud;
    NSMutableIndexSet *toDelete;
    NSIndexPath *selectedRowIndex;
    BOOL open;
    CGFloat sizeCell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    toDelete = [NSMutableIndexSet indexSet];
    
    open = false;
    
    // Do any additional setup after loading the view.
}
- (void) viewWillDisappear:(BOOL)animated {
    if (self.isMovingFromParentViewController) {
        [ud removeObjectForKey:@"activeID"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    if ([[ud valueForKey:@"from"] isEqualToString:@"active"]) {
        
            self.latName.text = [[[self.info objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"];
    
            self.name.text = [[[self.info objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"];
    
            NSString *string = [[[self.info objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"];
            self.name.numberOfLines = 0;
            self.name.text = string;
            [self.name sizeToFit];
    
    
            for (NSUInteger i = 0; i < [[self.info objectAtIndex:0] count]; i++) {
                if ([[[self.info objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
                    || [[[self.info objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
                    [toDelete addIndex:i];
            }
    
            [toDelete addIndex:0];
            [toDelete addIndex:1];
    
            [[self.info objectAtIndex:0] removeObjectsAtIndexes:toDelete];
            [self.columns removeObjectsAtIndexes:toDelete];
    
            [self.tableView reloadData];
        
    } else if ([[ud valueForKey:@"from"] isEqualToString:@"drug"]) {
        
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
        if (open) {
            return sizeCell;
        } else {
            return 60;
        }
    } else {
        return 60;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.columns count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.info == nil) {
        return nil;
    }
    
    DocsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"docCell"];
    };
    
//    cell.delegate = self;
    cell.expanded = @"0";
    cell.title.text = [self clearString:[self.columns objectAtIndex:indexPath.row]];
    cell.desc.text = [self clearString:[[self.info objectAtIndex:0] objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
            selectedRowIndex = [indexPath copy];
            if (!open) {
                open = true;
//                DocsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                [self perfSeg:cell];
    
            } else {
                open = false;
//                DocsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                [self perfSeg:cell];
            }
    
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 0)];
            NSString *string = [self clearString:[[self.info objectAtIndex:0] objectAtIndex:indexPath.row]];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:0.1];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
            label.attributedText = attributedString;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.font = [UIFont fontWithName:@"Lucida Grande-Regular" size:17.f];
            [label sizeToFit];
            sizeCell = label.frame.size.height + 60.0;
            
            [tableView beginUpdates];
            
            [tableView endUpdates];
    
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

- (IBAction)toList:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toList" sender:self];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toList"]) {
        
        ListOfViewController *lovc = [segue destinationViewController];
        
        lovc.activeID = self.activeID;
        
    }
    
}

@end
