//
//  CreditsTableViewController.h
//  StockTable
//
//  Created by Andrew on 6/16/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

@interface CreditsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,SKStoreProductViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *swicthClock;

- (IBAction)done:(id)sender;
- (IBAction)switchChanged:(id)sender;

@end
