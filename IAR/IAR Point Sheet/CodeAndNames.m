//
//  CodeAndNames.m
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 11/29/13.
//  Copyright (c) 2013 Jeffrey McConnell. All rights reserved.
//

#import "CodeAndNames.h"
#import "DataStore.h"

@interface CodeAndNames ()
@property (strong, nonatomic) IBOutlet UITextField *deviceCode;
@property (strong, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, atomic) UIPopoverController *thePopController;

@property (strong,atomic) IBOutlet UISwitch *programButton; //$$$$$ Switches program button to current program




- (IBAction)CodeEntered:(id)sender;
- (IBAction)EmailEntered:(UITextField *)sender;
- (IBAction)QuitFirstResponder:(id)sender;
- (IBAction)HitDoneButton:(id)sender;
- (IBAction)SwitchProgram:(id)sender; //$$$$$ Switches the program to what is selected from the selected Button


@end



@implementation CodeAndNames
@synthesize deviceCode;
@synthesize emailAddress;
@synthesize thePopController;
@synthesize programButton; //$$$$$ synthesizes the program button

bool submitDateChosen;


- (IBAction)CodeEntered:(id)sender {
    [DataStore SetDeviceCode:deviceCode.text];
    [sender resignFirstResponder];
}

- (IBAction)EmailEntered:(UITextField *)sender {
    [DataStore SetEmailToAddress:emailAddress.text];
    [sender resignFirstResponder];
}


- (IBAction)QuitFirstResponder:(id)sender {
    [deviceCode resignFirstResponder];
    [emailAddress resignFirstResponder];
}


- (IBAction)HitDoneButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

//$$$$$ Switches program to either Summer or AfterSchool and stores in DataStore
- (IBAction)SwitchProgram:(UISwitch *)sender {
    if (sender.isOn) {
        NSLog(@"Summer Chosen");
        [DataStore SetProgram:@"Summer"]; // Sets program to Summer

        
    }
    else{
        NSLog(@"After School Chosen");
        [DataStore SetProgram:@"AfterSchool"]; // Sets program to AfterSchool
       

    }
     
}





#pragma mark -
#pragma mark SYSTEM ROUTINES



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    deviceCode.text = [DataStore GetDeviceCode];
    emailAddress.text = [DataStore GetEmailToAddress];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //$$$$$ switches button to current program in DataStore
    if ([[DataStore GetProgram]  isEqual:@"Summer"]) {
        [programButton  setOn:YES animated:NO];
        
        
    }
    else{
        [programButton  setOn:NO animated:NO];
    }
    

}

- (void) viewDidAppear:(BOOL)animated{
    
    
    deviceCode.text = [DataStore GetDeviceCode];
    emailAddress.text = [DataStore GetEmailToAddress];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
