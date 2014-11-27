//
//  TPCollageResultViewController.m
//  CollageMaker
//
//  Created by Ilhom Khodjaev on 21.11.14.
//  Copyright (c) 2014 Test Project. All rights reserved.
//

#import "TPCollageResultViewController.h"

@interface TPCollageResultViewController ()

@end

@implementation TPCollageResultViewController

@synthesize collageImage;
@synthesize collageResultView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (collageImage) {
        [collageResultView setImage:collageImage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
