//
//  SummarySheet.m
//  IAR Summer Max
//
//  Created by Jeffrey McConnell on 6/22/15.
//  Copyright (c) 2015 Jeffrey McConnell. All rights reserved.
//

#import "DataStore.h"
#import "SummarySheet.h"

@interface SummarySheet ()
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *scores;
- (IBAction)DoneButtonHit:(id)sender;

@end

@implementation SummarySheet

@synthesize name;
@synthesize scores;

- (IBAction)DoneButtonHit:(id)sender {
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
    scores = [scores sortedArrayUsingComparator: ^(id obj1, id obj2){
        if (((UIImageView *)obj1).tag == ((UIImageView *)obj2).tag)
            return NSOrderedSame;
        if (((UIImageView *)obj1).tag < ((UIImageView *)obj2).tag)
            return NSOrderedAscending;
        return NSOrderedDescending;
    }];
    
    int child = [DataStore GetSummaryChildChosen];
    name.text = [DataStore GetChildNamePlain: child];
    
    NSData * theTotals = [DataStore GetChildSummary:child];
    double timeoutTotal = [DataStore GetChildTotalTimeout:child];
    
    int totals[MAX_CATEGORIES+1];
    memcpy(totals, theTotals.bytes, theTotals.length);
    
    for (int i=0; i<=MAX_CATEGORIES; i++) {
        ((UITextField *)[scores objectAtIndex:i]).text = [NSString stringWithFormat:@"%d", totals[i]];
    }
    ((UITextField *)[scores objectAtIndex:MAX_CATEGORIES+1]).text = [NSString stringWithFormat:@"%.2f", (timeoutTotal/60.0)];
    if (totals[MAX_CATEGORIES]>0) {
        ((UITextField *)[scores objectAtIndex:MAX_CATEGORIES+2]).text = [NSString stringWithFormat:@"%.2f", ((timeoutTotal/60.0)/totals[MAX_CATEGORIES])];
    }
    else {
        ((UITextField *)[scores objectAtIndex:MAX_CATEGORIES+2]).text = @"";
        
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
