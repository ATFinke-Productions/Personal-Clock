//
//  ViewController.h
//  Clock
//
//  Created by Andrew on 10/1/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIPopoverControllerDelegate> {
    BOOL navigationBarVisible;
}

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *scrollViewImageView;

@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPopoverController *imagePopoverController;

- (IBAction)showActionSheet:(id)sender;

@end
