//
//  DataStore.h
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 10/25/13.
//  Copyright (c) 2013 Jeffrey McConnell. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_BLOCKS  20
#define MAX_CATEGORIES 20
#define MAX_CHILDREN    12
#define kButtonCount    20
#define kButtonsInArray 19



@interface DataStore : NSObject

+ (void) InitializeDataStore;

+ (void) SetTimeBlock :(int) block;
+ (int) GetTimeBlock;
+ (NSString *) GetTimeBlockLabel;

+ (void) SetNumberOfChildren :(int) count;
+ (int) GetNumberOfChildren;
+ (int) GetNumberOfChildrenPresent;

+ (void) InitializeChildScores :(int) child;
+ (void) InitializeChildScoresBlock :(int) child : (int) block;
+ (void) SetChildScores :(int) child :(NSData *) scores;
+ (void) SetTimeout :(int) child :(double) timeout;
+ (NSData *) GetChildScores :(int) child;
+ (void) SaveAllChildScores;
+ (NSString *) GetChildLetter :(int) child;

+ (void) SetSummaryChildChosen :(int) child;
+ (int) GetSummaryChildChosen;
+ (NSData *) GetChildSummary :(int) child;
+ (double) GetChildTotalTimeout :(int) child;

+ (BOOL) IsChildInTimeout : (int) child;
+ (int) NumberInTimeout;
+ (void) PutChildInTimeout : (int) child;
+ (void) TakeChildOutOfTimeout : (int) child;
+ (NSString *) GetTimeoutTime : (int) child;
+ (void) CloseOutTimeouts;

+ (void) SetChildName :(int) child theName :(NSString *) name;
+ (void) SetupForChildNames;
+ (NSString *) GetChildNamePlain :(int) child;
+ (NSString *) GetChildNameSplit :(int) child;
+ (void) SaveChildNames;
+ (void) LoadChildNames;

+ (void) SetChildPresent :(int) child isPresent :(BOOL) present;
+ (BOOL) GetChildPresent :(int) child;

+ (void) SetDateChosen :(NSString *) theDate;
+ (NSString *) GetDateChosen;

+ (void) SetDeviceCode :(NSString *) theCode;
+ (void) SetRandomDeviceCode;
+ (NSString *) GetDeviceCode;

+ (void) SetEmailToAddress :(NSString *)address;
+ (NSString *) GetEmailToAddress;

+ (int) GetSSCount;
+ (NSString *) GetSSName :(int) item;
+ (void) PickedSSItem :(int) slot :(int) item;

+ (int) GetTACount;
+ (NSString *) GetTAName :(int) item;
+ (void) PickedTAItem :(int) slot :(int) item;

+ (NSString *) GetCurrentActivity;

+ (void) TurnReverseOff;
+ (void) TurnReverseOn;
+ (int) ReverseValue;

//$$$$$
+ (void) SetProgram:(NSString *)selectedProgram; // changes program to new program the user selects
+ (NSString *) GetProgram; // gets current program in DataStore



@end
