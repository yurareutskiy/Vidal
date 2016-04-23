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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        
        UIColor *color = [UIColor colorWithRed:187.0/255.0 green:0.0/255.0 blue:57.0/255.0 alpha:1];
        
        [self changeButton:@"Препарат в избранном" image:@"favRed" color:color];
        
    } else {
        if (![((NSArray *)[ud objectForKey:@"favs"]) containsObject:[ud objectForKey:@"id"]]) {
            
            [ud setObject:[[ud objectForKey:@"favs"] arrayByAddingObject:[ud objectForKey:@"id"]] forKey:@"favs"];
            
            UIColor *color = [UIColor colorWithRed:187.0/255.0 green:0.0/255.0 blue:57.0/255.0 alpha:1];
            
            [self changeButton:@"Препарат в избранном" image:@"favRed" color:color];
            
        } else {
            
            NSMutableArray *check = [NSMutableArray arrayWithArray:[ud objectForKey:@"favs"]];
            [check removeObject:[ud objectForKey:@"id"]];
            [ud setObject:check forKey:@"favs"];
            
            UIColor *color = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1];

            
            [self changeButton:@"Добавить в избранное" image:@"favGrey" color:color];
            
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
