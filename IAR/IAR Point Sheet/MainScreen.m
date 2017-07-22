//
//  MainScreen.m
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 9/12/13.
//  Copyright (c) 2013 Jeffrey McConnell. All rights reserved.
//

#import "MainScreen.h"
#import "DataStore.h"



@implementation MainScreen

bool filesAlreadyChecked = false;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) AddDateToList: (NSString *)theDate
{
    NSMutableArray *theDatesList;
    
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    // create the path for the first file and open the file
    NSString *dateFile;
    dateFile = [docDir stringByAppendingPathComponent: @"dateList.txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dateFile]) {
        [[NSFileManager defaultManager] createFileAtPath:dateFile contents:nil attributes:nil];
        theDatesList = [NSMutableArray new];
    }
    else {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:dateFile];
        
        //read the data file
        NSString *dataFull=[[NSString alloc]
                            initWithData:[fileHandle availableData]
                            encoding:NSUTF8StringEncoding];
        
        //close the data file
        [fileHandle closeFile];
        
        // break up the data file into individual lines
        theDatesList = (NSMutableArray *)[dataFull componentsSeparatedByString:@"\n"];
    }
    if ([theDatesList indexOfObject:theDate] == NSNotFound) {
        [theDatesList addObject:theDate];
    }
    [theDatesList removeObject:@""];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:dateFile];
    for (int i=0; i<[theDatesList count]; i++) {
        [fileHandle writeData:[[theDatesList objectAtIndex:i] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //close the data file
    [fileHandle closeFile];

}

- (void) CheckForFiles
{
    if (filesAlreadyChecked) {
        return;
    }
    filesAlreadyChecked = true;    
    // load child names
    [DataStore LoadChildNames];
    [DataStore SetupForChildNames];

    NSString *deviceCode = [DataStore GetDeviceCode];
    // set up the date
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM_dd_yyyy"];
    NSString *formattedDateString = [dateFormatter stringFromDate:[NSDate date]];
    // set up the file names
    NSString *filenames[MAX_CHILDREN];
    for (int i=0; i < MAX_CHILDREN; i++) {
        filenames[i] = [[NSString alloc] initWithFormat:@"%@_%@_%@.csv", deviceCode,
                        [DataStore GetChildLetter:i], formattedDateString];
    }
    
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    for (int i=0; i<MAX_CHILDREN; i++) {
        // create the path for and open the file
        NSString *dataFile;
        dataFile = [docDir stringByAppendingPathComponent: filenames[i]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataFile]) {
            // first file doesn't exist so none exist
            dataFile = [docDir stringByAppendingPathComponent: filenames[i]];
            // create them all and initialize the data store
            [[NSFileManager defaultManager] createFileAtPath:dataFile contents:nil attributes:nil];
            [DataStore InitializeChildScores:i];
        }
        else {
            int childData[MAX_BLOCKS][20];
            NSArray *theLines, *oneLine;
            // the files for today exist so open them and read them in
            dataFile = [docDir stringByAppendingPathComponent: filenames[i]];
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:dataFile];
            
            //read the data file
            NSString *dataFull=[[NSString alloc]
                                initWithData:[fileHandle availableData]
                                encoding:NSUTF8StringEncoding];
            
            //close the data file
            [fileHandle closeFile];
            // break up the data file into individual lines
            theLines = [dataFull componentsSeparatedByString:@"\n"];
            for (int rows = 0; rows<20; rows++) {
                
                oneLine = [[theLines objectAtIndex:rows] componentsSeparatedByString:@", "];
                for (int columns=0; columns<MAX_BLOCKS; columns++) {
                    //  need the +1 for the objectAtIndex because of the row labels
                    childData[columns][rows] = (int)[[oneLine objectAtIndex:columns+1] integerValue];
                }
            }
            oneLine = [[theLines objectAtIndex:20] componentsSeparatedByString:@", "];
            
            // send the data to the data store
            for (int block=0; block < MAX_BLOCKS; block++) {
                [DataStore SetTimeBlock:block];
                [DataStore SetChildScores:i :[NSData dataWithBytes:&childData[block]
                                                            length:sizeof(childData[block])]];
                double value = [[oneLine objectAtIndex:block+1] doubleValue]*60.0;
                [DataStore SetTimeout:i :value];
            }
        }
        
    }
    [DataStore SaveAllChildScores];
    [self AddDateToList:formattedDateString];
}

- (IBAction)hitTimeBlockButton:(UIButton*)sender {
    [DataStore SetTimeBlock :(int)sender.tag];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [DataStore InitializeDataStore];
    [self CheckForFiles];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self CheckForFiles];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
