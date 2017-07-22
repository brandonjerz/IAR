//
//  AdministrationScreen.h
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 9/12/13.
//  Copyright (c) 2013 Jeffrey McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdministrationScreen : UIViewController <UIPopoverControllerDelegate>

- (IBAction)HitDoneButton:(id)sender;
@property (weak, atomic) UIPopoverController *thePopController;

@end
