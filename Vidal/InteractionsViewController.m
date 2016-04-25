//
//  InteractionsViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "InteractionsViewController.h"

@interface InteractionsViewController ()

@property (strong, nonatomic) UIBarButtonItem *searchButton;

@end

@implementation InteractionsViewController {
    
    BOOL textField1;
    BOOL textField2;
    int inx;
    int inx2;
    NSDictionary *array;
    NSUserDefaults *ud;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    NSString *string = self.info1.text;
    self.info1.numberOfLines = 0;
    self.info1.text = string;
    [self.info1 sizeToFit];
    
    self.result.hidden = true;
    self.lead.hidden = true;
    [self.result sizeToFit];
    
    self.secondLinePicker.delegate = self;
    self.secondLinePicker.hidden = true;
    self.toolbar.hidden = true;
    
    textField1 = false;
    textField2 = false;
    
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"interactions.min.json"];
    
    NSError *error1;
    NSString *json = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error1];
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
    
        self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(search)];
    
        self.navigationItem.rightBarButtonItem = self.searchButton;
    
    [self.secondLinePicker setBackgroundColor:[UIColor whiteColor]];

    
    // Do any additional setup after loading the view.
}

- (void) search {
    [self performSegueWithIdentifier:@"toSearch" sender:self];
}

- (void) viewDidAppear:(BOOL)animated {
    
    if ([ud objectForKey:@"toInter"]) {
        self.input.text = [ud objectForKey:@"toInter"];
        [self findFirstResult:[ud objectForKey:@"toInter"]];
//        [self setUpQuickSearch:self.hello2];
        self.tableView.hidden = true;
        self.secondInput.hidden = false;
        self.secondLine.hidden = false;
        self.secondLabel.hidden = false;
        self.lead.hidden = true;
        self.toolbar.hidden = false;
        self.secondLinePicker.hidden = false;
        [self.secondLinePicker reloadAllComponents];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    self.input.text = @"";
    [ud removeObjectForKey:@"toInter"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    [self.secondLinePicker reloadAllComponents];
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
    NSString *title;
    title = self.FilteredResults[indexPath.row];
    cell.textLabel.text = title;
    
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
        // ИНОГДА ПАДАЕТ [;
    } else if (textField2) {
        
    }
    self.tableView.hidden = true;
    self.secondInput.hidden = false;
    self.secondLine.hidden = false;
    self.secondLabel.hidden = false;
    self.lead.hidden = false;

}

- (IBAction)getData:(UIBarButtonItem *)sender {
    
    self.secondInput.text = self.hello2[[self.secondLinePicker selectedRowInComponent:0]];
    self.result.text = [self findSecondResult:self.hello2[[self.secondLinePicker selectedRowInComponent:0]]];
    self.result.hidden = false;
    self.lead.hidden = false;
    [self.secondInput resignFirstResponder];
    self.tableView.hidden = true;
    self.secondInput.hidden = false;
    self.secondLine.hidden = false;
    self.secondLabel.hidden = false;
    self.lead.hidden = false;
    self.toolbar.hidden = true;
    self.secondLinePicker.hidden = true;
    
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.tableView.hidden = true;
    self.secondLinePicker.hidden = true;
    self.lead.hidden = false;
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self setUpQuickSearch:self.hello1];
        textField1 = true;
        textField2 = false;
        self.secondInput.text = @"";
        self.input.text = @"";
        self.result.text = @"";
        self.tableView.hidden = false;
    } else if (textField.tag == 2) {
        textField2 = true;
        textField1 = false;
        self.secondInput.text = @"";
        self.secondLinePicker.hidden = false;
        self.toolbar.hidden = false;
    }
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
    
    self.lead.hidden = false;
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
    [self.secondInput resignFirstResponder];
    self.tableView.hidden = true;
    self.secondLinePicker.hidden = true;
    self.toolbar.hidden = true;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -150.0;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = +self.navigationController.navigationBar.frame.size.height + 20.0;
        self.view.frame = f;
    }];
}

- (NSString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
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

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.hello2.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.hello2[row];
    
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
