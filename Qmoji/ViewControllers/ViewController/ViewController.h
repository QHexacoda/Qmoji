//
//  ViewController.h
//  Qmoji
//
//  Created by Q on 4/24/15.
//  Copyright (c) 2015 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) NSArray *gifArray;
@property (weak, nonatomic) IBOutlet UICollectionView *gifCollectionVIew;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;

@end
