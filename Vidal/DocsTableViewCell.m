//
//  DocsTableViewCell.m
//  Vidal
//
//  Created by Test Account on 06/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "DocsTableViewCell.h"

@implementation DocsTableViewCell

- (void)awakeFromNib {
    
//    NSString *string = self.title.text;
//    self.title.numberOfLines = 0;
//    self.title.text = string;
//    [self.title sizeToFit];
//    
//    NSString *string1 = self.desc.text;
//    self.desc.numberOfLines = 0;
//    self.desc.text = string1;
//    [self.desc sizeToFit];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self.delegate perfSeg:self];
    
    // Configure the view for the selected state
}

- (void) rotateImage: (double) degree {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.image.transform = CGAffineTransformMakeRotation(degree);
    }];
}

-(void)prepareForReuse {
    NSLog(@"%@", self.expanded);
    if ([self.expanded isEqualToString:@"0"]){
        [self rotateImage:0];
    } else if ([self.expanded isEqualToString:@"1"]) {
        [self rotateImage:M_PI_2];
    }
}

@end
