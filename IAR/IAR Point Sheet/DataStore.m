//
//  DataStore.m
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 10/25/13.
//  Copyright (c) 2013 Jeffrey McConnell. All rights reserved.
//

#import "DataStore.h"
#import "TimeoutRecord.h"
#import "CodeAndNames.h"

@implementation DataStore

#define SS_COUNT    32
#define TA_COUNT   37

NSString *letters[MAX_CHILDREN] = {@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L"};


int timeBlock;

NSData *childScores[MAX_CHILDREN][MAX_BLOCKS];

NSString *names[MAX_CHILDREN];
int numberOfChildren, numberOfChildrenPresent;
bool childPresent[MAX_CHILDREN];
int childMapping[MAX_CHILDREN];

NSString *datePicked;

int summaryChildChosen;

bool childInTimeout[MAX_CHILDREN];
double timeoutLeft[MAX_CHILDREN];
double timeoutStart[MAX_CHILDREN];
double timeoutServed[MAX_CHILDREN][MAX_BLOCKS];
int timeoutCount;
//NSMutableArray *timeoutList[MAX_CHILDREN];


NSString *whichProgram;//$$$$$ stores program

NSString *deviceCode;

NSString *SSActivities[SS_COUNT];
NSString *TAActivities[TA_COUNT];
int SSChosen[3];
int TAChosen[2];

NSString *timeBlockNames[MAX_BLOCKS];

NSString *categoryNames[22];

bool dataStoreInitialized = false;

int reverseDirection;

#pragma mark -
#pragma mark INITIALIZE

+ (void) InitializeDataStore
{
    if (!dataStoreInitialized) {
        dataStoreInitialized = true;
        
        reverseDirection = 1;
        numberOfChildren = MAX_CHILDREN;
        
        for (int i=0; i<MAX_CHILDREN; i++) {
            childPresent[i]=true;
        }
        
        for (int i=0; i<MAX_CHILDREN; i++) {
            for (int j=0; j<MAX_BLOCKS; j++) {
                timeoutServed[i][j] = 0.0;
            }
        }
        timeoutCount = 0;
        
        SSChosen[0] = SSChosen[1] = SSChosen[2] = 0;
        TAChosen[0] = TAChosen[1] = 0;
        SSActivities[0] = @"Accepting a compliment";
        SSActivities[1] = @"Accepting consequences";
        SSActivities[2] = @"Apologizing";
        SSActivities[3] = @"Asking a question";
        SSActivities[4] = @"Asking for help";
        SSActivities[5] = @"Asking permission";
        SSActivities[6] = @"Avoiding trouble";
        SSActivities[7] = @"Being a good sport";
        SSActivities[8] = @"Contributing to discussions";
        SSActivities[9] = @"Dealing with another's anger";
        SSActivities[10] = @"Dealing with being left out";
        SSActivities[11] = @"Ending a conversation";
        SSActivities[12] = @"Expressing concern for another";
        SSActivities[13] = @"Expressing your feelings";
        SSActivities[14] = @"Face and emotion recognition";
        SSActivities[15] = @"Following instructions";
        SSActivities[16] = @"Giving a compliment";
        SSActivities[17] = @"Giving instructions";
        SSActivities[18] = @"Having a conversation";
        SSActivities[19] = @"Ignoring distractions";
        SSActivities[20] = @"Introducing yourself";
        SSActivities[21] = @"Joining in";
        SSActivities[22] = @"Listening";
        SSActivities[23] = @"Negotiating";
        SSActivities[24] = @"Non-literal language interpretation";
        SSActivities[25] = @"Offering to help a classmate";
        SSActivities[26] = @"Offering to help an adult";
        SSActivities[27] = @"Recognizing another's feelings";
        SSActivities[28] = @"Responding to teasing";
        SSActivities[29] = @"Sharing";
        SSActivities[30] = @"Showing understanding of another's\nfeelings";
        SSActivities[31] = @"Using self control";
        
        TAActivities[0] = @"Art Computer Peer Topic";
        TAActivities[1] = @"Art Computer Self Interest Book";
        TAActivities[2] = @"Art-Computer Grabbag Book";
        TAActivities[3] = @"Balloon Volleyball";
        TAActivities[4] = @"Blindfold and Obstacle Landing";
        TAActivities[5] = @"Board Games";
        TAActivities[6] = @"Charades";
        TAActivities[7] = @"Chariots of Fire and Three-legged race";
        TAActivities[8] = @"Collage Other";
        TAActivities[9] = @"Collage-Scavenger hunt";
        TAActivities[10] = @"Crab Soccer";
        TAActivities[11] = @"Don't Break the Egg";
        TAActivities[12] = @"Expression Paintings";
        TAActivities[13] = @"Face Pictionary";
        TAActivities[14] = @"Faces Collage";
        TAActivities[15] = @"Facial Concentration";
        TAActivities[16] = @"Fact or Fiction";
        TAActivities[17] = @"Five Catches";
        TAActivities[18] = @"Four Square";
        TAActivities[19] = @"Freeze Tag Emotions";
        TAActivities[20] = @"Group Island";
        TAActivities[21] = @"Group Loop";
        TAActivities[22] = @"Hula Hoop Circle Relay";
        TAActivities[23] = @"Idiom Jeopardy";
        TAActivities[24] = @"If my friends and I were animals";
        TAActivities[25] = @"One-handed construction";
        TAActivities[26] = @"Problem Solve Game";
        TAActivities[27] = @"Proudly Presenting";
        TAActivities[28] = @"River Crossing";
        TAActivities[29] = @"Self Portrait";
        TAActivities[30] = @"Stranded on an Island";
        TAActivities[31] = @"T-shirt Art";
        TAActivities[32] = @"Team Pictionary";
        TAActivities[33] = @"Transformations";
        TAActivities[34] = @"Translate the Bacon";
        TAActivities[35] = @"Trust Fall";
        TAActivities[36] = @"Video Facial Recognition";
        
        timeBlockNames[0] = @"8:50-9:15 Social Skill I";
        timeBlockNames[1] = @"9:15-9:40 Therapeutic Activity 1-A";
        timeBlockNames[2] = @"9:40-10:00 Therapeutic Activity 1-B";
        timeBlockNames[3] = @"10:00-10:10 Transition I";
        timeBlockNames[4] = @"10:10-10:35 Social Skill II";
        timeBlockNames[5] = @"10:35-11:00 Therapeutic Activity 2-A";
        timeBlockNames[6] = @"11:00-11:20 Therapeutic Activity 2-B";
        timeBlockNames[7] = @"11:20-11:30 Transition II";
        timeBlockNames[8] = @"11:30-12:00 Lunch";
        timeBlockNames[9] = @"12:00-12:25 Social Skill III";
        timeBlockNames[10] = @"12:25-12:50 Therapeutic Activity 3-A";
        timeBlockNames[11] = @"12:50-1:10 Therapeutic Activity 3-B";
        timeBlockNames[12] = @"1:10-1:20 Transition III";
        timeBlockNames[13] = @"1:20-1:45 Social Skill IV";
        timeBlockNames[14] = @"1:45-2:10 Therapeutic Activity 4-A";
        timeBlockNames[15] = @"2:10-2:30 Therapeutic Activity 4-B";
        timeBlockNames[16] = @"2:30-2:35 & 3:00-3:10 Transition IV";
        timeBlockNames[17] = @"2:35-3:00 Social Skill V";
        timeBlockNames[18] = @"3:10-3:35 Therapeutic Activity 5-A";
        timeBlockNames[19] = @"3:35-3:55 Therapeutic Activity 5-B";
        
        categoryNames[0] =@"Program Rules (+50)";
        categoryNames[1] =@"Friendship Skills (+50)";
        categoryNames[2] =@"Social Skill A of Day (+10)";
        categoryNames[3] =@"Social Skill B of Day (+10)";
        categoryNames[4] =@"Social Skill C of Day (+10)";
        categoryNames[5] =@"Prior Social Skills (+10)";
        categoryNames[6] =@"Follows Instructions (+20)";
        categoryNames[7] =@"Not Following Instructions (-20)";
        categoryNames[8] =@"Violates Rules of Activity (-10)";
        categoryNames[9] =@"Not Active in Group (-10)";
        categoryNames[10] =@"Uses Materials Incorrectly (-10)";
        categoryNames[11] =@"Out of Seat (-10)";
        categoryNames[12] =@"Violates Personal Space (-10)";
        categoryNames[13] =@"VPS - Harm (-25)";
        categoryNames[14] =@"Poor Eye Contact (-10)";
        categoryNames[15] =@"Interruption (-10)";
        categoryNames[16] =@"Negative Comments (-10)";
        categoryNames[17] =@"Sharing Irrelevant Info (-10)";
        categoryNames[18] =@"Run-On Communication (-10)";
        categoryNames[19] =@"Time Out (count)";
        categoryNames[20] =@"Time Out (total time)";
        categoryNames[21] =@"Time Out (average)";
    }
};


#pragma mark -
#pragma mark CHILD COUNT

+ (void) SetNumberOfChildren :(int) count
{
    numberOfChildren = count;
    for (int i=0; i<MAX_CHILDREN; i++) {
//        NSLog(@"|%@|", names[i]);
        names[i] = [names[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSLog(@"|%@|", names[i]);
}
    
    int nameCount = MAX_CHILDREN;
    for (int i=0; i<MAX_CHILDREN; i++) {
        if ((names[i] == NULL) || [names[i] isEqualToString: @""]) {
            nameCount--;
        }
    }
//    NSLog(@"Set found a count of %d names", nameCount);
    numberOfChildren = nameCount;
}


+ (int) GetNumberOfChildren
{
    return numberOfChildren;
}


+ (int) GetNumberOfChildrenPresent
{
    [self SetupForChildNames];
    return numberOfChildrenPresent;
}



#pragma mark -
#pragma mark TIME BLOCK

+ (void) SetTimeBlock :(int) block
{
    timeBlock = block;
//    NSLog(@"set time block to %d\n", timeBlock);
};


+ (int) GetTimeBlock
{
    return timeBlock;
};

+ (NSString *) GetTimeBlockLabel
{
    return timeBlockNames[timeBlock];
}

#pragma mark -
#pragma mark SCORES

+ (void) InitializeChildScores :(int) child
{
    int initialScores[20] = {0};
    int mappedChild = childMapping[child];
    for (int i=0; i<MAX_BLOCKS; i++) {
        childScores[mappedChild][i] = [NSData dataWithBytes:&initialScores length:sizeof(initialScores)];
    }
};

+ (void) InitializeChildScoresBlock :(int) child :(int) block
{
    int initialScores[20] = {0};
    int mappedChild = childMapping[child];
    childScores[mappedChild][block] = [NSData dataWithBytes:&initialScores length:sizeof(initialScores)];
};


+ (void) SetChildScores :(int) child :(NSData *) scores
{
    int mappedChild = childMapping[child];
    childScores[mappedChild][timeBlock] = scores;
};


+ (void) SetTimeout:(int)child :(double)timeout {
    int mappedChild = childMapping[child];
    timeoutServed[mappedChild][timeBlock] = timeout;
}

+ (NSData *) GetChildScores :(int) child
{
    int mappedChild = childMapping[child];
    if (childScores[mappedChild][timeBlock] == NULL) {
        [self InitializeChildScoresBlock :child :timeBlock];
    }
    return childScores[mappedChild][timeBlock];
};


+ (void) SaveAllChildScores
{
    // set up the date
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM_dd_yyyy"];
    NSString *formattedDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    // set up the file names
    NSString *filenames[MAX_CHILDREN];
    for (int i = 0; i < MAX_CHILDREN; i++) {
        filenames[i] = [[NSString alloc] initWithFormat:@"%@_%@_%@.csv", deviceCode, letters[i], formattedDateString];
    }
    
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    
    NSString *dataFile;
    NSFileHandle *fileHandle;
    int score[MAX_BLOCKS][MAX_CATEGORIES];
    
    for (int child = 0; child < MAX_CHILDREN; child++)
    {
        // create the path for the file and open the file
        dataFile = [docDir stringByAppendingPathComponent: filenames[child]];
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:dataFile];
        
        // save the data
        
        for (int j=0; j<MAX_BLOCKS; j++) {
            NSData *theScores = childScores[child][j];
            memcpy(score[j], theScores.bytes, theScores.length);
        }
        for (int i=0; i< MAX_CATEGORIES; i++) {
            NSString *oneLine = categoryNames[i];
            for (int j=0; j<MAX_BLOCKS; j++) {
                oneLine = [oneLine stringByAppendingString:[NSString stringWithFormat:@", %d", score[j][i]]];
            }
            [fileHandle writeData:[oneLine dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }

        // write out the total time in timeout
        NSString *oneLine = categoryNames[20];
        for (int j=0; j<MAX_BLOCKS; j++) {
            oneLine = [oneLine stringByAppendingString:[NSString stringWithFormat:@", %.2f",
                                                        (timeoutServed[child][j]/60.0)]];
        }
        [fileHandle writeData:[oneLine dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // write out the average time in timeout
        oneLine = categoryNames[21];
        for (int j=0; j<MAX_BLOCKS; j++) {
            if (score[j][19] > 0) {
                oneLine = [oneLine stringByAppendingString:[NSString stringWithFormat:@", %.2f",
                                                            ((timeoutServed[child][j]/60.0)/score[j][19])]];
            }
            else {
                oneLine = [oneLine stringByAppendingString:@", "];
            }
        }
        [fileHandle writeData:[oneLine dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //close the file
        [fileHandle closeFile];
    }

}

//


+ (NSString *) GetChildLetter:(int)child {
    return letters[child];
}

#pragma mark -
#pragma mark SUMMARY

+ (void) SetSummaryChildChosen :(int) child {
    summaryChildChosen = child;
}


+ (int) GetSummaryChildChosen {
    return summaryChildChosen;
}


+ (NSData *) GetChildSummary :(int) child {
    int score[MAX_BLOCKS][MAX_CATEGORIES];
    for (int j=0; j<MAX_BLOCKS; j++) {
        NSData *theScores = childScores[child][j];
        memcpy(score[j], theScores.bytes, theScores.length);
    }
    int totals[MAX_CATEGORIES+1];
    totals[MAX_CATEGORIES-1] = 0;
    for (int i=0; i<MAX_CATEGORIES-1; i++) {
        totals[i] = 0;
        for (int j=0; j<MAX_BLOCKS; j++) {
            totals[i] += score[j][i];
        }
        totals[MAX_CATEGORIES-1] += totals[i];
    }
    totals[MAX_CATEGORIES] = 0;
    for (int j=0; j<MAX_BLOCKS; j++) {
        totals[MAX_CATEGORIES] += score[j][MAX_CATEGORIES-1];
    }
    NSData *result = [NSData dataWithBytes:&totals length:sizeof(totals)];
    return result;
}


+ (double) GetChildTotalTimeout :(int) child {
    double result = 0;
    
    for (int i=0; i<MAX_BLOCKS; i++) {
        result += timeoutServed[child][i];
    }
    
    return result;
}


#pragma mark -
#pragma mark EMAIL ADDRESS

+ (void) SetEmailToAddress :(NSString *)address
{
    // write the email address to a file
    
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    
    NSString *emailToFile;
    NSFileHandle *fileHandle;
    // create the path for the file and open the file
    emailToFile = [docDir stringByAppendingPathComponent: @"emailToAddress.txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:emailToFile]) {
            [[NSFileManager defaultManager] createFileAtPath:emailToFile contents:nil attributes:nil];
    }
    fileHandle = [NSFileHandle fileHandleForWritingAtPath:emailToFile];
    [fileHandle writeData:[address dataUsingEncoding:NSUTF8StringEncoding]];
    
    //close the file
    [fileHandle closeFile];
}


+ (NSString *) GetEmailToAddress
{
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    
    NSString *emailToFile;
    NSFileHandle *fileHandle;
    // create the path for the file and open the file
    emailToFile = [docDir stringByAppendingPathComponent: @"emailToAddress.txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:emailToFile]) {
        [[NSFileManager defaultManager] createFileAtPath:emailToFile contents:nil attributes:nil];
        return @"";
    }
    else {
        fileHandle = [NSFileHandle fileHandleForReadingAtPath:emailToFile];
        return [[NSString alloc] initWithData:[fileHandle availableData]
                                           encoding:NSUTF8StringEncoding];
    }
    [fileHandle closeFile];
}

#pragma mark -
#pragma mark NAMES

+ (void) SetChildName :(int) child theName :(NSString *) name
{
    names[child] = name;
}

+ (void) SetupForChildNames
{

    numberOfChildrenPresent = 0;
    for (int i=0; i<MAX_CHILDREN; i++) {
        if (childPresent[i]) {
            childMapping[numberOfChildrenPresent]=i;
            numberOfChildrenPresent++;
        }
    }
}

+ (NSString *) GetChildNamePlain :(int) child
{
    return names[child];
}

+ (NSString *) GetChildNameSplit :(int)child
{
    const char * theName;
    int mappedChild = childMapping[child];
    int nameLen = (int)[names[mappedChild] length];
    unichar newName[2*nameLen+1];
    theName = [names[mappedChild] cStringUsingEncoding: NSASCIIStringEncoding];
    for (int i=0; i<nameLen; i++) {
        newName[2*i] = theName[i];
        newName[2*i+1] = '\n';
    }
    newName[2*nameLen] = '\0';
    return [[NSString alloc] initWithCharacters:newName length:2*nameLen];
}


+ (void) SaveChildNames
{
    
    
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    
    NSString *namesFile;
    NSFileHandle *fileHandle;
    // create the path for the file and open the file
    namesFile = [docDir stringByAppendingPathComponent: @"childNames.txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:namesFile]) {
        [[NSFileManager defaultManager] createFileAtPath:namesFile contents:nil attributes:nil];
    }
   else {
        [[NSFileManager defaultManager] removeItemAtPath:namesFile error:nil];
       [[NSFileManager defaultManager] createFileAtPath:namesFile contents:nil attributes:nil];
    }
    fileHandle = [NSFileHandle fileHandleForWritingAtPath:namesFile];
    for (int i = 0; i < MAX_CHILDREN; i++) {
        [fileHandle writeData:[names[i] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle writeData:[@" \n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //close the file
    [fileHandle closeFile];
}


+ (void) LoadChildNames
{
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    // create the path for the date list file and open the file
    NSString *namesFile;
    namesFile = [docDir stringByAppendingPathComponent: @"childNames.txt"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:namesFile]) {
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:namesFile];
        
        //read the data file
        NSString *dataFull=[[NSString alloc]
                            initWithData:[fileHandle availableData]
                            encoding:NSUTF8StringEncoding];
        
        //close the data file
        [fileHandle closeFile];
        
        // break up the data file into individual lines
        NSMutableArray *theNamesList = (NSMutableArray *)[dataFull componentsSeparatedByString:@" \n"];
        [theNamesList removeObject:@""];
//        NSLog(@"theNamesList size is %d", [theNamesList count]);
        for (int i=0; i<[theNamesList count]; i++) {
            names[i] = [theNamesList objectAtIndex:i];
//            NSLog(@"name %d is %@", i, [theNamesList objectAtIndex:i]);
        }
        numberOfChildren = (int)[theNamesList count];
    }
    [self SetNumberOfChildren:numberOfChildren];
}

#pragma mark -
#pragma mark PRESENT


+ (void) SetChildPresent :(int) child isPresent :(BOOL) present
{
    childPresent[child] = present;
}


+ (BOOL) GetChildPresent :(int) child
{
    return childPresent[child];
}


#pragma mark -
#pragma mark DATE_CHOICE

+ (void) SetDateChosen:(NSString *)theDate {
    datePicked = theDate;
}

+ (NSString *) GetDateChosen {
    return datePicked;
}


#pragma mark -
#pragma mark CODE

+ (void) SetDeviceCode:(NSString *)theCode
{
    if (deviceCode != NULL) {
        [self RenameFiles:theCode];
    }
    deviceCode = theCode;
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];

    // create the path for the device code file and open the file
    NSString *dataFile = [docDir stringByAppendingPathComponent: @"deviceCode.txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataFile]) {
        [[NSFileManager defaultManager] createFileAtPath:dataFile contents:nil attributes:nil];
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:dataFile];
    [fileHandle writeData:[deviceCode dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle truncateFileAtOffset:[fileHandle offsetInFile]];

    //close the file
    [fileHandle closeFile];
   
}

+ (void) SetRandomDeviceCode
{
    int randomCode = arc4random() % 100000;
    [self SetDeviceCode: [[NSString alloc] initWithFormat:@"%d", randomCode]];
}

+ (NSString *) GetDeviceCode
{
    if (deviceCode == NULL) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                NSUserDomainMask, YES) objectAtIndex: 0];
        // create the path for the device code file and open the file
        NSString *dataFile = [docDir stringByAppendingPathComponent: @"deviceCode.txt"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataFile]) {
            [self SetRandomDeviceCode];
        }
        else {
            
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:dataFile];
            
            //read the data file
            deviceCode = [[NSString alloc] initWithData:[fileHandle availableData]
                                               encoding:NSUTF8StringEncoding];            
            //close the data file
            [fileHandle closeFile];
        }
    }
    return deviceCode;
}


+ (void) RenameFiles :(NSString *)newCode
{
    // get the location where the data files should be
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    // create the path for the date list file and open the file
    NSString *dateFile;
    dateFile = [docDir stringByAppendingPathComponent: @"dateList.txt"];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:dateFile];
    
    //read the data file
    NSString *dataFull=[[NSString alloc]
                        initWithData:[fileHandle availableData]
                        encoding:NSUTF8StringEncoding];
    
    //close the data file
    [fileHandle closeFile];
    
    // break up the data file into individual lines
    NSMutableArray *theDatesList = (NSMutableArray *)[dataFull componentsSeparatedByString:@"\n"];
    [theDatesList removeObject:@""];
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    for (int i=0; i < [theDatesList count]; i++) {
        // create the old and new filenames
        NSString *oldNames[MAX_CHILDREN];
        NSString *newNames[MAX_CHILDREN];
        for (int j = 0; j < MAX_CHILDREN; j++) {
            oldNames[j] = [[NSString alloc] initWithFormat:@"%@_%@_%@.csv",
                           deviceCode, letters[j], [theDatesList objectAtIndex:i]];
            newNames[j] = [[NSString alloc] initWithFormat:@"%@_%@_%@.csv",
                           newCode, letters[j], [theDatesList objectAtIndex:i]];
        }
        
        
        for (int j=0; j< MAX_CHILDREN; j++) {
            
            // Rename the files, by moving the files
            NSString *oldPath = [docDir stringByAppendingPathComponent:oldNames[j]];
            NSString *newPath = [docDir stringByAppendingPathComponent:newNames[j]];
            
            if (![fileMgr fileExistsAtPath:oldPath]) {
                [fileMgr moveItemAtPath:oldPath toPath:newPath error:nil];
            }
        }
    }
    
}

#pragma mark -
#pragma mark PROGRAM
//$$$$$
+ (void) SetProgram:(NSString *)selectedProgram{

   
    whichProgram = selectedProgram;
    NSLog(@"A new program just got selected. The program is %@ and %@",whichProgram,selectedProgram);
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    
    // create the path for the device code file and open the file
    NSString *dataFile = [docDir stringByAppendingPathComponent: @"whichProgram.txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataFile]) {
        [[NSFileManager defaultManager] createFileAtPath:dataFile contents:nil attributes:nil];
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:dataFile];
    [fileHandle writeData:[whichProgram dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle truncateFileAtOffset:[fileHandle offsetInFile]];
    
    //close the file
    [fileHandle closeFile];
}
//$$$$$
+ (NSString *) GetProgram{
    
    if (whichProgram == NULL) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                NSUserDomainMask, YES) objectAtIndex: 0];
        
        
        // create the path for the device code file and open the file
        NSString *dataFile = [docDir stringByAppendingPathComponent: @"whichProgram.txt"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataFile]) {
            NSLog(@"file manager for program not found");
            [self SetProgram:@"AfterSchool"];
        }
        else {
            
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:dataFile];
            
            //read the data file
            whichProgram = [[NSString alloc] initWithData:[fileHandle availableData]
                                               encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@ was gotten from the file directory",whichProgram);
            //close the data file
            [fileHandle closeFile];
        }
    }
    return whichProgram;
    
}







#pragma mark -
#pragma mark ACTIVITIES

+ (int) GetSSCount
{
    return SS_COUNT;
};


+ (NSString *) GetSSName :(int) item
{
    return SSActivities[item];
};


+ (void) PickedSSItem :(int) slot :(int) item
{
    SSChosen[slot] = item;
//    NSLog(@"set sschosen[%d]=%d\n",slot, item);
};


+ (int) GetTACount
{
    return TA_COUNT;
};


+ (NSString *) GetTAName :(int) item
{
    return TAActivities[item];
};


+ (void) PickedTAItem :(int) slot :(int) item
{
    TAChosen[slot] = item;
//    NSLog(@"set tachosen[%d]=%d\n",slot, item);
};


+ (NSString *) GetCurrentActivity {
//    NSLog(@"time is %d", timeBlock);
//    switch (timeBlock) {
//        case 0:
//            NSLog(@"%d %@", SSChosen[0], SSActivities[SSChosen[0]]);
//            return SSActivities[SSChosen[0]];

//        case 1: case 2:
//            NSLog(@"%d %@", TAChosen[0], TAActivities[TAChosen[0]]);
//            return TAActivities[TAChosen[0]];

//        case 3:
//            NSLog(@"%d %@", SSChosen[1], SSActivities[SSChosen[1]]);
//            return SSActivities[SSChosen[1]];
            
//        case 4: case 5:
//            NSLog(@"%d %@", TAChosen[1], TAActivities[TAChosen[1]]);
//            return TAActivities[TAChosen[1]];
//        default:
            return @"";
//    }
}


#pragma mark -
#pragma mark TIMEOUT


#define kTimerInterval  0.1
NSTimer *theTimer;

+ (void) StartTimer {
    theTimer=[NSTimer scheduledTimerWithTimeInterval: kTimerInterval
                                                   target:self
                                                 selector:@selector(countDown)
                                                 userInfo:nil
                                                  repeats:YES];
}

+ (void) StopTimer {
    [theTimer invalidate];
    theTimer = NULL;
}

+ (NSString *) GetTimeoutTime : (int) child {
    NSString *result;
    int mappedChild = childMapping[child];
    int minutesLeft = timeoutLeft[mappedChild] / 60;
    int secondsLeft = (int)trunc(timeoutLeft[mappedChild]) % 60;
    if (secondsLeft < 10) {
        result = [[NSString alloc] initWithFormat:@"%d:0%d", minutesLeft, secondsLeft];
    }
    else {
        result = [[NSString alloc] initWithFormat:@"%d:%d", minutesLeft, secondsLeft];
    }
    return result;
}

+ (void) countDown {
    for (int i=0; i < MAX_CHILDREN; i++) {
        if (childInTimeout[i]) {
            timeoutLeft[i] -= kTimerInterval;
            if (timeoutLeft[i] <= 0) {
                childInTimeout[i] = false;
                timeoutServed[i][timeBlock] += timeoutStart[i];
                
                // put a timeout record in
//                TimeoutRecord *newRecord = [TimeoutRecord alloc];
//                newRecord.block = timeBlock;
//                newRecord.length = timeoutStart[i];
//                newRecord.extended = false;
//                if (timeoutStart[i] < 120.0)
//                    newRecord.spansBlock = true;
//                else
//                    newRecord.spansBlock = false;
//                [timeoutList[i] addObject:newRecord];
                
                timeoutCount--;
                if (timeoutCount == 0) {
                    [self StopTimer];
                }
            }
        }
    }
}


+ (BOOL) IsChildInTimeout : (int) child {
    int mappedChild = childMapping[child];
    return childInTimeout[mappedChild];
}


+ (int) NumberInTimeout {
    return timeoutCount;
}


+ (void) PutChildInTimeout : (int) child {
    int mappedChild = childMapping[child];
    if (!childInTimeout[mappedChild]) {
        childInTimeout[mappedChild] = true;
        timeoutLeft[mappedChild] = 120.0;
        timeoutStart[mappedChild] = 120.0;
        if (timeoutCount == 0) {
            [self StartTimer];
        }
        timeoutCount++;
    }
    else {
        // the child is already in timeout so record time served
        // and reset to 2 minutes
        timeoutServed[mappedChild][timeBlock] += (timeoutStart[mappedChild] - timeoutLeft[mappedChild]);
        
        // put a timeout record in
//        TimeoutRecord *newRecord = [TimeoutRecord alloc];
//        newRecord.block = timeBlock;
//        newRecord.length = timeoutStart[mappedChild] - timeoutLeft[mappedChild];
//        newRecord.extended = true;
//        if (timeoutStart[mappedChild] < 120.0)
//            newRecord.spansBlock = true;
//        else
//            newRecord.spansBlock = false;
//        [timeoutList[mappedChild] addObject:newRecord];
        

        timeoutLeft[mappedChild] = 120.0;
        timeoutStart[mappedChild] = 120.0;
    }
}


+ (void) TakeChildOutOfTimeout : (int) child {
    int mappedChild = childMapping[child];
    childInTimeout[mappedChild] = false;
    timeoutCount--;
    timeoutServed[mappedChild][timeBlock] += (timeoutStart[mappedChild] - timeoutLeft[mappedChild]);

    // put a timeout record in
//    TimeoutRecord *newRecord = [TimeoutRecord alloc];
//    newRecord.block = timeBlock;
//    newRecord.length = timeoutStart[mappedChild] - timeoutLeft[mappedChild];
//    newRecord.extended = false;
//    if (timeoutStart[mappedChild] < 120.0)
//        newRecord.spansBlock = true;
//    else
//        newRecord.spansBlock = false;
//    [timeoutList[mappedChild] addObject:newRecord];

    
    if (timeoutCount == 0) {
        [self StopTimer];
    }
}


+ (void) CloseOutTimeouts {
    for (int i=0; i<MAX_CHILDREN; i++) {
        if (childInTimeout[i]) {
            timeoutServed[i][timeBlock] += (timeoutStart[i] - timeoutLeft[i]);
            
            // add a spans block record here
            
            timeoutStart[i] = timeoutLeft[i];
        }
    }
}


#pragma mark -
#pragma mark REVERSE SWITCH
+ (void) TurnReverseOff {
    reverseDirection = 1;
}


+ (void) TurnReverseOn {
    reverseDirection = -1;
}


+ (int) ReverseValue {
    return reverseDirection;
}

@end
