//
//  TimeoutRecord.h
//  IAR Summer Max
//
//  Created by Jeffrey McConnell on 5/31/16.
//  Copyright © 2016 Jeffrey McConnell. All rights reserved.
//

#ifndef TimeoutRecord_h
#define TimeoutRecord_h
#import <Foundation/Foundation.h>

@interface TimeoutRecord : NSObject

@property int block;
@property int length;
@property Boolean extended;
@property Boolean spansBlock;

@end


#endif /* TimeoutRecord_h */
