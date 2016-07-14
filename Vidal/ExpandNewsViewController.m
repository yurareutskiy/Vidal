//
//  ExpandNewsViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 18/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ExpandNewsViewController.h"

@interface ExpandNewsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) NSString *titleText;
@end

@implementation ExpandNewsViewController {
    
    NSDictionary *array;
    NSString *pls;
    NSUserDefaults *ud;
    CAGradientLayer *gradient;
    UIActivityIndicatorView *activityView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
//    UIBarButtonItem *backButton2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Back"]  landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
//    [backButton setImageInsets:UIEdgeInsetsMake(1, -8, -1, 8)];
    self.navigationItem.rightBarButtonItem = backButton;
    

    self.navigationItem.title = @"Новости";
    
    [self.shareButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    gradient = [CAGradientLayer layer];
    gradient.frame = self.backView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0] CGColor], nil];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(shareNews:)];
    
    ud = [NSUserDefaults standardUserDefaults];
    self.newsId = [ud objectForKey:@"news"];
    
    array = [NSDictionary dictionary];
    
    self.newsTitle.text = @"";
    self.newsText.text = @"";
    self.date.text = @"";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        activityView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2 - 80.0);
        
        [activityView startAnimating];
        [self.view addSubview:activityView];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.vidal.ru/api/news/%@", self.newsId]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"%@ %@", response, responseObject);
                array = [responseObject copy];
                
                NSDateFormatter *date = [[NSDateFormatter alloc] init];
                [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                // in honor to great manager, person and friend
                [date setLocale:[NSLocale localeWithLocaleIdentifier:@"ru_MD"]];
                NSDate *dateNews = [date dateFromString:[array objectForKey:@"date"]];
                [date setDateFormat:@"dd MMMM yyyy"];
            
                NSString *resultDate = [date stringFromDate:dateNews];
                
                self.date.text = resultDate;
                self.titleText = [array objectForKey:@"title"];
                NSString *data = [NSString stringWithFormat:@"<style> body {font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; font-size: 14px; line-height: 1.42857143;} </style> <h4  style='text-align:justify; color:gray'> %@ </h4> <h3  style='text-align:left; line-height:16px; color:black'> %@ </h3>  %@", resultDate, _titleText, [array objectForKey:@"body"]];
                NSLog(@"%@", data);
                [self.webView loadHTMLString:data baseURL:[NSURL URLWithString: @"http://vidal.ru/"]];
                NSLog(@"%@", [array objectForKey:@"body"]);
                
                self.newsText.numberOfLines = 0;
                self.newsTitle.numberOfLines = 0;
                [self.newsText sizeToFit];
                [self.newsTitle sizeToFit];
            }
        }];
        [dataTask resume];

        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [activityView removeFromSuperview];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });
    
//    [super setLabel:@"Новости"];
    
    [self.backView setImage:[self imageWithImage:[UIImage imageNamed:@"back"] scaledToSize:CGSizeMake(15.0, 15.0)] forState:UIControlStateNormal];
    
//    [self imageWithImage:[UIImage imageNamed:@"burger"] scaledToSize:CGSizeMake(30, 20)]
    
    self.backView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.backView.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.backView.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [self.backView.layer insertSublayer:gradient atIndex:0];
    
    self.backView.layer.masksToBounds = NO;
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.backView.layer.shadowOpacity = 0.5f;
    
    
    
    // Do any additional setup after loading the view.
}

- (void) viewWillDisappear:(BOOL)animated {
    [gradient removeFromSuperlayer];
}

-(NSString *) stringByStrippingHTML: (NSString *)news {
    NSRange r;
    while ((r = [news rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        news = [news stringByReplacingCharactersInRange:r withString:@""];
    }
        
        NSString *text = news;
        
        text = [text stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
        text = [text stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
        text = [text stringByReplacingOccurrencesOfString:@"<sup>&trade;</sup>" withString:@"™"];
        text = [text stringByReplacingOccurrencesOfString:@"<SUP>&trade;</SUP>" withString:@"™"];
        text = [text stringByReplacingOccurrencesOfString:@"&trade;" withString:@"™"];
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

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:true];
    
}



- (void)share {
    
    NSString *text = _titleText;
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, @"Я узнал это через приложение Видаль-кардиология", @"vidal.ru"] applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
}


@end
