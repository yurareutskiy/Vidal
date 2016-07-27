//
//  VidalViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 24/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "VidalViewController.h"

@interface VidalViewController ()

@end

@implementation VidalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.text setContentOffset:CGPointZero animated:NO];

    self.text.delegate = self;
    self.text.editable = NO;
    self.text.selectable = YES;
    self.text.dataDetectorTypes = UIDataDetectorTypeLink;
    
    [self setLabel:@"VIDAL"];
    [self.text setContentOffset:CGPointZero animated:NO];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.text setContentOffset:CGPointZero animated:NO];
    [super viewWillAppear:animated];
    [self.text setContentOffset:CGPointZero animated:NO];
    [self.text setTextColor:[UIColor colorWithRed:91.f/255.f green:91.f/255.f blue:91.f/255.f alpha:1]];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.text setContentOffset:CGPointZero animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSMutableAttributedString *) clearString:(NSMutableAttributedString *) input {
//    
//    NSMutableAttributedString *text = input;
//    NSURL *URL = [NSURL URLWithString:@"http://webvidal.ru/"];
//    
//    NSString *string = [input string];
//    NSRange range = [string rangeOfString:@"http://webvidal.ru/"];
//    
//    NSMutableAttributedString *link = [[NSMutableAttributedString alloc] initWithString:@"http://webvidal.ru/"];
//    [link addAttribute: NSLinkAttributeName value:URL range: NSMakeRange(0, link.length)];
//    
//    [text replaceCharactersInRange:range withString:@""];
//    [text insertAttributedString:link atIndex:range.location];
//    
//    return text;
//    
//}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange
{
    return YES;
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
