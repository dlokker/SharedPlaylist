//
//  DFLJoinPlaylistViewController.m
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/22/14.
//
//

#import "DFLJoinPlaylistViewController.h"
#import "DFLPlaylistObject.h"
#import "DFLAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "TDAudioStreamer.h"
#import "TDSession.h"

@interface DFLJoinPlaylistViewController () <MPMediaPickerControllerDelegate>

@property NSMutableArray *playlists;
@property (strong, nonatomic) DFLAppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *songArtist;

@property (strong, nonatomic) MPMediaItem *song;
@property (strong, nonatomic) TDAudioOutputStreamer *outputStreamer;
@property (strong, nonatomic) TDSession *session;
@property (strong, nonatomic) AVPlayer *player;

@end

@implementation DFLJoinPlaylistViewController

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
    // Do any additional setup after loading the view.
    
//    self.session = [[TDSession alloc] initWithPeerDisplayName:@"Client"];
//    [self.session startAdvertisingForServiceType:@"dance-party" discoveryInfo:nil];
//    self.session.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{

}
- (IBAction)searchForConnections:(id)sender {
    // Set up a session to connect to a host playlist
//    self.appDelegate = (DFLAppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    [self.appDelegate.mpcHandler setupPeerWithDisplayName:[UIDevice currentDevice].name];
//    [self.appDelegate.mpcHandler setupSession];
//    // TODO: make this toggleable? If for some reason people want to hide their presence on the wifi...
//    [self.appDelegate.mpcHandler advertiseSelf:true];
//    
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
}
- (IBAction)selectSong:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"You picked : %@",mediaItemCollection);
//    
//    // Prep the selected song for streaming
//    NSURL *url = [mediaItemCollection valueForProperty:MPMediaItemPropertyAssetURL];
//    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
//    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:asset error:nil];
//    AVAssetReaderTrackOutput *assetOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:asset.tracks[0] outputSettings:nil];
//    
//    [assetReader addOutput:assetOutput];
//    [assetReader startReading];
//    
//    // Prep the stream
//    NSError *error = nil;
//    NSOutputStream *outputStream = [self.appDelegate.mpcHandler.session
//                                    startStreamWithName:@"song-stream"
//                                    toPeer:self.appDelegate.mpcHandler.session.connectedPeers[0]
//                                    error:&error];
//
//    outputStream.delegate = self;
//    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
//                      forMode:NSDefaultRunLoopMode];
//    [outputStream open];
//    
//    // Prep buffers for streaming
//    CMSampleBufferRef sampleBuffer = [assetOutput copyNextSampleBuffer];
//    
//    CMBlockBufferRef blockBuffer;
//    AudioBufferList audioBufferList;
//    
//    CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, NULL, &audioBufferList, sizeof(AudioBufferList), NULL, NULL, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &blockBuffer);
//    
//    for (NSUInteger i = 0; i < audioBufferList.mNumberBuffers; i++) {
//        AudioBuffer audioBuffer = audioBufferList.mBuffers[i];
//        [audioStream writeData:audioBuffer.mData maxLength:audioBuffer.mDataByteSize];
//    }
//    
//    CFRelease(blockBuffer);
//    CFRelease(sampleBuffer);
    
    
    //--------------
    NSLog(@"Setting up song for streaming...");
    if (self.outputStreamer) return;
    
    self.song = mediaItemCollection.items[0];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"title"] = [self.song valueForProperty:MPMediaItemPropertyTitle] ? [self.song valueForProperty:MPMediaItemPropertyTitle] : @"";
    info[@"artist"] = [self.song valueForProperty:MPMediaItemPropertyArtist] ? [self.song valueForProperty:MPMediaItemPropertyArtist] : @"";
    
//    MPMediaItemArtwork *artwork = [self.song valueForProperty:MPMediaItemPropertyArtwork];
//    UIImage *image = [artwork imageWithSize:self.albumImage.frame.size];
//    if (image)
//        info[@"artwork"] = image;
//    
//    if (info[@"artwork"])
//        self.albumImage.image = info[@"artwork"];
//    else
//        self.albumImage.image = nil;
    
    self.songTitle.text = info[@"title"];
    self.songArtist.text = info[@"artist"];
    
    [self.session sendData:[NSKeyedArchiver archivedDataWithRootObject:[info copy]]];
    
    NSArray *peers = [self.session connectedPeers];
    
    NSLog(@"Done with setup");
    
    if (peers.count) {
        NSLog(@"Beginning stream");
        self.outputStreamer = [[TDAudioOutputStreamer alloc] initWithOutputStream:[self.session outputStreamForPeer:peers[0]]];
        [self.outputStreamer streamAudioFromURL:[self.song valueForProperty:MPMediaItemPropertyAssetURL]];
        [self.outputStreamer start];
    }
    else {
        NSLog(@"Stream failed...");
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
    //TODO: programmatically send to new activity with the playlist info on it
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self.appDelegate.mpcHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

// Method to handler cancel button when selecting a song
- (void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
