//
//  ViewController.h
//  Giphy
//
//  Created by Marc Basquens on 10/10/2018.
//  Copyright © 2018 Prova. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *gifs;

@property int gifSize;


@end

