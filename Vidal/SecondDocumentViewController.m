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
    BOOL fav;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([((NSArray *)[ud objectForKey:@"favs"]) containsObject:[ud objectForKey:@"id"]]) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:self.fav.titleLabel.attributedText];
        
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithRed:187.0/255.0 green:0.0 blue:57.0/255.0 alpha:1] range:NSRangeFromString(text.string)];
        [self.fav.titleLabel setAttributedText: text];
    } else {
        [self.fav setTitleColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToFav:(UIButton *)sender {
    
    if ([ud objectForKey:@"favs"] == nil) {
        [ud setObject:[NSArray array] forKey:@"favs"];
        [ud setObject:[[ud objectForKey:@"favs"] arrayByAddingObject:[ud objectForKey:@"id"]] forKey:@"favs"];
    } else {
        if (![((NSArray *)[ud objectForKey:@"favs"]) containsObject:[ud objectForKey:@"id"]]) {
            [ud setObject:[[ud objectForKey:@"favs"] arrayByAddingObject:[ud objectForKey:@"id"]] forKey:@"favs"];
//            [self.fav setTitleColor:[UIColor colorWithRed:187.0/255.0 green:0.0 blue:57.0/255.0 alpha:1] forState:UIControlStateNormal];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:self.fav.titleLabel.attributedText];
            
            [text addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:187.0/255.0 green:0.0 blue:57.0/255.0 alpha:1] range:NSRangeFromString(text.string)];
            [self.fav setAttributedTitle:text forState:UIControlStateNormal];
        } else {
            NSMutableArray *check = [NSMutableArray arrayWithArray:[ud objectForKey:@"favs"]];
            [check removeObject:[ud objectForKey:@"id"]];
            [ud setObject:check forKey:@"favs"];
            [self.fav setTitleColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
    }
    
    NSLog(@"%@", [ud objectForKey:@"favs"]);
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (IBAction)toInter:(UIButton *)sender {
    
    [ud setObject:self.name.text forKey:@"toInter"];
    [self performSegueWithIdentifier:@"knowAbout" sender:self];
    
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

@end
