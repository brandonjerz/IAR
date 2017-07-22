//
//  DatePopoverController.m
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 2/24/14.
//  Copyright (c) 2014 Jeffrey McConnell. All rights reserved.
//

#import "DatePopoverController.h"
#import "AdministrationScreen.h"
#import "DataStore.h"

@interface DatePopoverController ()
- (IBAction)DoneButtonHit:(id)sender;
- (IBAction)CancelButtonHit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end


@implementation DatePopoverController

@synthesize doneButton;
@synthesize theDateChosen;
NSMutableArray *theDatesList;

- (IBAction)DoneButtonHit:(id)sender {
//    NSLog(@"done button date chosen is |%@|", theDateChosen);
    if (![theDateChosen isEqualToString:@""])
    {
//        NSLog(@"sending the notification for popover to dismiss");
        // send a message, which when picked up will dismiss this view
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissPopover" object:self];
//       [self dismissViewControllerAnimated:true completion:NULL];
    }
    else
    {
        
    }
}

- (IBAction)CancelButtonHit:(id)sender {
    theDateChosen = @"";
    // send a message, which when picked up will dismiss this view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissPopover" object:self];
//    [self dismissViewControllerAnimated:true completion:NULL];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [theDatesList count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return @"Available Dates";
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell"];
    cell.textLabel.text=(NSString *)[theDatesList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    theDateChosen = [theDatesList objectAtIndex:indexPath.row];
    [DataStore SetDateChosen:theDateChosen];
}




- (void) viewWillAppear:(BOOL)animated
{
    // initialize the date chosen
    theDateChosen = @"";
    
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    // create the path for the date list file and open the file
    NSString *dateFile;
    dateFile = [docDir stringByAppendingPathComponent: @"dateList.txt"];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:dateFile];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dateFile]) {
        
        //read the data file
        NSString *dataFull=[[NSString alloc]
                            initWithData:[fileHandle availableData]
                            encoding:NSUTF8StringEncoding];
        
        //close the data file
        [fileHandle closeFile];
        
        // break up the data file into individual lines
        theDatesList = (NSMutableArray *)[dataFull componentsSeparatedByString:@"\n"];
        [theDatesList removeObject:@""];
        doneButton.hidden = FALSE;
    }
    else {
        theDatesList = [NSMutableArray new];
        doneButton.hidden = TRUE;
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
