//
//  AirDropViewController.h
//  AirDropTest
//
//  Created by Nayak on 7/20/13.
//  Copyright (c) 2013 Alti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirDropViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *peerUser;
-(IBAction)backgroundTouched:(id)sender;


- (IBAction)launch:(id)sender;
@end
