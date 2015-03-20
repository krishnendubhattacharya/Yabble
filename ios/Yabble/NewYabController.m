//
//  NewYabController.m
//  Yabble
//
//  Created by National It Solution on 14/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "NewYabController.h"
#import "PostAbbController.h"
#import "AppDelegate.h"
#import "CollectionViewCell.h"


BOOL isGalleryPicture=NO;
BOOL isPhotoChoosen=NO;
BOOL isTextEntered=NO;


NSIndexPath *indexpath;

@interface NewYabController ()

@end

static int number_of_row;
static int count=0;

@implementation NewYabController
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tvDescription.returnKeyType=UIReturnKeySend;
    tvDescription.autocorrectionType=UITextAutocorrectionTypeNo;
    [tvDescription becomeFirstResponder];
    
    
    imgBorderLocator.hidden=YES;
    imgBorderGallery.hidden=YES;
    imgBorderYab.hidden=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    // display name,image of user
    isGalleryPicture=NO;
    
    lblName.text=nameUser;
    lblEmail.text=[NSString stringWithFormat:@"@%@",userName];
   
    if (imgUser) {
         imgProfile.image=imgUser;
    }
    else{
        imgProfile.image=[UIImage imageNamed:@"default.png"];
    }
    imgProfile.layer.cornerRadius=40.0f;
    imgProfile.layer.masksToBounds=YES;
    
    if (IS_IPHONE_5) {
        number_of_row=3;
    }
    else if (IS_IPHONE_6){
        number_of_row=4;
    }
    else{
        number_of_row=3;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// back to previous page

-(IBAction)btnCrossPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

// go to location page

-(IBAction)btnLocationPressed:(id)sender{
    imgBorderLocator.hidden=NO;
    imgBorderGallery.hidden=YES;
    imgBorderYab.hidden=YES;
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"PlacesController"];
    [self.navigationController pushViewController:vc animated:YES];
}


//display gallery images

-(IBAction)btnGalerryPressed:(id)sender{
    imgBorderLocator.hidden=YES;
    imgBorderGallery.hidden=NO;
    imgBorderYab.hidden=YES;
    
    [tvDescription resignFirstResponder];
    if (isGalleryPicture==NO) {
        [self getAllPictures];
    }
}

// get all pictures from library

-(void)getAllPictures
{
    isGalleryPicture=YES;
    imageArray=[[NSArray alloc] init];
    mutableArray =[[NSMutableArray alloc]init];
    arrUrl=[[NSMutableArray alloc]init];
    
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if(result != nil)
        {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                
                NSString *strUrl=[url absoluteString];
                
                
                
                /*if ([arrUrl count]==10)
                {
                    NSLog(@"count=%d",count);
                    [self ImageGallery:arrUrl];
                }*/
                
                [library assetForURL:url
                         resultBlock:^(ALAsset *asset) {
                             [arrUrl addObject:strUrl];
                             
                             if ([arrUrl count]==count)
                             {
                                 [collectionGallery reloadData];
                             }
                         }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop)
    {
        if(group != nil)
        {
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [assetGroups addObject:group];
            count=[group numberOfAssets];
        }
    };
    
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {
                             NSLog(@"There is an error");
                         }];
}

-(void)allPhotosCollected:(NSArray*)imgArray
{
    //write your code here after getting all the photos from library...
    NSLog(@"all pictures are %@",imgArray);
}


-(IBAction)btnYabblePressed:(id)sender{
    imgBorderLocator.hidden=YES;
    imgBorderGallery.hidden=YES;
    imgBorderYab.hidden=NO;
    
    [tvDescription becomeFirstResponder];
}

// go to post yab page

