//
//  HKSlideMenu3DController
//  SlideMenu3D
//
//  Created by Edgar on 4/6/15.
//  Copyright (c) 2015 hunk. All rights reserved.
//

#import "HKSlideMenu3DController.h"

@interface HKSlideMenu3DController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIViewController *mainContainer;
@property (nonatomic, strong) UIViewController *menuContainer;
@property (nonatomic, strong) UIImageView *bgImageContainer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) CGPoint draggingPoint;
@property (nonatomic, assign) CGFloat distanceOpenMenu;


@end

@implementation HKSlideMenu3DController

- (void)didRotate:(NSNotification *)notification {
    
    CGRect fMain = _mainContainer.view.frame;
    
    if (CGRectGetMinX(fMain) == 0) {
        CALayer *layer = _menuContainer.view.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        layer.transform = rotationAndPerspectiveTransform;
    }
}

- (void)setup {
    
    _distanceOpenMenu = 245.0f;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    _bgImageContainer = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImageContainer.contentMode = UIViewContentModeScaleAspectFill;// UIViewContentModeTopLeft;
    _bgImageContainer.layer.zPosition = -2000;
    [self.view addSubview:_bgImageContainer];
    
    _menuContainer = [[UIViewController alloc] init];
    _menuContainer.view.layer.anchorPoint = CGPointMake(1.0, 0.5);
    _menuContainer.view.frame = self.view.bounds;
    _menuContainer.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_menuContainer.view];
    
    _mainContainer = [[UIViewController alloc] init];
    _mainContainer.view.frame = self.view.bounds;
    _mainContainer.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:_mainContainer.view];
    
    [self addPanGestures];
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (void)setMenuViewController:(UIViewController *)menuViewController {
    _menuViewController = menuViewController;
    _menuViewController.view.frame = self.view.bounds;
    [_menuContainer.view addSubview:menuViewController.view];
}

- (void)setMainViewController:(UIViewController *)mainViewController {
    _mainViewController = mainViewController;
    _mainViewController.view.frame = self.view.bounds;
    [_mainContainer.view addSubview:_mainViewController.view];
    
    if (CGRectGetMinX(_mainContainer.view.frame) == _distanceOpenMenu) {
        [self closeMenu];
    }
}

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _bgImageContainer.image = backgroundImage;
}

-(void)setBackgroundImageContentMode:(UIViewContentMode)backgroundImageContentMode{
    _bgImageContainer.contentMode = backgroundImageContentMode;
}

- (void)toggleMenu {
    CGRect fMain = _mainContainer.view.frame;
    if (CGRectGetMinX(fMain) == _distanceOpenMenu) {
        [self closeMenu];
    }else{
        [self openMenu];
    }
}

-(void)openMenu{
    [self addTapGestures];
    
    CGRect fMain = _mainContainer.view.frame;
    fMain.origin.x = _distanceOpenMenu;
    
    //menuView in 45
    CALayer *layer = _menuContainer.view.layer;
    layer.zPosition = -1000;
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/ -500;
    t = CATransform3DRotate(t, -35.0f * M_PI / 180.0f, 0, 1, 0);
    layer.transform = t;
    _menuContainer.view.alpha = 0.3;
    
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _mainContainer.view.frame = fMain;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CALayer *layer = _menuContainer.view.layer;
                         CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                         layer.transform = rotationAndPerspectiveTransform;
                         _menuContainer.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)closeMenu{
    
    CGRect fMain = _mainContainer.view.frame;
    fMain.origin.x = 0;
    
    [UIView animateWithDuration:1.0
                          delay:0.2
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         _mainContainer.view.frame = fMain;
                         
                     } completion:^(BOOL finished) {
                         [self removeTapGestures];
                     }];
    
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CALayer *layer = _menuContainer.view.layer;
                         layer.zPosition = -1000;
                         CATransform3D t = CATransform3DIdentity;
                         t.m34 = 1.0/ -500;
                         t = CATransform3DRotate(t, -35.0f * M_PI / 180.0f, 0, 1, 0);
                         layer.transform = t;
                         _menuContainer.view.alpha = 0.3;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}


#pragma mark - Tap Gestures tapMainAction
- (void)addTapGestures {
    if (!self.tapGestureRecognizer) {
        self.mainViewController.view.userInteractionEnabled = NO;
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMainAction:)];
        [_mainContainer.view addGestureRecognizer:self.tapGestureRecognizer];
    }
}

