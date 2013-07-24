//
//  AirDropViewController.m
//  AirDropTest
//
//  Created by Nayak on 7/20/13.
//  Copyright (c) 2013 Alti. All rights reserved.
//

#import "AirDropViewController.h"
#import "ViewController.h"
@interface AirDropViewController ()

@end

@implementation AirDropViewController

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
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)launch:(id)sender {
   
    [[NSUserDefaults standardUserDefaults]
     setObject:_peerUser.text forKey:@"peerUser"];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
}
-(IBAction)backgroundTouched:(id)sender {
    [_peerUser resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