-(IBAction)btnSendPressed:(id)sender{
    if (tvDescription.text.length==0 && isPhotoChoosen==NO) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Yabble" message:@"Please choose a photo or enter text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"PostAbbController"];
        PostAbbController *post=(PostAbbController *)vc;
        post.img=self.choosenImage;
        post.str=tvDescription.text;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.returnKeyType=UIReturnKeySend;
    textView.text=@"";
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        // textView.text=@"start with #";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length>0) {
        isTextEntered=YES;
    }
    else{
        isTextEntered=NO;
    }
    NSUInteger textLength=textView.text.length;
    NSUInteger lengthCount=200-textLength;
    lblCountText.text=[NSString stringWithFormat:@"%lu",(unsigned long)lengthCount];
    
    if (lengthCount<=0) {
        return NO;
    }
    
    if([text isEqualToString:@"\n"]) {
        //[textView resignFirstResponder];
        if (tvDescription.text.length==0 && isPhotoChoosen==NO) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Yabble" message:@"Please choose a photo or enter text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"PostAbbController"];
            PostAbbController *post=(PostAbbController *)vc;
            post.img=self.choosenImage;
            post.str=tvDescription.text;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        return NO;
    }
    
    return YES;
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (arrUrl.count%number_of_row>=1) {
        return (arrUrl.count/number_of_row)+1;
    }
    else{
        return arrUrl.count/number_of_row;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return number_of_row;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section*number_of_row+indexPath.row==0)
    {
        cell.img.image=[UIImage imageNamed:@"camera.png"];
    }
    else{
        if (indexPath.section*number_of_row+indexPath.row<=arrUrl.count)
        {
            cell.hidden=false;
            
            NSString *strUrl=[arrUrl objectAtIndex:indexPath.section*number_of_row+indexPath.row-1];
            
            NSURL *url=[NSURL  URLWithString:strUrl];
            library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:url
                     resultBlock:^(ALAsset *asset)
             {
                 cell.img.image=[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                 
             }
                    failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
            
            cell.img.hidden=NO;
            
        }
        else{
            cell.hidden=true;
            cell.img.hidden=YES;
        }
    }
    
    
    if (isPhotoChoosen==YES) {
        if (indexPath.row==indexpath.row && indexPath.section==indexpath.section && indexPath.section*number_of_row+indexPath.row>=1) {
            cell.img.layer.borderWidth=2.0f;
            cell.img.layer.borderColor=[UIColor redColor].CGColor;
            cell.img.layer.masksToBounds=YES;
        }
        else{
            cell.img.layer.borderWidth=0.0f;
            cell.img.layer.borderColor=[UIColor redColor].CGColor;
            cell.img.layer.masksToBounds=YES;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPat{
    if (indexPat.section*number_of_row+indexPat.row==0)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
    else{
        CollectionViewCell *cell=(CollectionViewCell*)[collectionGallery cellForItemAtIndexPath:indexPat];
        
        self.choosenImage=cell.img.image;
        
        NSIndexPath *prevIndexpath=indexpath;
        indexpath=indexPat;
        
        
        if (isPhotoChoosen==YES) {
            BOOL animationsEnabled = [UIView areAnimationsEnabled];
            [UIView setAnimationsEnabled:NO];
            [collectionGallery reloadItemsAtIndexPaths:@[prevIndexpath]];
            [UIView setAnimationsEnabled:animationsEnabled];
        }
        
        isPhotoChoosen=YES;
        
        
        BOOL animationsEnabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [collectionGallery reloadItemsAtIndexPaths:@[indexpath]];
        [UIView setAnimationsEnabled:animationsEnabled];
    }
}

// display gallery images in  scrollview

-(void)ImageGallery:(NSArray*)arrImg{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int x=2;
    int y=5;
    int count=1;
    for (int i=0; i<=arrImg.count; i++) {
        
        if (i==0) {
            UIImageView *subimgView=[[UIImageView alloc]init ];
            subimgView.image=[UIImage imageNamed:@"camera.png"];
            subimgView.contentMode=UIViewContentModeScaleAspectFit;
            
            [subimgView setFrame: CGRectMake(x, y, self.view.frame.size.width/3, self.view.frame.size.width/3)];
            [subimgView setUserInteractionEnabled:YES];
            [subimgView.layer setBorderColor: [[UIColor grayColor] CGColor]];
           // [subimgView.layer setBorderWidth: 1.0];
             [subimgView setTag:100];
             UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTapCamera:)];
             [subimgView addGestureRecognizer:tapGesture];
            [self.scrollView addSubview:subimgView];
            
            //        UIButton *crossButton=[[UIButton alloc] initWithFrame:CGRectMake(x+85, y-8, 20, 20)];
            //        [crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
            //        [self.scrollView addSubview:crossButton];
        }
        else{
            UIImageView *subimgView=[[UIImageView alloc]init ];
            
            NSString *strUrl=[arrImg objectAtIndex:i-1];
            
            NSURL *url=[NSURL  URLWithString:strUrl];
            library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:url
                     resultBlock:^(ALAsset *asset)
             {
                 //[mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                 subimgView.image=[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];

             }
            failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
            
           // subimgView.image=[arrImg objectAtIndex:i-1];
            subimgView.contentMode=UIViewContentModeScaleAspectFill;
            subimgView.layer.masksToBounds=YES;
            
            [subimgView setFrame: CGRectMake(x, y, self.view.frame.size.width/3-7, self.view.frame.size.width/3-7)];
            [subimgView setUserInteractionEnabled:YES];
            [subimgView.layer setBorderColor: [[UIColor grayColor] CGColor]];
           // [subimgView.layer setBorderWidth: 1.0];
             [subimgView setTag:i-1];
             //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
             //[subimgView addGestureRecognizer:tapGesture];
            [self.scrollView addSubview:subimgView];
        }
        
        
        x=x+self.view.frame.size.width/3-7+5;
        if(x>=350){
            y=y+self.view.frame.size.width/3-7+5;
            x=2;
            count=count+1;
            self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width/3-7,self.view.frame.size.width/3*count);
            self.scrollView.frame=CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, 216);
        }
    }
    
}

-(void)handleImageTap:(UITapGestureRecognizer *)tapGesture{
    UIImageView *theTappedImageView = (UIImageView *)tapGesture.view;
    NSInteger tag = theTappedImageView.tag;
    
    
    for(UIImageView *img in self.scrollView.subviews){
        if (img.tag==tag) {
            img.layer.borderWidth=2.0f;
            img.layer.borderColor=[UIColor redColor].CGColor;
            self.choosenImage=[self imageWithImage:img.image scaledToWidth:394];
        }
        else{
            img.layer.borderWidth=0.0f;
            img.layer.borderColor=[UIColor whiteColor].CGColor;
        }
    }
        
    isPhotoChoosen=YES;
}

-(void)handleImageTapCamera:(UITapGestureRecognizer *)tapGesture{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chooseimage = info[UIImagePickerControllerEditedImage];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        self.choosenImage=[self imageWithImage:chooseimage scaledToWidth:394];
        isPhotoChoosen=YES;
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}

@end
