//
//  TallySheet.h
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 8/17/13.
//  Copyright (c) 2013 Jeffrey McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TallySheet : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *theScroller;

@property (strong, nonatomic) IBOutlet UILabel *activityLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeBlockLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *childNames;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *programRules;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *friendshipRules;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *theButtons;

- (IBAction)HitButton:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *totalLabel;

// timeout stuff

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *timeoutButtons;
- (IBAction)HitTimeoutButton:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *timeoutEndButtons;
- (IBAction)HitTimeoutEndButton:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *undoButton;
- (IBAction)hitUndoButton:(id)sender;

- (IBAction)HitReverseSwitch:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *reverseSwitch;

- (IBAction)MainMenuButtonHit:(id)sender;
@end
