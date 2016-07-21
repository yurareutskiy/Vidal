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
    
    [self.delegate perfSeg:self];
    [self.delegate perfSeg2:self];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) rotateImage: (double) degree {
    self.desc.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.image.transform = CGAffineTransformMakeRotation(degree);
        self.desc.alpha = 1;
    }];
}

@end
