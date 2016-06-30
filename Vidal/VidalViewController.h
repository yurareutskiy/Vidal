//
//  VidalViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 24/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"

@interface VidalViewController : ModelViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *text;


@end
