//
//  OnboardingScrollItem.h
//  Vidal
//
//  Created by Yura Reutskiy Work on 6/28/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnboardingScrollItem : UIView

-(instancetype)initWithContent:(NSString*)content AndImage:(UIImage*)image WithScreenSize:(CGSize)screenSize;


@property (assign, nonatomic) NSInteger itemIndex;

@end
