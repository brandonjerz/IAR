//
//  DatePopoverController.h
//  IAR Point Sheet
//
//  Created by Jeffrey McConnell on 2/24/14.
//  Copyright (c) 2014 Jeffrey McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePopoverController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, atomic) NSString *theDateChosen;

@end
