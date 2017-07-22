//
//  TallySheet.m
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 8/17/13.
//  Copyright (c) 2013 Jeffrey McConnell. All rights reserved.
//

#import "TallySheet.h"
#import "ButtonPress.h"
#import "DataStore.h"


@implementation TallySheet

@synthesize theScroller;

@synthesize activityLabel, timeBlockLabel;

@synthesize theButtons;

@synthesize totalLabel;

@synthesize childNames;

@synthesize programRules;

@synthesize friendshipRules;

@synthesize timeoutButtons;
@synthesize timeoutEndButtons;

// storage for counts
int counts[MAX_CHILDREN][kButtonCount];

int totals[MAX_CHILDREN];

int pointValues[]={50, 50, 10, 10, 10, 10, 20, -20, -10, -10, -10, -10, -10, -25, -10, -10, -10, -10, -10, 1};

#define UNDO_LIMIT  10
NSMutableArray *undoStack;
@synthesize undoButton;

int scoreDirection;
@synthesize reverseSwitch;

#pragma mark -
#pragma mark UTILITIES

- (int) GetChildFromTag :(int) tag
{
    return tag/100;
}

- (int) GetButtonFromTag :(int) tag
{
    return tag % 100;
}

- (int) GetTagFromChildButton :(int) child button: (int) button
{
    return (child * 100) + button;
}

- (int) GetButtonLocFromTag :(int) tag
{
    int child = [self GetChildFromTag:tag];
    int button = [self GetButtonFromTag:tag];
    int result = (child * kButtonsInArray) + button;
    return result;
}

#pragma mark -
#pragma mark SETUP

