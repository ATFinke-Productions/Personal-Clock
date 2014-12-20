//
//  ViewController.m
//  Clock
//
//  Created by Andrew on 10/1/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSArray *labelArray;
    CGRect initalFrame1;
    CGRect initalFrame2;
    CGRect initalFrame3;
    CGRect initalFrame4;

}

@end

@implementation ViewController


- (void) viewDidAppear:(BOOL)animated {
    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"tip"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Quick Tips" message:@"To adjust your image, pinch to zoom and drag your image around the screen to reposition it. To hide or show the navigation bar, double tap anywhere on the screen. From the navigation bar, pressing the picture button gives you options to change the text color, alignment, and background image. To change to a 24-hour clock, tap on the info button." delegate:nil cancelButtonTitle:@"Awesome!" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults]setValue:@"yep" forKey:@"tip"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (void) reset {
    [UIView animateWithDuration:.1 animations:^{
        self.hourLabel.frame = initalFrame1;
        self.monthLabel.frame = initalFrame2;
        self.hourLabel.frame = initalFrame3;
        self.navigationController.navigationBar.frame = initalFrame4;
        navigationBarVisible = YES;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    labelArray = @[self.hourLabel,self.monthLabel];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self updateClock];
    [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(updateClock) userInfo: nil repeats: YES];
    
    [self scrollViewSetUp];
    
	UITapGestureRecognizer *toggle =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleInfo)];
    [toggle setNumberOfTapsRequired:2];
    [toggle setNumberOfTouchesRequired:1];
    [[self view] addGestureRecognizer:toggle];
    
    navigationBarVisible = YES;
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults]valueForKey:@"userImage"];
    if (imageData) {
        self.scrollViewImageView.image = [UIImage imageWithData:imageData];
    }
    
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        self.hourLabel.font = [self.hourLabel.font fontWithSize:110];
        self.monthLabel.font = [self.monthLabel.font fontWithSize:20];
        self.hourLabel.frame = CGRectMake(self.hourLabel.frame.origin.x, self.hourLabel.frame.origin.y+35, self.hourLabel.frame.size.width, self.hourLabel.frame.size.height);
        self.monthLabel.frame = CGRectMake(self.monthLabel.frame.origin.x, self.monthLabel.frame.origin.y+50, self.monthLabel.frame.size.width, self.monthLabel.frame.size.height);
    }
    
    initalFrame1 = self.hourLabel.frame;
    initalFrame2 = self.monthLabel.frame;
    initalFrame3 = self.hourLabel.frame;
    initalFrame4 = self.navigationController.navigationBar.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reset)
                                                 name:@"open"
                                               object:nil];

}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //NSLog(@"1");self.navigationController.navigationBar.frame.origin.y == 0)
    if (!navigationBarVisible) {
        [UIView animateWithDuration:duration animations:^{
            self.hourLabel.frame = CGRectOffset(self.hourLabel.frame, 0, 50);
            self.monthLabel.frame = CGRectOffset(self.monthLabel.frame, 0, 50);
        }];
        navigationBarVisible = YES;
    }
}

-(void)toggleInfo{
    if (navigationBarVisible) {
        [UIView animateWithDuration:.25 animations:^{
            self.navigationController.navigationBar.frame = CGRectOffset(self.navigationController.navigationBar.frame, 0, -50);
            self.hourLabel.frame = CGRectOffset(self.hourLabel.frame, 0, -50);
            self.monthLabel.frame = CGRectOffset(self.monthLabel.frame, 0, -50);
        }];
        navigationBarVisible = NO;
    }
    else {
        [UIView animateWithDuration:.25 animations:^{
            self.navigationController.navigationBar.frame = CGRectOffset(self.navigationController.navigationBar.frame, 0, 50);
            self.hourLabel.frame = CGRectOffset(self.hourLabel.frame, 0, 50);
            self.monthLabel.frame = CGRectOffset(self.monthLabel.frame, 0, 50);
        }];
        navigationBarVisible = YES;
    }
    
}

- (void)scrollViewSetUp{
    self.imageScrollView.maximumZoomScale = 25;
    self.imageScrollView.minimumZoomScale = .75;
    self.imageScrollView.clipsToBounds = YES;
    self.imageScrollView.delegate = self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scrollViewImageView;
}

- (IBAction)showActionSheet:(id)sender {
    [self dismissAllPopovers];
    self.actionSheet = [[UIActionSheet alloc]
                        initWithTitle:nil
                        delegate:self
                        cancelButtonTitle:@"Cancel"
                        destructiveButtonTitle:nil
                        otherButtonTitles:@"Text Color",@"Text Alignment",@"Choose Image", nil];
    
    [self.actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"textColors" sender:self];
            break;
        case 1:
            [self showTextAlert];
            break;
        case 2:
            [self imagePickerChoose];
            break;
        default:
            break;
    }
}

