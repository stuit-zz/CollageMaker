//
//  TPLoadingView.h
//  CollageMaker
//
//  Created by Ilhom Khodjaev on 21.11.14.
//  Copyright (c) 2014 Test Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPLoadingView : NSObject  {
    
    UIView *_loader;
}

+ (const TPLoadingView*)loader;

- (void)show;
- (void)hide;

@end
