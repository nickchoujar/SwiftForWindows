//
//  MJDetailViewController.h
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ForgotPopupDelegate;


@interface ForgotPasswordPopup : UIViewController

@property (assign, nonatomic) id <ForgotPopupDelegate>delegate;
    @property (weak, nonatomic) IBOutlet UITextField *txt_Email;


- (IBAction)crossDismiss:(id)sender;
- (IBAction)submitAction:(id)sender;

@end

@protocol ForgotPopupDelegate<NSObject>
@optional

- (void)popUpCancelButtonClicked:(ForgotPasswordPopup*)popUpViewController;
- (void)popupSubmitButtonClicked:(ForgotPasswordPopup *)popUpViewController withEmal:(NSString *)email;

@end
