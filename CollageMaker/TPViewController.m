//
//  TPViewController.m
//  CollageMaker
//
//  Created by Ilhom Khodjaev on 20.11.14.
//  Copyright (c) 2014 Test Project. All rights reserved.
//

#import "TPViewController.h"
#import "TPLoadingView.h"

@interface TPViewController () {
    
    UINavigationController *_navCtrl;
    NSMutableArray *_images;
    int _imgCount;
    int COLL_SIZE;
}

@end

@implementation TPViewController

@synthesize instaUserInput;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _images = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Operation methods

- (IBAction)makeCollage:(id)sender {
    
    [[TPLoadingView loader] show];
    [instaUserInput resignFirstResponder];
    [_images removeAllObjects];
    
    NSURLRequest *userRequest = [[NSURLRequest alloc]
                             initWithURL:[[NSURL alloc]
                                          initWithString:[SEARCH_METHOD([instaUserInput text]) lowercaseString]]];
    [NSURLConnection sendAsynchronousRequest:userRequest
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        [[TPLoadingView loader] hide];
        if (connectionError)
            return;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dataInfo = [[dict objectForKey:@"data"] objectAtIndex:0];
        
        NSString *userID = [dataInfo objectForKey:@"id"];
        
        if (userID)
        {
            [[TPLoadingView loader] show];
            
            NSURLRequest *photoRequest = [[NSURLRequest alloc]
                                          initWithURL:[[NSURL alloc]
                                                       initWithString:RECENT_METHOD(userID)]];
            [NSURLConnection sendAsynchronousRequest:photoRequest
                                               queue:[NSOperationQueue currentQueue]
                                   completionHandler:^(NSURLResponse *photoResponse, NSData *photoData, NSError *connError)
            {
                
                [[TPLoadingView loader] hide];
                if (connError)
                    return;
                
                NSDictionary *photoDict = [NSJSONSerialization JSONObjectWithData:photoData options:NSJSONReadingMutableLeaves error:nil];
                NSArray *photoDatas = [photoDict objectForKey:@"data"];
                NSDictionary *photoInfo;
                
                for (int i = 0; i < photoDatas.count; i++)
                {
                    photoInfo = [photoDatas objectAtIndex:i];
                    if ([[photoInfo objectForKey:@"type"] isEqualToString:@"image"])
                    {
                        [_images addObject:[photoInfo objectForKey:@"images"]];
                    }
                }
                
                if ([_images count])
                    [self downloadImages];
            }];
        }
    }];
}

- (void)downloadImages {
    
    _imgCount = 0;
    [[TPLoadingView loader] show];
    for (int i = 0; i < _images.count; i++) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^(void) {
            
            COLL_SIZE = [[[[_images objectAtIndex:i] objectForKey:@"low_resolution"] objectForKey:@"width"] integerValue];
            NSString *imageURL = [[[_images objectAtIndex:i] objectForKey:@"low_resolution"] objectForKey:@"url"];
            NSString *path = [[NSString alloc] initWithFormat:@"%@/%@", IMAGE_DIRECTORY, [imageURL lastPathComponent]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self checkCount];
                });
                
            } else {
            
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
            
                if (image) {
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                    
                        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:savedWithError:andInfo:), nil);
                        [UIImageJPEGRepresentation(image, .7) writeToFile:path atomically:YES];
                    });
                }
            }
        });
    }
}

- (void)openImagePicker {
    
    [[TPLoadingView loader] hide];
    ZCImagePickerController *imgPicker = [[ZCImagePickerController alloc] init];
    imgPicker.imagePickerDelegate = self;
    imgPicker.maximumAllowsSelectionCount = 4;
    imgPicker.mediaType = ZCMediaAllPhotos;
    
    [self presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - Private methods

- (void)checkCount {
    
    _imgCount++;
    if (_imgCount >= _images.count)
        [self openImagePicker];
}

- (void)image:(UIImage *)image savedWithError:(NSError *)error andInfo:(id)info {
    
    [self checkCount];
}

#pragma mark - ZCImagePickerController delegate

- (void)zcImagePickerController:(ZCImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSArray *)info {
    
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    int imgNum = info.count;
    int colNum = 2;
    int rowNum = 2;
    
    UIGraphicsBeginImageContext(CGSizeMake(COLL_SIZE, COLL_SIZE));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < imgNum; i++) {
        
        CGContextSaveGState(currentContext);
        UIImage *image = (UIImage *)[[info objectAtIndex:i] objectForKey:UIImagePickerControllerOriginalImage];
        
        float xpos = i % colNum * (COLL_SIZE / 2);
        float ypos = floor(i / rowNum) * (COLL_SIZE / 2);
        
        float width = imgNum == 1 ? COLL_SIZE : COLL_SIZE / 2;
        float height = (imgNum < 3 || (imgNum == 3 && i == 1)) ? COLL_SIZE : COLL_SIZE / 2;
        
        float clipX = (COLL_SIZE - width) / 2;
        float clipY = (COLL_SIZE - height) / 2;
        
        CGRect clippedRect = CGRectMake(clipX, clipY, width, height);
        CGImageRef clippedImg = CGImageCreateWithImageInRect([image CGImage], clippedRect);
        CGContextTranslateCTM(currentContext, 0, COLL_SIZE);
        CGContextScaleCTM(currentContext, 1, -1);
        
        CGRect drawRect = CGRectMake(xpos, ypos, width, height);
        CGContextDrawImage(currentContext, drawRect, clippedImg);
        CGContextRestoreGState(currentContext);
    }
    
    UIImage *collage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    TPCollageResultViewController *collageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CollageResultViewController"];
    collageVC.collageImage = collage;
    
    [self.navigationController pushViewController:collageVC animated:YES];
}

- (void)zcImagePickerControllerDidCancel:(ZCImagePickerController *)imagePickerController {
    
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}


@end
