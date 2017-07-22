//
//  NameEntry.m
//  IAR Summer Max
//
//  Created by Jeffrey McConnell on 6/19/15.
//  Copyright (c) 2015 Jeffrey McConnell. All rights reserved.
//


#import "DataStore.h"
#import "NameEntry.h"

@interface NameEntry ()

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *theNames;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *presentButtons;

- (IBAction)HitPresentButton:(id)sender;
- (IBAction)NameEntered:(UITextField *)sender;
- (IBAction)QuitFirstResponder:(id)sender;
- (IBAction)HitDoneButton:(id)sender;

@end

@implementation NameEntry

@synthesize theNames;
@synthesize presentButtons;

- (void) FixButtonOrder
{
    // make sure the buttons are in the correct order
    presentButtons = [presentButtons sortedArrayUsingComparator: ^(id obj1, id obj2){
        if (((UIImageView *)obj1).tag == ((UIImageView *)obj2).tag)
            return NSOrderedSame;
        if (((UIImageView *)obj1).tag < ((UIImageView *)obj2).tag)
            return NSOrderedAscending;
        return NSOrderedDescending;
    }];
}

- (IBAction)HitPresentButton:(id)sender {
    UIButton *buttonHit = (UIButton *) sender;
    int child = (int)((UIImageView*) buttonHit).tag;
    if ([DataStore GetChildPresent:child]) {
        [DataStore SetChildPresent:child isPresent:false];
        [buttonHit setTitle:@"Absent" forState:UIControlStateNormal];
        [buttonHit setTitleColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]
                        forState:UIControlStateNormal];
    }
    else {
        [DataStore SetChildPresent:child isPresent:true];
        [buttonHit setTitle:@"Present" forState:UIControlStateNormal];
        [buttonHit setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
                        forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)NameEntered:(UITextField *)sender {

    UITextField *theField = [theNames objectAtIndex:sender.tag];
    [DataStore SetChildName:(int)sender.tag theName:theField.text];
    [sender resignFirstResponder];
    
}


- (IBAction)QuitFirstResponder:(id)sender {
    for (int i=0; i<[theNames count]; i++) {
        [[theNames objectAtIndex:i] resignFirstResponder];
    }
}


- (IBAction)HitDoneButton:(id)sender {
    [DataStore SaveChildNames];
    
    // need to figure out how many names were entered and fix this.
    [DataStore SetNumberOfChildren:MAX_CHILDREN];
    
    [self dismissViewControllerAnimated:true completion:nil];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self FixButtonOrder];
    for (int i=0; i<MAX_CHILDREN; i++) {
        ((UITextField *)[theNames objectAtIndex:i]).text = [DataStore GetChildNamePlain:i];
        UIButton *theButton = [presentButtons objectAtIndex:i];
        if ([DataStore GetChildPresent:i]) {
            [theButton setTitle:@"Present" forState:UIControlStateNormal];
            [theButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
                            forState:UIControlStateNormal];
        }
        else {
            [theButton setTitle:@"Absent" forState:UIControlStateNormal];
            [theButton setTitleColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]
                            forState:UIControlStateNormal];
            
        }
    }

}


- (void) viewDidAppear:(BOOL)animated {
    [self FixButtonOrder];
    for (int i=0; i < MAX_CHILDREN; i++) {
        UITextField *theField = [theNames objectAtIndex:i];
        theField.text = [DataStore GetChildNamePlain:i];
        UIButton *theButton = [presentButtons objectAtIndex:i];
        if ([DataStore GetChildPresent:i]) {
            [theButton setTitle:@"Present" forState:UIControlStateNormal];
            [theButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
                            forState:UIControlStateNormal];
        }
        else {
            [theButton setTitle:@"Absent" forState:UIControlStateNormal];
            [theButton setTitleColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]
                            forState:UIControlStateNormal];
            
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
