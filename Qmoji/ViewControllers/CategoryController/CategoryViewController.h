//
//  CategoryViewController.h
//  Qmoji
//
//  Created by Q on 4/27/15.
//  Copyright (c) 2015 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController

@property (nonatomic, strong) NSArray *gifArray;
@property (nonatomic, strong) NSString *categoryName;
@property (weak, nonatomic) IBOutlet UICollectionView *gifCollectionVIew;

@end
