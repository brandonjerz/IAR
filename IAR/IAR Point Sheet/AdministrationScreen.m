//
//  AdministrationScreen.m
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 9/12/13.
//  Copyright (c) 2013 Jeffrey McConnell. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import "AdministrationScreen.h"
#import "DatePopoverController.h"
#import "DataStore.h"
#import "LaunchView.h"

@interface AdministrationScreen () <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
- (IBAction)HitSubmitButton:(id)sender;
- (IBAction)HitCodeAndNames:(id)sender;
- (IBAction)HitClearButton:(id)sender;
@property (strong, nonatomic) MFMailComposeViewController *picker;
@end

@implementation AdministrationScreen
@synthesize thePopController;
@synthesize picker;

bool submitDateChosen;
MFMailComposeViewController *picker;


#pragma mark -
#pragma mark BUTTON HIT ROUTINES
//$$$$$
- (IBAction)HitDoneButton:(id)sender {
    //[self dismissViewControllerAnimated:true completion:nil];
    if([[DataStore GetProgram] isEqual: @"Summer"]){
        [self performSegueWithIdentifier:@"AdminToSummer" sender:self];
    }
    if([[DataStore GetProgram] isEqual: @"AfterSchool"]){
        [self performSegueWithIdentifier:@"AdminToAfterSchool" sender:self];
    }
}


- (IBAction)HitSubmitButton:(id)sender {
    
    // if there are no dates don't do the segues
    
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    // create the path for the date file
    NSString *dateFile;
    dateFile = [docDir stringByAppendingPathComponent: @"dateList.txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dateFile]) {

        [thePopController dismissPopoverAnimated:YES];
    }
    

}


- (IBAction)HitCodeAndNames:(id)sender {
    UIAlertView *alertDialog;
    alertDialog = [[ UIAlertView alloc ]
                   initWithTitle : @"Code and Names Access"
                   message : @"Please enter the password:"
                   delegate : self
                   cancelButtonTitle : @"Cancel"
                   otherButtonTitles : @"Enter", nil ];
    alertDialog. alertViewStyle = UIAlertViewStyleSecureTextInput ;
    [alertDialog show ];
 }

- (IBAction)HitClearButton:(id)sender {
    // if there are no dates don't do the segues
    
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    // create the path for the date file
    NSString *dateFile;
    dateFile = [docDir stringByAppendingPathComponent: @"dateList.txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dateFile]) {
        
        [thePopController dismissPopoverAnimated:YES];
    }
    
}


- ( void )alertView:( UIAlertView *)alertView
    clickedButtonAtIndex:( NSInteger )buttonIndex {
    if (buttonIndex == 1) {
        NSString *password=[[alertView textFieldAtIndex : 0 ] text ];
        if ([password compare:@"IARcodes"] == NSOrderedSame) {
            [self performSegueWithIdentifier:@"ToCodeAndNames" sender:self];
        }
        else {
            UIAlertView *alertDialog;
            alertDialog = [[ UIAlertView alloc ]
                           initWithTitle : @"Password Wrong"
                           message : @"The password you entered is incorrect."
                           delegate : self
                           cancelButtonTitle : @"OK"
                           otherButtonTitles : nil ];
            alertDialog. alertViewStyle = UIAlertViewStyleDefault ;
            [alertDialog show ];

        }
    }
}



#pragma mark -
#pragma mark CHOOSING THE DATE

- (void) prepareForSegue:( UIStoryboardSegue *)segue sender:( id )sender
{
    if ([segue.identifier isEqualToString: @"SubmitToDateList" ]) {
        thePopController = (( UIStoryboardPopoverSegue *)segue).popoverController;
        thePopController.delegate = self;
        submitDateChosen = TRUE;
    }
    else if ([segue.identifier isEqualToString: @"ClearToDateList" ]) {
        thePopController = (( UIStoryboardPopoverSegue *)segue).popoverController;
        thePopController.delegate = self;
        submitDateChosen = FALSE;
    }
}


- (void)dismissPopover {
//    NSLog(@"in dismissPopover");
//    [thePopController dismissPopoverAnimated:NO];
    NSString *dateFromPopover = [DataStore GetDateChosen];
//    dateFromPopover=((DatePopoverController *)thePopController.contentViewController).theDateChosen;
    if (![dateFromPopover isEqualToString:@""]){
        if (submitDateChosen) {
            [self EmailDataFiles :dateFromPopover];
            submitDateChosen = false;
        }
        else {
            [self DeleteDataFiles:dateFromPopover];
        }
    }
}

- (IBAction) exitToHere :(UIStoryboardSegue *)sender {
//    [self dismissPopover];
}

#pragma mark -
#pragma mark SENDING THE FILES


