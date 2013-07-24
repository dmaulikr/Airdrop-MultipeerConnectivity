//

//  ViewController.h

//  p2p

//

//  Created by Satya Bhanu Nayak on 15/07/13.

//  Copyright (c) 2013 Satya Bhanu Nayak. All rights reserved.

//



#import <UIKit/UIKit.h>

#import <MultipeerConnectivity/MultipeerConnectivity.h>



@interface ViewController : UIViewController <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *peersFound;
    NSMutableArray *peersIDs;
    UIImageView *imgv;
    
    NSString *userID;
    int row;
    
    BOOL connectFlag;
    BOOL sendDataFlag;
    
}
@property (strong, nonatomic) IBOutlet UILabel *lblPeer;
@property (nonatomic,retain) NSString *userID;
@property (strong, nonatomic) IBOutlet UITableView *tblPeers;
@property (nonatomic,retain) NSMutableArray *peersFound;
@property (nonatomic,retain) NSMutableArray *peersIDs;
@property (strong, nonatomic) IBOutlet UITextField *txtStatus;
@property (strong, nonatomic) IBOutlet UITextField *txtAmount;

@property (strong, nonatomic) IBOutlet UIButton *buttonCreate;
-(IBAction)backgroundTouched:(id)sender;
- (IBAction)refresh:(id)sender;

- (IBAction)launch:(id)sender;



@end
