//
//  TPViewController.h
//  CollageMaker
//
//  Created by Ilhom Khodjaev on 20.11.14.
//  Copyright (c) 2014 Test Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TPGlobals.h"
#import "TPCollageResultViewController.h"
#import "ZCImagePickerController.h"

@interface TPViewController : UIViewController <ZCImagePickerControllerDelegate> {
    
    IBOutlet UIButton *makeCollageBtn;
}

@property (weak, nonatomic) IBOutlet UITextField *instaUserInput;

- (IBAction)makeCollage:(id)sender;

@end