-(void)EmailDataFiles :(NSString *)date
{
//    NSLog(@"in emailDataFiles and the date is %@",date);
    picker = nil;
    picker = [MFMailComposeViewController new];
    picker.mailComposeDelegate = self;
    [picker setSubject:[date stringByAppendingString:@" tally sheets"]];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:[DataStore GetEmailToAddress]];
    // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    [picker setToRecipients:toRecipients];
    // [picker setCcRecipients:ccRecipients];
    // [picker setBccRecipients:bccRecipients];
    
    NSString *deviceCode = [DataStore GetDeviceCode];
    
    // get the files and attach them to the email
    // set up the file names
    NSString *filenames[MAX_CHILDREN];
    for (int i=0; i<MAX_CHILDREN; i++) {
        filenames[i] = [[NSString alloc] initWithFormat:@"%@_%@_%@.csv", deviceCode,
                        [DataStore GetChildLetter:i], date];
    }
    
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    // attach the files
    NSString *dataFile;
    for (int child=0; child<MAX_CHILDREN; child++) {
        dataFile = [docDir stringByAppendingPathComponent: filenames[child]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:dataFile]) {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:dataFile];
            
            //read the data file
            NSString *dataFull=[[NSString alloc]
                                initWithData:[fileHandle availableData]
                                encoding:NSUTF8StringEncoding];
            
            //close the data file
            [fileHandle closeFile];
            
            NSData *encodedFile = [dataFull dataUsingEncoding:NSUTF8StringEncoding];
            [picker addAttachmentData:encodedFile mimeType:@"text/csv" fileName:filenames[child]];
        }
    }
    
    
    
    // Fill out the email body text
    NSString *emailBody = [@"scores from device " stringByAppendingString:deviceCode];
    [picker setMessageBody:emailBody isHTML:NO];
//    NSLog(@"about to present the mail view");
//    if ([MFMailComposeViewController canSendMail] == YES){
//        NSLog(@"can it email YES");
//    }
//    else {
//        NSLog(@"can it email NO");
//    }
//    NSLog(@"the picker is %@",picker);
    picker.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:picker animated:NO completion:NULL];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:picker animated:NO completion:NULL];
    });
//    NSLog(@"leaving method EmailDataFiles");
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
//    NSLog(@"In didFinishwithResult result = %u and error = %@", result, error);
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
 //           NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
 //           NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
 //           NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
 //           NSLog(@"Result: failed");
            break;
        default:
 //           NSLog(@"Result: not sent");
            break;
    }
    [picker dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark -
#pragma mark DELETING FILES

-(void) DeleteDataFiles :(NSString *)date
{
    NSString *theDeviceCode = [DataStore GetDeviceCode];
    
    // set up the file names
    NSString *filenames[MAX_CHILDREN];
    for (int i = 0; i < MAX_CHILDREN; i++) {
        filenames[i] = [[NSString alloc] initWithFormat:@"%@_%@_%@.csv", theDeviceCode,
                        [DataStore GetChildLetter:i], date];
    }
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    // delete the files
    NSString *dataFile;
    for (int child=0; child<MAX_CHILDREN; child++) {
        dataFile = [docDir stringByAppendingPathComponent: filenames[child]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:dataFile]) {
            [[NSFileManager defaultManager] removeItemAtPath:dataFile error:Nil];
        }
    }
    // now delete the date
    NSMutableArray *theDatesList;
    
    // create the path for the first file and open the file
    NSString *FileOfStoredDates;
    FileOfStoredDates = [docDir stringByAppendingPathComponent: @"dateList.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:FileOfStoredDates]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:FileOfStoredDates];
        
        //read the data file
        NSString *dataFull=[[NSString alloc]
                            initWithData:[fileHandle availableData]
                            encoding:NSUTF8StringEncoding];
        
        //close the data file
        [fileHandle closeFile];
        
        // break up the data file into individual lines
        theDatesList = (NSMutableArray *)[dataFull componentsSeparatedByString:@"\n"];
    }
    [theDatesList removeObject:date];
    [theDatesList removeObject:@""];
    if ([theDatesList count] == 0) {
        // delete the old file because there are no dates left
        [[NSFileManager defaultManager] removeItemAtPath:FileOfStoredDates error:Nil];
        
    }
    else {
        // delete the old file because a shortened file will have junk at the end
        [[NSFileManager defaultManager] removeItemAtPath:FileOfStoredDates error:Nil];
        [[NSFileManager defaultManager] createFileAtPath:FileOfStoredDates contents:nil attributes:nil];
        
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:FileOfStoredDates];
        for (int i=0; i<[theDatesList count]; i++) {
            [fileHandle writeData:[[theDatesList objectAtIndex:i] dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //close the data file
        [fileHandle closeFile];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissPopover) name:@"dismissPopover" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