- (void)removeTapGestures {
    [_mainContainer.view removeGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer = nil;
    self.mainViewController.view.userInteractionEnabled = YES;
}

- (void)tapMainAction:(id)sender {
    [self closeMenu];
}


#pragma mark - Pan Gesture Recognizer
-(void)setEnablePan:(BOOL)enablePan{
    _enablePan = enablePan;
    if (_enablePan) {
        [self addPanGestures];
    }else{
        [self removePanGestures];
    }
}

- (void)addPanGestures {
    if (!self.panGestureRecognizer) {
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        self.panGestureRecognizer.delegate = self;
        [_mainContainer.view addGestureRecognizer:self.panGestureRecognizer];
    }
}

- (void)removePanGestures {
    [_mainContainer.view removeGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer = nil;
}

- (void)panDetected:(UIPanGestureRecognizer *)aPanRecognizer{
    
    CGPoint translation = [aPanRecognizer translationInView:aPanRecognizer.view];
    CGPoint velocity = [aPanRecognizer velocityInView:aPanRecognizer.view];
    
    if (aPanRecognizer.state == UIGestureRecognizerStateBegan) {
        self.draggingPoint = translation;
    }else if (aPanRecognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat offset = fabs(self.draggingPoint.x - translation.x);
        
        if (offset == 0) {
            return;
        }
        
        self.draggingPoint = translation;
        
        if (velocity.x <= 0) {
            offset = -offset;
        }
        
        CGRect f = _mainContainer.view.frame;
        CGFloat offsetView = f.origin.x + offset;
        CGFloat min = 0;
        CGFloat max = _distanceOpenMenu;
        
        if (offsetView <= min) {
            return;
        }
        
        if (offsetView >= max) {
            return;
        }
        
        f.origin.x += offset;
        _mainContainer.view.frame = f;
        
        // 0 -> 35
        // 210 -> 0
        // newAngle= origin.x * 35 / 210
        CGFloat newAngle = (( (_distanceOpenMenu-f.origin.x ) * 35) / _distanceOpenMenu)*-1;
        
        CALayer *layer = _menuContainer.view.layer;
        CATransform3D t = CATransform3DIdentity;
        layer.zPosition = -1000;
        t.m34 = 1.0/ -500;
        t = CATransform3DRotate(t, newAngle * M_PI / 180.0f, 0, 1, 0);
        layer.transform = t;
        
        CGFloat newAlpha = ((0.7*(f.origin.x))/_distanceOpenMenu)+0.3;
        _menuContainer.view.alpha = newAlpha;
        
    }else if ( aPanRecognizer.state == UIGestureRecognizerStateEnded || aPanRecognizer.state == UIGestureRecognizerStateCancelled ) {
        
        CGRect fMain = _mainContainer.view.frame;
        
        CGFloat newSeg = 1.0;
        BOOL closeMenu = TRUE;
        CGFloat new3dSeg = 0.3;
        
        if (fMain.origin.x >= _distanceOpenMenu/2) {
            [self addTapGestures];
            newSeg = (_distanceOpenMenu-fMain.origin.x) / _distanceOpenMenu;
            new3dSeg = ((_distanceOpenMenu-fMain.origin.x) *0.3 ) / _distanceOpenMenu;
            fMain.origin.x = _distanceOpenMenu;
            closeMenu = FALSE;
        }else{
            [self removeTapGestures];
            newSeg = fMain.origin.x / _distanceOpenMenu;
            new3dSeg = ((fMain.origin.x) *0.3 ) / _distanceOpenMenu;
            fMain.origin.x = 0;
        }
        
        [UIView animateWithDuration:newSeg
                              delay:0.0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             _mainContainer.view.frame = fMain;
                         } completion:^(BOOL finished) {
                             
                         }];
        
        CGFloat newAngle = 0.0;
        CGFloat newAlpha = 1.0;
        if (closeMenu) {
            newAngle = -35.0f;
            newAlpha = 0.3;
        }
        
        [UIView animateWithDuration:new3dSeg
                              delay:0.1
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             CALayer *layer = _menuContainer.view.layer;
                             layer.zPosition = -1000;
                             CATransform3D t = CATransform3DIdentity;
                             t.m34 = 1.0/ -500;
                             t = CATransform3DRotate(t, newAngle * M_PI / 180.0f, 0, 1, 0);
                             layer.transform = t;
                             _menuContainer.view.alpha = newAlpha;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}

@end