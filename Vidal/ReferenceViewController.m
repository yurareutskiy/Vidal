//
//  ReferenceViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ReferenceViewController.h"

@interface ReferenceViewController ()

@end

@implementation ReferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Новости";
    
    NSString *string = self.takeda.text;
    self.takeda.numberOfLines = 0;
    self.takeda.text = string;
    [self.takeda sizeToFit];
    
    self.content.textContainerInset = UIEdgeInsetsZero;
    self.content.textContainer.lineFragmentPadding = 0;
    
    [super setLabel:@"Справка"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.content setTextColor:[UIColor colorWithRed:91.f/255.f green:91.f/255.f blue:91.f/255.f alpha:1]];

    
    NSString *htmlString = @"<style>body{font-family:'Helvetica Neue'; font-size: 10pt; color:rgb(91, 91, 91)}</style><body>Информация, содержащаяся в мобильном приложении, предназначена только для специалистов в области здравоохранения.</br></br>"
                            "Пожалуйста, направляйте Ваши вопросы, пожелания и замечания по адресу <a href=\"mailto:m.vlasenko@vidal.ru\">m.vlasenko@vidal.ru</a></br></br>"
                            
                            "<b>В приложении используются ПО:</b></br></br>"
                            
                            "<a href=\"https://source.android.com/source/licenses.html\">Android license</a></br><a href=\"https://www.openssl.org/source/license.html\">OpenSSL license</a></br><a href=\"http://source.icu-project.org/repos/icu/icu/trunk/LICENSE\">ICU license</a></br></br>"
                            "<b>SQLCipher</b></br>"
                            "Copyright © 2008-2012 Zetetic LLC</br>All rights reserved.</br>"
                            "Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:</br>"
                            "* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.</br>"
                            "* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.</br>"
                            "* Neither the name of the ZETETIC LLC nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.</br>"
                            
                            "THIS SOFTWARE IS PROVIDED BY ZETETIC LLC \'\'AS IS\'\' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</body>";
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                  initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                       options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                                         error: nil];
    self.content.attributedText = attributedString;
    
    [self.content setContentInset:UIEdgeInsetsMake(0, 0, -1000000, 0)];
    [self.content sizeToFit];
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
