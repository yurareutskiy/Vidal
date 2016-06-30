//
//  OnboardingScrollItem.m
//  Vidal
//
//  Created by Yura Reutskiy Work on 6/28/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "OnboardingScrollItem.h"

@interface OnboardingScrollItem ()


@property (strong, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (assign, nonatomic) CGSize screenSize;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *content;


@end

@implementation OnboardingScrollItem
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Initializer

-(instancetype)initWithContent:(NSString*)content AndImage:(UIImage*)image WithScreenSize:(CGSize)screenSize {
    self = [super initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    self.screenSize = screenSize;
    self.image = image;
    self.content = content;
    
    self.photoImageView = [self createImageView];
    self.contentLabel = [self createLabel];
    
    [self drawView];
    
    return self;
}

#pragma mark - Property initializers

-(UIImageView*)createImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.contentMode = UIViewContentModeRedraw;
    return imageView;
}

-(UILabel*)createLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = self.content;
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    
    return label;
}


#pragma mark - Drawing

-(void)drawView {
    CGRect imageViewFrame = [self rectForImageView:self.photoImageView];
    self.photoImageView.frame = imageViewFrame;

    CGRect labelFrame = [self rectForLabel:self.contentLabel];    
    self.contentLabel.frame = labelFrame;
    
    [self addSubview:self.photoImageView];
    [self addSubview:self.contentLabel];
}


-(CGRect)rectForImageView:(UIImageView*)imageView {
    NSInteger xPoint = self.screenSize.width / 2 - (imageView.frame.size.width / 2);
    NSInteger yPoint = self.screenSize.height / 2 - (imageView.frame.size.width / 2);
    CGPoint point = CGPointMake(xPoint, yPoint);
    CGRect rect;
    rect.origin = point;
    rect.size = imageView.frame.size;
    return rect;
}

-(CGRect)rectForLabel:(UILabel*)label {
    NSInteger width = self.screenSize.width - 30;
    CGRect rect = CGRectZero;
    rect.size.width = width;
    label.frame = rect;
    
    [label sizeToFit];
    
    NSInteger xPoint = self.screenSize.width / 2 - (label.frame.size.width / 2);
    NSLog(@"%@", NSStringFromCGRect(self.photoImageView.frame));
    NSInteger yPoint = self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height + 10;
    CGPoint point = CGPointMake(xPoint, yPoint);

    rect.origin = point;
    rect.size = label.frame.size;
    return rect;
}



@end