- (void) FixButtonOrder
{
    // make sure the buttons are in the correct order
    theButtons = [theButtons sortedArrayUsingComparator: ^(id obj1, id obj2){
        if (((UIImageView *)obj1).tag == ((UIImageView *)obj2).tag)
            return NSOrderedSame;
        if (((UIImageView *)obj1).tag < ((UIImageView *)obj2).tag)
            return NSOrderedAscending;
        return NSOrderedDescending;
    }];
    
    timeoutButtons = [timeoutButtons sortedArrayUsingComparator: ^(id obj1, id obj2){
        if (((UIImageView *)obj1).tag == ((UIImageView *)obj2).tag)
            return NSOrderedSame;
        if (((UIImageView *)obj1).tag < ((UIImageView *)obj2).tag)
            return NSOrderedAscending;
        return NSOrderedDescending;
    }];
    
    // initialize button labels
    for (int i=0; i < [theButtons count]; i++) {
        
        if ((i % kButtonsInArray) <= 1)
            [[theButtons objectAtIndex:i] setTitle:@"" forState:UIControlStateDisabled];
        else
            [[theButtons objectAtIndex:i] setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void) FixNameOrder
{
    // make sure the buttons are in the correct order
    childNames = [childNames sortedArrayUsingComparator: ^(id obj1, id obj2){
        if (((UIImageView *)obj1).tag == ((UIImageView *)obj2).tag)
            return NSOrderedSame;
        if (((UIImageView *)obj1).tag < ((UIImageView *)obj2).tag)
            return NSOrderedAscending;
        return NSOrderedDescending;
    }];
}


- (void) FillInNames
{
    [DataStore SetupForChildNames];
    int childCount = [DataStore GetNumberOfChildrenPresent];
//    NSLog(@"max children %d child count %d",MAX_CHILDREN, childCount);
    
    for (int i=0; i<childCount; i++) {
//        NSLog(@"putting in a name for child %d", i);
        [[childNames objectAtIndex:i] setText:[DataStore GetChildNameSplit:i]];
    }
    for (int i=childCount; i<MAX_CHILDREN; i++) {
//        NSLog(@"putting in a blank for child %d",i);
        [[childNames objectAtIndex:i] setText:@""];
        
    }
}


- (void) LoadButtonValues
{
    int childrenPresent = [DataStore GetNumberOfChildrenPresent];
    
    for (int j=0; j < childrenPresent; j++) {
        NSData *theScores = [DataStore GetChildScores:j];
        memcpy(&counts[j], theScores.bytes, theScores.length);
        for (int i = 0; i<kButtonsInArray; i++) {
            int tag = [self GetTagFromChildButton:j button:i];
            int buttonLocation = [self GetButtonLocFromTag:tag];
            UIButton *thisButton = [theButtons objectAtIndex:buttonLocation];
            if (i<=1) {
                if (counts[j][i] != 0)
                    [thisButton setTitle:[[NSString alloc] initWithFormat:@"%d", counts[j][i]]
                                                               forState:UIControlStateDisabled];
                else
                    [thisButton setTitle:@"" forState:UIControlStateDisabled];
            }
            else {
                if (counts[j][i] != 0)
                    [thisButton setTitle:[[NSString alloc] initWithFormat:@"%d", counts[j][i]]
                                                               forState:UIControlStateNormal];
                else
                    [thisButton setTitle:@"" forState:UIControlStateNormal];
                thisButton.enabled = true;
            }
            thisButton.hidden = false;
        }
        
    }
    // hide buttons for unused columns
    for (int j=childrenPresent; j < MAX_CHILDREN; j++) {
        int tag = [self GetTagFromChildButton:j button:0];
        int firstButton = [self GetButtonLocFromTag:tag];
        for (int i=0; i < kButtonsInArray; i++) {
            UIButton * thisButton = [theButtons objectAtIndex:firstButton+i];
            thisButton.enabled = false;
            thisButton.hidden = true;
        }
    }
    [self UpdateTimeouts];
}


- (void) ResetTotalsAndCheckRules
{
    [self ResetTotals];
    for (int j=0; j < MAX_CHILDREN; j++) {
        [self CheckRules :j];
    }
}


- (void) ResetTotals
{
    for (int j=0; j < MAX_CHILDREN; j++) {
        
        totals[j] = 0;
        for (int i=0; i<19; i++)
            totals[j] += counts[j][i];
        ((UILabel *)[totalLabel objectAtIndex:j]).text =  [[NSString alloc] initWithFormat:@"%d", totals[j]];
    }
}


#pragma mark -
#pragma mark CHECKS

- (void) CheckRules :(int) child
{
    // any buttons hit?
    int hitTotal = 0;
    for (int i=2; i <20; i++){
        hitTotal += abs(counts[child][i]);
    }
    // check program rules
    int temp = 0;
    for (int i=8; i <= 11; i++) {
        temp += counts[child][i];
    }
    if ((temp == 0) && (hitTotal > 0)){
        counts[child][0] = 50;
        [[programRules objectAtIndex:child] setTitle:@"50" forState:UIControlStateDisabled];
    }
    else {
        counts[child][0] = 0;
        [[programRules objectAtIndex:child] setTitle:@"" forState:UIControlStateDisabled];
    }

    // check friendship rules
    temp = 0;
    for (int i=2; i <= 5; i++) {
        temp += counts[child][i];
    }
    if (temp < 30) {
        counts[child][1] = 0;
        [[friendshipRules objectAtIndex:child] setTitle:@"" forState:UIControlStateDisabled];
    }
    else {
        temp = 0;
        for (int i=12; i <= 18; i++) {
            temp += counts[child][i];
        }
        if (temp == 0) {
            counts[child][1] = 50;
            [[friendshipRules objectAtIndex:child] setTitle:@"50" forState:UIControlStateDisabled];
        }
        else {
            counts[child][1] = 0;
            [[friendshipRules objectAtIndex:child] setTitle:@"" forState:UIControlStateDisabled];
        }
    }
    totals[child] = 0;
    for (int i=0; i<19; i++)
        totals[child] += counts[child][i];
    ((UILabel *)[totalLabel objectAtIndex:child]).text = [[NSString alloc] initWithFormat:@"%d", totals[child]];
}


#pragma mark -
#pragma mark BUTTON PRESSES

- (IBAction)HitButton:(id)sender {
    UIButton *buttonHit = (UIButton *) sender;
    int buttonTag = (int)((UIImageView*) buttonHit).tag;
    int child = [self GetChildFromTag:buttonTag];
    int button = [self GetButtonFromTag:buttonTag];
    
    if ((scoreDirection == -1) && (counts[child][button] == 0)) {
        return;
    }
    counts[child][button] += (scoreDirection * pointValues[button]);
    if (counts[child][button] != 0)
        [buttonHit setTitle:[[NSString alloc] initWithFormat:@"%d", counts[child][button]]
                   forState:UIControlStateNormal];
    else
        [buttonHit setTitle:@"" forState:UIControlStateNormal];
    
    if (button != 19) {
        totals[child] += (scoreDirection * pointValues[button]);
        ((UILabel *)[totalLabel objectAtIndex:child]).text = [[NSString alloc] initWithFormat:@"%d", totals[child]];
        [self CheckRules :child];
    }
    ButtonPress *thisButton = [ButtonPress alloc];
    thisButton.child = child;
    thisButton.value = button;
    thisButton.button = buttonHit;
    thisButton.direction = scoreDirection;
    [self recordButtonPress :thisButton];
}



#pragma mark -
#pragma mark TIMEOUT

#define kTimerInterval  0.1
NSTimer *tallyTimer;

- (void) StartTimer {
    tallyTimer=[NSTimer scheduledTimerWithTimeInterval: kTimerInterval
                                              target:self
                                            selector:@selector(UpdateTimeouts)
                                            userInfo:nil
                                             repeats:YES];
}

- (void) StopTimer {
    [tallyTimer invalidate];
    tallyTimer = NULL;
}

- (void) UpdateTimeouts {
    int childrenPresent = [DataStore GetNumberOfChildrenPresent];
    for (int i=0; i<childrenPresent; i++) {
        UIButton *endButton = [timeoutEndButtons objectAtIndex:i];
        UIButton *timeoutButton = [timeoutButtons objectAtIndex:i];
        timeoutButton.enabled = true;
        timeoutButton.hidden = false;
        if ([DataStore IsChildInTimeout:i]) {
            [timeoutButton setTitle:[DataStore GetTimeoutTime:i] forState:UIControlStateNormal];
            endButton.hidden = false;
            endButton.enabled = true;
        }
        else {
            endButton.hidden = true;
            endButton.enabled = false;
            [timeoutButton setTitle:[[NSString alloc] initWithFormat:@"%d", counts[i][19]]
                           forState:UIControlStateNormal];
        }
    }
    for (int i=childrenPresent; i < MAX_CHILDREN; i++) {
        UIButton *endButton = [timeoutEndButtons objectAtIndex:i];
        endButton.hidden = true;
        endButton.enabled = false;
        UIButton *timeoutButton = [timeoutButtons objectAtIndex:i];
        timeoutButton.enabled = false;
        timeoutButton.hidden = true;
    }
    if ([DataStore NumberInTimeout] == 0) {
        [self StopTimer];
        [self ClearAllTimeouts];
    }
}

- (void) ClearAllTimeouts {
    
    for (int i=0; i<MAX_CHILDREN; i++) {
        UIButton *theButton = [timeoutEndButtons objectAtIndex:i];
        theButton.hidden = true;
        theButton.enabled = false;
        
        [[timeoutButtons objectAtIndex:i]
                setTitle:[[NSString alloc] initWithFormat:@"%d", counts[i][19]]
                forState:UIControlStateNormal];
    }
}

- (IBAction)HitTimeoutButton:(id)sender {
    UIButton *buttonHit = (UIButton *) sender;
    int child = (int)((UIImageView*) buttonHit).tag;
    
    if (![DataStore IsChildInTimeout:child]) {

        // child is not in time out so put them in
        // enable the proper end timeout button
        UIButton *endButton = [timeoutEndButtons objectAtIndex:child];
        endButton.hidden = false;
        endButton.enabled = true;
        
        // the child is not in timeout so update the count
        counts[child][19]++;
    }
    
    // start or update the timers
    if ([DataStore NumberInTimeout]==0) {
        [self StartTimer];
    }
    [DataStore PutChildInTimeout:child];
    [self UpdateTimeouts];
}

int endTimeoutButtonHit;

- (IBAction)HitTimeoutEndButton:(id)sender {
    UIButton *buttonHit = (UIButton *) sender;
    int child = (int)((UIImageView*) buttonHit).tag;
    
    // check what the user wants
//   UIAlertView *alertDialog;
//   alertDialog = [[UIAlertView alloc]
//                  initWithTitle: @"End Time Out"
//                  message:@""
//                  delegate: self
//                  cancelButtonTitle: @"Keep child in timeout"
//                  otherButtonTitles: @"Undo timeout", @"Take child out of timeout", nil];
//    [alertDialog show];
    // 0 is undo timeout
    // 1 is take child out of time out
    // 2 is do nothing

//    if (endTimeoutButtonHit == 1) {
        [DataStore TakeChildOutOfTimeout:child];
//    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {

    endTimeoutButtonHit = buttonIndex;
    
}



#pragma mark -
#pragma mark UNDO ACTIONS

- (void) recordButtonPress :(ButtonPress*)thisButton
{
    //    NSLog(@"about to push %@",thisButton);
    [undoStack insertObject:thisButton atIndex:0];
    //    NSLog(@"stack size is %d",[undoStack count]);
    if ([undoStack count] > UNDO_LIMIT){
        [undoStack removeLastObject];
    }
    
    //    NSLog(@"stack size is %d",[undoStack count]);
    [undoButton setTitle:[[NSString alloc] initWithFormat:@"Undo (%d)", (int)[undoStack count]] forState:UIControlStateNormal];
    undoButton.enabled = true;
    undoButton.hidden = false;
}


- (IBAction)hitUndoButton:(id)sender {
    if ([undoStack count] == 0) {
        return;
    }
    ButtonPress *theButton = [undoStack objectAtIndex:0];
    int child = theButton.child;
    //    NSLog(@"%@",theButton);
    
    counts[child][theButton.value] -= (theButton.direction * pointValues[theButton.value]);
    if (counts[child][theButton.value] != 0) {
        [theButton.button setTitle:[[NSString alloc] initWithFormat:@"%d",
                                    counts[child][theButton.value]]
                          forState:UIControlStateNormal];
    }
    else {
        [theButton.button setTitle:@"" forState:UIControlStateNormal];
    }
    if (theButton.value != 19) {
        totals[child] -= (theButton.direction * pointValues[theButton.value]);
        ((UILabel *)[totalLabel objectAtIndex:child]).text =
                            [[NSString alloc] initWithFormat:@"%d", totals[child]];
        [self CheckRules :child];
    }
    [undoStack removeObjectAtIndex:0];
    if ([undoStack count] > 0) {
        [undoButton setTitle:[[NSString alloc] initWithFormat:@"Undo (%d)", (int)[undoStack count]]
                                    forState:UIControlStateNormal];
    }
    else {
        // disable and hide undo button when stack is empty
        undoButton.enabled = false;
        undoButton.hidden = true;
    }
}

- (IBAction)HitReverseSwitch:(id)sender {
    if ([reverseSwitch isOn]) {
        scoreDirection = -1;
        [DataStore TurnReverseOn];
        self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.95 alpha:1.0];
    }
    else {
        scoreDirection = 1;
        [DataStore TurnReverseOff];
        self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    }
}

#pragma mark -
#pragma mark SYSTEM

- (IBAction)MainMenuButtonHit:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void) viewWillAppear:(BOOL)animated
{
    [self FixNameOrder];
    [self FillInNames];
    [self LoadButtonValues];
    [self ResetTotalsAndCheckRules];
    if ([DataStore NumberInTimeout] >0) {
        [self StartTimer];
        [self UpdateTimeouts];
    }
    if ([DataStore GetDeviceCode] == NULL) {
        [DataStore SetRandomDeviceCode];
    }
    activityLabel.text = [DataStore GetCurrentActivity];
    timeBlockLabel.text = [DataStore GetTimeBlockLabel];
    if ([DataStore ReverseValue] == 1) {
        scoreDirection = 1;
        [reverseSwitch setOn:NO];
        self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    }
    else {
        scoreDirection = -1;
        [reverseSwitch setOn:YES];
        self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.95 alpha:1.0];
    }
    undoStack =[NSMutableArray arrayWithCapacity:UNDO_LIMIT];
    undoButton.enabled = false;
    undoButton.hidden = true;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.theScroller.contentSize = CGSizeMake( 1004.0 , 1075.0 );
    
}


- (void) viewWillDisappear:(BOOL)animated
{
    int childrenPresent = [DataStore GetNumberOfChildrenPresent];
    for (int j=0; j < childrenPresent; j++) {
        [DataStore SetChildScores:j :[NSData dataWithBytes:&counts[j] length:sizeof(counts[j])]];
    }
    [DataStore CloseOutTimeouts];
    [DataStore SaveAllChildScores];
    [self StopTimer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
