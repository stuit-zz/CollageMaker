//
//  TPLoadingView.m
//  CollageMaker
//
//  Created by Ilhom Khodjaev on 21.11.14.
//  Copyright (c) 2014 Test Project. All rights reserved.
//

#import "TPLoadingView.h"

@implementation TPLoadingView

static const TPLoadingView *_instance = nil;

+ (const TPLoadingView*)loader {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TPLoadingView alloc] init];
    });
    
    return _instance;
}

- (void)show {
    
    if (!_loader) {
        
        _loader = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_loader];
        
        UIView *bg = [[UIView alloc] initWithFrame:_loader.frame];
        bg.backgroundColor = [UIColor blackColor];
        bg.alpha = .7;
        [_loader addSubview:bg];
        
        UILabel *label = [[UILabel alloc] initWithFrame:_loader.frame];
        label.text = @"Идет поиск...";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_loader addSubview:label];
    }
    _loader.hidden = NO;
}

- (void)hide {
    
    if (_loader) {
        
        _loader.hidden = YES;
    }
}

@end
