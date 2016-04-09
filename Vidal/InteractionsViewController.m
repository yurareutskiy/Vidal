//
//  InteractionsViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "InteractionsViewController.h"

@interface InteractionsViewController ()

@end

@implementation InteractionsViewController {
    
    BOOL textField1;
    BOOL textField2;
    int inx;
    int inx2;
    NSDictionary *array;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string = self.info1.text;
    self.info1.numberOfLines = 0;
    self.info1.text = string;
    [self.info1 sizeToFit];
    
    self.result.numberOfLines = 0;
    [self.result sizeToFit];
    
    textField1 = false;
    textField2 = false;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *myFile = [mainBundle pathForResource:@"interactions" ofType: @"json"];
    
    NSError *error1;
    NSString *json = [NSString stringWithContentsOfFile:myFile encoding:NSUTF8StringEncoding error:&error1];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error2;
    array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error2];
    
    self.hello1 = [NSMutableArray array];
    self.hello2 = [NSMutableArray array];
    
    for (int i = 0; i < [[array objectForKey:@"interactions"] count]; i++) {
        [self.hello1 addObject:[[array objectForKey:@"interactions"][i] objectForKey:@"name"]];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchField.delegate = self;
    self.secondInput.delegate = self;
    
    self.secondInput.hidden = true;
    self.secondLine.hidden = true;
    self.secondLabel.hidden = true;
    
    self.tableView.hidden = true;
    
    [self setUpQuickSearch:self.hello1];
    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    
    [super setLabel:@"Лекарственное взаимодействие"];
    
    // Do any additional setup after loading the view.
}

- (void)setUpQuickSearch:(NSMutableArray *)work {
    // Create Filters
    IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:work keys:@[@"description"]];
    self.quickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter]];
}

- (void)filterResults {
    // Asynchronously
    if (textField1) {
    [self.quickSearch asynchronouslyFilterObjectsWithValue:self.searchField.text completion:^(NSArray *filteredResults) {
        [self updateTableViewWithNewResults:filteredResults];
    }];
    }
    if (textField2) {
        [self.quickSearch asynchronouslyFilterObjectsWithValue:self.secondInput.text completion:^(NSArray *filteredResults) {
            [self updateTableViewWithNewResults:filteredResults];
        }];
    }
    
    // Synchronously
    //[self updateTableViewWithNewResults:[self.QuickSearch filteredObjectsWithValue:self.searchTextField.text]];
}

- (void)updateTableViewWithNewResults:(NSArray *)results {
    self.FilteredResults = results;
    [self.tableView reloadData];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.FilteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
    }
    
    // Set Content
    NSString *title, *subtitle;
    title = self.FilteredResults[indexPath.row];
    subtitle = self.FilteredResults[indexPath.row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    // Return Cell
    return cell;
}

- (void) findFirstResult:(NSString *) first {
    
    for (int i = 0; i < [[array objectForKey:@"interactions"] count]; i++) {
        if ([[[array objectForKey:@"interactions"] objectAtIndex:i] containsObject:first]) {
            inx = i;
            break;
        }
    }
    
    for (int i = 0; i < [[[array objectForKey:@"interactions"][inx] objectForKey:@"info"] count]; i++) {
        [self.hello2 addObject:[[[array objectForKey:@"interactions"][inx] objectForKey:@"info"][i] objectForKey:@"coname"]];
    }
    
}

- (NSString *) findSecondResult:(NSString *) second {
    
    for (int i = 0; i < [[[array objectForKey:@"interactions"][inx] objectForKey:@"info"] count]; i++) {
        if ([[[[[array objectForKey:@"interactions"] objectAtIndex:inx] objectForKey:@"info"] objectAtIndex:i]  containsObject:second]) {
            inx2 = i;
            break;
        }
    }
    
    return [NSString stringWithFormat:@"%@", [[[array objectForKey:@"interactions"][inx] objectForKey:@"info"][inx2] objectForKey:@"effect"]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (textField1) {
        self.searchField.text = self.FilteredResults[indexPath.row];
        [self findFirstResult:self.FilteredResults[indexPath.row]];
        [self setUpQuickSearch:self.hello2];
        
    } else if (textField2) {
        self.secondInput.text = self.FilteredResults[indexPath.row];
        self.result.text = [self findSecondResult:self.FilteredResults[indexPath.row]];
    }
    self.tableView.hidden = true;
    self.secondInput.hidden = false;
    self.secondLine.hidden = false;
    self.secondLabel.hidden = false;
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.tableView.hidden = true;
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {

        textField1 = true;
        textField2 = false;
    } else if (textField.tag == 2) {
        textField2 = true;
        textField1 = false;
        
    }
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
    self.tableView.hidden = false;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.input resignFirstResponder];
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
