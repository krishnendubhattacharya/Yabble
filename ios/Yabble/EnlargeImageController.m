//
//  EnlargeImageController.m
//  Yabble
//
//  Created by National It Solution on 30/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "EnlargeImageController.h"
#import "AppDelegate.h"


@interface EnlargeImageController ()

@end

@implementation EnlargeImageController
@synthesize strImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setImageWithurl:[NSString stringWithFormat:@"%@%@",IMAGE_URL,strImage] andImageView:image];
    image.contentMode=UIViewContentModeScaleAspectFit;
    image.layer.masksToBounds=YES;
    
    scrlvwFullImage.minimumZoomScale = MINIMUM_SCALE;
    scrlvwFullImage.maximumZoomScale = MAXIMUM_SCALE;
    scrlvwFullImage.contentSize = image.frame.size;
    scrlvwFullImage.delegate = self;
}


-(void)setImageWithurl:(NSString*)url andImageView:(UIImageView*)imgview{
    
    NSString *imageURL=[NSString stringWithFormat:@"%@",url];
    NSString* imageName=[imageURL lastPathComponent];
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString  *FilePath = [NSString stringWithFormat:@"%@/%@",docDir,imageName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:FilePath];
    if (fileExists)
    {
        imgview.image=[UIImage imageWithContentsOfFile:FilePath];
    }
    else
    {
        [self processImageDataWithURLString:imageURL andBlock:^(NSData *imageData)
         {
             imgview.image=[UIImage imageWithData:imageData];
             [imageData writeToFile:FilePath atomically:YES];
         }];
    }
    
}


- (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t callerQueue = dispatch_get_main_queue();//dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return image;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}


#pragma mark GestureRecognizer Methods
-(void)scale:(id)sender
{
    UIView *imgTempGest = [sender view];
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0;
        return;
    }
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    
    [imgTempGest setTransform:newTransform];
    
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnCancelPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}
@end
