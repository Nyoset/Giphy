//
//  ViewController.m
//  Giphy
//
//  Created by Marc Basquens on 10/10/2018.
//  Copyright © 2018 Prova. All rights reserved.
//

#import "ViewController.h"
#import "FLAnimatedImage.h"

@interface ViewController ()

@end

const int GIF_SIZE = 180;
const int GIFS_PER_ROW = 2;
const int NUMBER_OF_SECTIONS = 5;
const int MARGIN = 10;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _gifs = [[NSMutableArray alloc] init];
    NSString *apiKey = @"dc6zaTOxFJmzC";
    NSArray *urlParts = [[NSArray alloc] initWithObjects:@"https://api.giphy.com/v1/gifs/trending?api_key=", apiKey, @"&limit=10", nil];
    NSString *request = [urlParts componentsJoinedByString:@""];
    _collectionView.delegate = self;
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request]];
    urlRequest.HTTPMethod = @"GET";
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest                                        returningResponse:&response                                           error:&error];
    
    if (error == nil)
    {
        NSError *e = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&e];
        NSArray *gifArray = [jsonArray valueForKey:@"data"];
        for (NSDictionary *gif in gifArray){
            NSDictionary *inner = [gif valueForKey:@"images"];
            NSDictionary *inner2 = [inner valueForKey:@"original"];
            [_gifs addObject:[inner2 valueForKey:@"url"]];
        }
    }
    
    [_collectionView reloadData];
    _gifSize= ([UIScreen mainScreen].bounds.size.width - 3*MARGIN)/2;
    //UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    CGRect frame = cell.frame;
    frame.origin.x = MARGIN + indexPath.row * (self.gifSize + MARGIN);
    frame.origin.y = MARGIN + indexPath.section * (self.gifSize + MARGIN);
    frame.size.height = self.gifSize;
    frame.size.width = self.gifSize;
    cell.frame = frame;
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.gifs objectAtIndex:(indexPath.row + indexPath.section * GIFS_PER_ROW)]]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(0.0, 0.0, self.gifSize, self.gifSize);
    
    imageView.tag = indexPath.row + indexPath.section * GIFS_PER_ROW;
    
    //UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:imageView.tag)];
    
    [cell addSubview:imageView];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return GIFS_PER_ROW;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return NUMBER_OF_SECTIONS;
}

/*- (void) tapHandler:(UITapGestureRecognizer*)sender {
    self.collectionView.
}*/

@end
