//
//  DFLMainPlaylistViewController.m
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/17/14.
//
//

@import MediaPlayer;

#import "TDSession.h"
#import "TDAudioStreamer.h"

#import "DFLMainPlaylistViewController.h"
#import "DFLAppDelegate.h"

@interface DFLMainPlaylistViewController () <TDSessionDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *playlistTitle;
@property (strong, nonatomic) DFLAppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *songArtist;

@property (strong, nonatomic) TDSession *session;
@property (strong, nonatomic) TDAudioInputStreamer *inputStream;

@end

@implementation DFLMainPlaylistViewController

@synthesize playlistLabel;
@synthesize playlistName;
@synthesize playlist;
@synthesize connectedDevice;

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
    
    NSLog(@"establishing connections");
    
    // Do any additional setup after loading the view.
    self.playlistLabel.text = playlistName;
    
    
    // Set up a session so clients can connect to this host
//    self.appDelegate = (DFLAppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    [self.appDelegate.mpcHandler setupPeerWithDisplayName:[UIDevice currentDevice].name];
//    [self.appDelegate.mpcHandler setupSession];
//    // TODO: make this toggleable? If for some reason people want to hide their presence on the wifi...
//    [self.appDelegate.mpcHandler advertiseSelf:true];
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(peerChangedStateWithNotification:)
//                                                 name:@"MPCHandler_DidChangeStateNotification"
//                                               object:nil];
//    
//    if (self.appDelegate.mpcHandler.session != nil) {
//        [[self.appDelegate mpcHandler] setupBrowser];
//        [[[self.appDelegate mpcHandler] browser] setDelegate:self];
//        [self presentViewController:self.appDelegate.mpcHandler.browser
//                           animated:YES
//                         completion:nil];
//    }
    
    self.session = [[TDSession alloc] initWithPeerDisplayName:[UIDevice currentDevice].name];
    [self.session startAdvertisingForServiceType:@"shared-playlist" discoveryInfo:nil];
    self.session.delegate = self;
    
    [self presentViewController:[self.session browserViewControllerForSeriviceType:@"shared-playlist"] animated:YES completion:nil];
}

- (void)changeSongInfo:(NSDictionary *)info
{
    if (info[@"artwork"])
        self.albumImage.image = info[@"artwork"];
    else
        self.albumImage.image = nil;
    
    self.songTitle.text = info[@"title"];
    self.songArtist.text = info[@"artist"];
}

- (void)session:(TDSession *)session didReceiveAudioStream:(NSInputStream *)stream
{
    NSLog(@"Stream Established.");
    if (!self.inputStream) {
        self.inputStream = [[TDAudioInputStreamer alloc] initWithInputStream:stream];
        [self.inputStream start];
    }
}

- (void)peerChangedStateWithNotification:(NSNotification *)notification {
    // Get the state of the peer.
    int state = [[[notification userInfo] objectForKey:@"state"] intValue];
    NSLog(@"peer state changed");
    
    // We care only for the Connected and the Not Connected states.
    // The Connecting state will be simply ignored.
    if (state != MCSessionStateConnecting) {
        NSLog(@"Device connected");
        // We'll just display all the connected peers (players) to the text view.
//        NSString *allPlayers = @"Other players connected with:\n\n";
//        
//        for (int i = 0; i < self.appDelegate.mpcHandler.session.connectedPeers.count; i++) {
//            NSString *displayName = [[self.appDelegate.mpcHandler.session.connectedPeers objectAtIndex:i] displayName];
//            
//            allPlayers = [allPlayers stringByAppendingString:@"\n"];
//            allPlayers = [allPlayers stringByAppendingString:displayName];
//        }
        
//        [self.tvPlayerList setText:allPlayers];
        
        self.connectedDevice.text = [[self.appDelegate.mpcHandler.session.connectedPeers objectAtIndex:0] displayName];
    
        [self.connectedDevice setText:[[self.appDelegate.mpcHandler.session.connectedPeers objectAtIndex:0] displayName]];
    
        self.connectedDevice.text = [[self.session.connectedPeers objectAtIndex:0] displayName];
        
        [self.connectedDevice setText:[[self.session.connectedPeers objectAtIndex:0] displayName]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Methods to handle the 'done' and 'cancel' buttons after establishing a peer connection
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self.appDelegate.mpcHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self.appDelegate.mpcHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

//useless, just getting rid of the compiler warning. i guess could be useful later for sending other random data
- (void)session:(TDSession *)session didReceiveData:(NSData *)data
{
    NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self performSelectorOnMainThread:@selector(changeSongInfo:) withObject:info waitUntilDone:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
