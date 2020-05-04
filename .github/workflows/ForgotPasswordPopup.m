//
//  MJDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "ForgotPasswordPopup.h"

@implementation ForgotPasswordPopup

    - (void)viewDidLoad {
        [super viewDidLoad];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [_txt_Email becomeFirstResponder];
    }
    
    - (void)keyboardWillShow: (NSNotification*) aNotification;
    {
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut
                         animations:^(void){
                             
                             CGRect frame = self.view.frame;
                             
                             NSLog(@"%f", frame.origin.y);
                             self.view.frame = CGRectMake(frame.origin.x, frame.origin.y - 200, frame.size.width, frame.size.height);
                             
                             [self.view layoutIfNeeded];
                             [self.view setNeedsDisplay];
//                             self.view.transform = CGAffineTransformMakeTranslation(0, -65);
                         }
                         completion:^(BOOL finished) {}];
    }

    - (void)keyboardWillHide: (NSNotification*) aNotification;
    {
       [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut
                         animations:^(void){
//                             self.view.transform = CGAffineTransformMakeTranslation(0, 0);
                         }
                         completion:^(BOOL finished) {}];
    }
    
- (IBAction)crossDismiss:(id)sender {
    
    [_txt_Email resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(popUpCancelButtonClicked:)]) {
        [self.delegate popUpCancelButtonClicked:self];
    }
}

- (IBAction)submitAction:(id)sender {
    
    [_txt_Email resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupSubmitButtonClicked:withEmal:)]){
        [self.delegate popupSubmitButtonClicked:self withEmal:self.txt_Email.text];
        
    }
}
@end
