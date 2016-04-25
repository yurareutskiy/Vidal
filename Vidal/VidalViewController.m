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
    
    self.text.delegate = self;
//    self.text.text = @"http://webvidal.ru/";
//    self.text.scrollEnabled = NO;
    self.text.editable = NO;
    self.text.selectable = YES;
    self.text.dataDetectorTypes = UIDataDetectorTypeLink;
//    self.text.attributedText = [self clearString:[self.text.attributedText mutableCopy]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableAttributedString *) clearString:(NSMutableAttributedString *) input {
    
    NSMutableAttributedString *text = input;
    NSURL *URL = [NSURL URLWithString:@"http://webvidal.ru/"];
    
    NSString *string = [input string];
    NSRange range = [string rangeOfString:@"http://webvidal.ru/"];
    
    NSMutableAttributedString *link = [[NSMutableAttributedString alloc] initWithString:@"http://webvidal.ru/"];
    [link addAttribute: NSLinkAttributeName value:URL range: NSMakeRange(0, link.length)];
    
    [text replaceCharactersInRange:range withString:@""];
    [text insertAttributedString:link atIndex:range.location];
    
    return text;
    
}

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