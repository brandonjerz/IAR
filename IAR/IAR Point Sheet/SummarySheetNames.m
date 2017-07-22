//
//  SummarySheetNames.m
//  IAR Summer Max
//
//  Created by Jeffrey McConnell on 6/22/15.
//  Copyright (c) 2015 Jeffrey McConnell. All rights reserved.
//

#import "DataStore.h"
#import "SummarySheetNames.h"

@interface SummarySheetNames ()
- (IBAction)HitNameButton:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *nameButton;
- (IBAction)HitDoneButton:(id)sender;

@end

@implementation SummarySheetNames

@synthesize nameButton;


- (IBAction)HitNameButton:(id)sender {
    UIButton *buttonHit = (UIButton *) sender;
    int child = (int)((UIImageView*) buttonHit).tag;
    [DataStore SetSummaryChildChosen:child];

}


- (IBAction)HitDoneButton:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:NULL];

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

- (void) viewWillAppear:(BOOL)animated {
    // make sure the buttons are in the correct order
    nameButton = [nameButton sortedArrayUsingComparator: ^(id obj1, id obj2){
        if (((UIImageView *)obj1).tag == ((UIImageView *)obj2).tag)
            return NSOrderedSame;
        if (((UIImageView *)obj1).tag < ((UIImageView *)obj2).tag)
            return NSOrderedAscending;
        return NSOrderedDescending;
    }];
    
    for (int i=0; i<MAX_CHILDREN; i++) {
        [[nameButton objectAtIndex:i] setTitle:[DataStore GetChildNamePlain:i] forState:UIControlStateNormal];
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
