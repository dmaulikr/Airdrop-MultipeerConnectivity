//

//  ViewController.m

//  p2p

//

//  Created by Satya Bhanu Nayak on 15/07/13.

//  Copyright (c) 2013 Satya Bhanu Nayak. All rights reserved.

//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) MCSession * session;

@property (strong, nonatomic) MCPeerID * myPeerId;

@property (strong, nonatomic) MCNearbyServiceBrowser *browser;

@property (strong, nonatomic) MCNearbyServiceAdvertiser * advertiser;

@end

@implementation ViewController
@synthesize peersFound,peersIDs,userID,lblPeer;

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    _tblPeers.dataSource=self;
    _tblPeers.delegate=self;
    peersFound=[[NSMutableArray alloc]init];
    peersIDs=[[NSMutableArray alloc]init];
    connectFlag=FALSE;
    sendDataFlag=FALSE;
    
    //self.myPeerId = [[MCPeerID alloc] initWithDisplayName:@"iPad-Nayak"];
    //self.myPeerId = [[MCPeerID alloc] initWithDisplayName:@"iPhone-Nayak"];
    self.myPeerId = [[MCPeerID alloc] initWithDisplayName:[[NSUserDefaults standardUserDefaults]
                                                           objectForKey:@"peerUser"]];
    
    lblPeer.text=[@"Welcome to Airdrop Test: " stringByAppendingString:[[NSUserDefaults standardUserDefaults]objectForKey:@"peerUser"]];
    NSString *serviceType=@"p2ptest";
    
    
    
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.myPeerId serviceType:serviceType];
    
    self.browser.delegate=self;
    
    
    
    self.session = [[MCSession alloc] initWithPeer:self.myPeerId securityIdentity:nil encryptionPreference:MCEncryptionRequired];
    
    self.session.delegate = self;
    
    
    
    NSLog(@"ViewController :: viewDidLoad (Starting Browse)");
    
    [self.browser startBrowsingForPeers];

    NSLog(@"ViewController :: launch (Starting Advertise)");
    
    NSDictionary * discoveryInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"foo", @"bar", @"bar", @"foo", nil];
    
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeerId discoveryInfo:discoveryInfo serviceType:@"p2ptest"];
    
    self.advertiser.delegate = self;
    
    [self.advertiser startAdvertisingPeer];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"--------%d-----------------------------------------------------------------------Table Loading....",[peersIDs count]);
    if ([peersIDs count]==0) {
        return 1;
    }else
    return [peersFound count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    activityView.hidden = YES;
    //    [activityView stopAnimating];
    NSLog(@"---------------------------------Table Loading....");
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    cell=nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if ([peersFound count]==0) {
        UILabel *lbl1=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 320, 20)];
        
        [lbl1 setTextColor:[UIColor blackColor]];
        [lbl1 setFont:[UIFont fontWithName:@"Arial" size:14]];

            [lbl1 setText:@"No Users Available!"];
        [lbl1 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:lbl1];
    }else{
        UILabel *lbl1=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 320, 20)];
        
        [lbl1 setTextColor:[UIColor blackColor]];
        [lbl1 setFont:[UIFont fontWithName:@"Arial" size:14]];
        if([peersFound count]>0)
            [lbl1 setText:[peersFound objectAtIndex:indexPath.row ]];
        [lbl1 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:lbl1];
        
        imgv=[[UIImageView alloc]initWithFrame:CGRectMake(245, 10, 10, 10)];
        if([peersFound count]>0){
            [imgv setImage:[UIImage imageNamed:@"offline-icon.png"]];
        }
        [cell addSubview:imgv];
    }
        
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
     NSLog(@"------------------------------Table Loading....");
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    row=indexPath.row;
    
}


- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}



