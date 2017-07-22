//
//  CodeAndNames.m
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 11/29/13.
//  Copyright (c) 2013 Jeffrey McConnell. All rights reserved.
//

#import "LaunchView.h"
#import "DataStore.h"

@interface LaunchView ()


@end

NSString *selectProgram;

@implementation LaunchView

#pragma mark -
#pragma mark SYSTEM ROUTINES


- (IBAction)HitButton:(UIButton *)sender {
    selectProgram = [DataStore GetProgram];
    
    if (selectProgram != NULL) {
        NSLog(@"Just got the program: %@",selectProgram);
    }
    
    
    if([selectProgram isEqual: @"Summer"]){
        [self performSegueWithIdentifier:@"StartToSummer" sender:self];
    }
    if([selectProgram isEqual: @"AfterSchool"]){
        [self performSegueWithIdentifier:@"StartToAfterSchool" sender:self];
        
    }
}


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
    selectProgram = [DataStore GetProgram];
   
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    selectProgram = [DataStore GetProgram];


    
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