- (void) showTextAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Text Alignment" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Left",@"Center",@"Right", nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        return;
    }
    
    NSTextAlignment align = NSTextAlignmentLeft;
    
    switch (buttonIndex) {
        case 1:
            align = NSTextAlignmentLeft;
            break;
        case 2:
            align = NSTextAlignmentCenter;
            break;
        case 3:
            align = NSTextAlignmentRight;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:.5 animations:^{
        for (UILabel *label in labelArray) {
            label.textAlignment = align;
        }
    }];
    
    
}

-(void)imagePickerChoose{
    
    [self dismissAllPopovers];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        if (!self.imagePopoverController) {
            self.imagePopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        }
        self.imagePopoverController.delegate = self;
        [self.imagePopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    self.scrollViewImageView.image = image;
    
    NSData *data = UIImagePNGRepresentation(image);
    
    [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"userImage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [UIApplication sharedApplication].statusBarHidden = YES;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissAllPopovers];
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [UIApplication sharedApplication].statusBarHidden = YES;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissAllPopovers];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void) dismissAllPopovers {
    [self.actionSheet dismissWithClickedButtonIndex:10 animated:NO];
    [self.imagePopoverController dismissPopoverAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateClock{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *currentTimeFor = [NSDateFormatter new];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"24"] isEqualToString:@"y"]) {
        [currentTimeFor setDateFormat:@"H:mm"];
       // self.hourLabel.backgroundColor = [UIColor yellowColor];
    }
    else {
        [currentTimeFor setDateFormat:@"h:mm"];
    }
    
    self.hourLabel.text = [currentTimeFor stringFromDate:currentTime];
        
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *currentDateFor = [NSDateFormatter new];
    [currentDateFor setDateFormat:@"eeee, MMMM d"];
    self.monthLabel.text = [currentDateFor stringFromDate:currentDate];
    //self.monthLabel.backgroundColor = [UIColor purpleColor];
}



- (void) viewWillAppear:(BOOL)animated {
    NSString * string = [[NSUserDefaults standardUserDefaults] valueForKey:@"colorText"];
    UIColor *textColor;
    
    if (!string) {
        for (UILabel *label in labelArray) {
            label.textColor = [UIColor whiteColor];
        }
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        return;
    }
    
     int index = (int)[string integerValue];
        if (index == 0) {
            textColor = [self colorForString:@"Black"];
        }
        else if (index == 1) {
            textColor = [self colorForString:@"White"];
        }
        else if (index == 2) {
            textColor = [self colorForString:@"Red"];
        }
        else if (index == 3) {
            textColor = [self colorForString:@"Green"];
        }
        else if (index == 4) {
            textColor = [self colorForString:@"Blue"];
        }
        else if (index == 5) {
            textColor = [self colorForString:@"Brown"];
        }
        else if (index == 6) {
            textColor = [self colorForString:@"Dark Gray"];
        }
        else if (index == 7) {
            textColor = [self colorForString:@"Gray"];
        }
        else if (index == 8) {
            textColor = [self colorForString:@"Light Gray"];
        }
        else if (index == 9) {
            textColor = [self colorForString:@"Magenta"];
        }
        else if (index == 10) {
            textColor = [self colorForString:@"Orange"];
        }
        else if (index == 11) {
            textColor = [self colorForString:@"Purple"];
        }
        else if (index == 12) {
            textColor = [self colorForString:@"Yellow"];
        }
    
    for (UILabel *label in labelArray) {
        label.textColor = textColor;
    }
    self.navigationController.navigationBar.tintColor = textColor;
}


- (UIColor *)colorForString:(NSString *)string {
    if ([string isEqualToString:@"Black"]) {
        return [UIColor blackColor];
    }
    else if ([string isEqualToString:@"White"]) {
        return [UIColor whiteColor];
    }
    else if ([string isEqualToString:@"Red"]) {
        return [UIColor redColor];
    }
    else if ([string isEqualToString:@"Green"]) {
        return [UIColor greenColor];
    }
    else if ([string isEqualToString:@"Blue"]) {
        return [UIColor blueColor];
    }
    else if ([string isEqualToString:@"Brown"]) {
        return [UIColor brownColor];
    }
    else if ([string isEqualToString:@"Dark Gray"]) {
        return [UIColor darkGrayColor];
    }
    else if ([string isEqualToString:@"Gray"]) {
        return [UIColor grayColor];
    }
    else if ([string isEqualToString:@"Light Gray"]) {
        return [UIColor lightGrayColor];
    }
    else if ([string isEqualToString:@"Magenta"]) {
        return [UIColor magentaColor];
    }
    else if ([string isEqualToString:@"Orange"]) {
        return [UIColor orangeColor];
    }
    else if ([string isEqualToString:@"Purple"]) {
        return [UIColor purpleColor];
    }
    else if ([string isEqualToString:@"Yellow"]) {
        return [UIColor yellowColor];
    }
    return nil;
}


@end