- (IBAction)refresh:(id)sender {
    NSLog(@"%@ Peerid For Connect",[peersIDs objectAtIndex:row]);
    
    [self.browser invitePeer:[peersIDs objectAtIndex:row] toSession:self.session withContext:[@"Airdrop" dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
    
    NSLog(@"ViewController :: launch (Starting Advertise)");
    
    
    [self.advertiser startAdvertisingPeer];

}



- (IBAction)launch:(id)sender {
    NSError *error;
    
    [self.session sendData:[_txtStatus.text dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:[peersIDs objectAtIndex:row]] withMode:MCSessionSendDataReliable error:&error];
    
    
}



#pragma mark - MCSessionDelegate



- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCSessionDelegate :: didReceiveData :: Received %@ from %@",[data description],peerID);
    
    NSString * message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Received Message" message:message delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:@"Denie",nil];
    
    [alert show];
    
}

- (void)session:(MCSession *)session didReceiveResourceAtURL:(NSURL *)resourceURL fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCSessionDelegate :: didReceiveResourceAtURL :: Received Resource %@ from %@",[resourceURL description],peerID);
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCSessionDelegate :: didReceiveStream :: Received Stream %@ from %@",[stream description],peerID);
    
    
    
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    NSLog(@"MCSessionDelegate :: didChangeState :: PeerId %@ changed to state %d",peerID,state);
    
    
    
    if (state == MCSessionStateConnected && self.session) {
        
        NSError *error;
        NSLog(@"MCSessionStateConnected :: didChangeState :: PeerId %@ changed to state %d",peerID,state);
        [self.session sendData:[[[_txtStatus.text stringByAppendingString:@" And "] stringByAppendingString:_txtAmount.text] dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withMode:MCSessionSendDataReliable error:&error];
        
    }else if (state == MCSessionStateNotConnected && self.session){
       

         [self.advertiser startAdvertisingPeer];
        
        
//        [self.session sendData:[_txtStatus.text dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withMode:MCSessionSendDataReliable error:&error];
    }
    
}



- (BOOL)session:(MCSession *)session shouldAcceptCertificate:(SecCertificateRef)peerCert forPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCPickerViewControllerDelegate :: shouldAcceptCertificate from peerID :: %@",peerID);
    
    return TRUE;
    
}



#pragma mark - MCNearbyServiceAdvertiserDelegate



- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    
    NSLog(@"MCNearbyServiceAdvertiserDelegate :: didNotStartAdvertisingPeer :: %@",error);
    
}



- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler {
    
    NSLog(@"MCNearbyServiceAdvertiserDelegate :: didReceiveInvitationFromPeer :: peerId :: %@",peerID);
    connectFlag=TRUE;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Received Message" message:[peerID.displayName stringByAppendingString:@" wants to Connect, Do you allow?"] delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:@"Denie",nil];
    
    [alert show];
    
    invitationHandler(TRUE,self.session);
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
   
    if (buttonIndex == 1  ) {
        NSLog(@"THE 'NO' BUTTON WAS PRESSED");
        if (connectFlag==TRUE) {
            
            connectFlag=FALSE;
        }
       
    }
}

#pragma mark - MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    
    NSLog(@"MCNearbyServiceABrowserDelegate :: didNotStartBrowsingForPeers :: error :: %@",error);
    
    
    
}



- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    NSLog(@"MCNearbyServiceABrowserDelegate :: foundPeer :: PeerID : %@ :: DiscoveryInfo : %@",peerID,info.description);
    if(peerID!=NULL && peerID!=nil)
    {
        BOOL flag=FALSE;
        for (int i=0; i<[peersFound count]; i++) {
            if ([[peersFound objectAtIndex:i] isEqualToString:peerID.displayName]) {
                flag=TRUE;
            }
        }
        if (flag==FALSE) {
            [peersFound addObject:peerID.displayName];
            [peersIDs addObject:peerID];
            [_tblPeers reloadData];
            NSLog(@"MCNearbyServiceABrowserDelegate :: foundPeer :: PeerID : %@ ",peersFound.description);
            
            
        }
    
    }
    [_tblPeers reloadData];
}



- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCNearbyServiceABrowserDelegate :: lostPeer :: PeerID : %@",peerID);
    NSLog(@"ViewController :: launch (Starting Advertise)");
    
        [self.advertiser startAdvertisingPeer];
    //[self.browser invitePeer:peerID toSession:self.session withContext:[@"Airdrop" dataUsingEncoding:NSUTF8StringEncoding] timeout:10];

    
}

-(IBAction)backgroundTouched:(id)sender {
    [_txtAmount resignFirstResponder];
    [_txtStatus resignFirstResponder];
    }

@end