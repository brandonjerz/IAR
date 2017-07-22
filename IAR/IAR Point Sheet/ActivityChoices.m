//
//  ActivityChoices.m
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 10/25/13.
//  Copyright (c) 2013 Jeffrey McConnell. All rights reserved.
//

#import "ActivityChoices.h"
#import "DataStore.h"

@implementation ActivityChoices

- (IBAction)HitDone:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView.tag == 0)
        return 3;
    else
        return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
                numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 0)
        return [DataStore GetSSCount];
    else
        return [DataStore GetTACount];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *activityLabel;
    activityLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,335,32)];
    activityLabel.backgroundColor=[UIColor clearColor];
    if (pickerView.tag == 0)
        activityLabel.text=[DataStore GetSSName:(int)row];
    else
        activityLabel.text=[DataStore GetTAName:(int)row];
    return activityLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component {
	return 55.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (pickerView.tag == 0)
        return 230.0;
    else
        return 345.0;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
	   inComponent:(NSInteger)component {
//    NSLog(@"picker with tag %d and component %d and row %d\n", pickerView.tag, component, row);
    if (pickerView.tag==0)
        [DataStore PickedSSItem:(int)component :(int)row];
    else
        [DataStore PickedTAItem:(int)component :(int)row];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
