//
//  KeyboardViewController.m
//  QmojiKeyboard
//
//  Created by Q on 4/24/15.
//  Copyright (c) 2015 Q. All rights reserved.
//

#import "KeyboardViewController.h"
#import "QmojiKeyboard.h"

@interface KeyboardViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) QmojiKeyboard *qmojiKeyboard;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Keyboard
    self.qmojiKeyboard = [[[NSBundle mainBundle] loadNibNamed:@"QmojiKeyboard" owner:nil options:nil] objectAtIndex:0];
    self.qmojiKeyboard.scrollView.delegate = self;
    self.qmojiKeyboard.scrollView.contentSize = CGSizeMake(500, self.qmojiKeyboard.scrollView.frame.size.height);
    
    NSArray *array = [[Helper sharedHelper] getUserCollection];
    NSLog(@"array : %@", array);
    
    self.inputView = self.qmojiKeyboard;
    
    [self addGuestureToKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
}

#pragma mark - Qmoji Keyboard
- (void)addGuestureToKeyboard
{
    [self.qmojiKeyboard.deleteButton addTarget:self
                                        action:@selector(pressDeleteKey)
                              forControlEvents:UIControlEventTouchUpInside];
    [self.qmojiKeyboard.globalButton addTarget:self
                                        action:@selector(advanceToNextInputMode)
                              forControlEvents:UIControlEventTouchUpInside];
    
//    for (UIButton *key in self.keyCommands)
//    {
//    
//    }
}

- (void)pressDeleteKey
{
    [self.textDocumentProxy deleteBackward];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scroll offset x : %f", scrollView.contentOffset.x);
}

@end
