//
//  DFLBuildNewPlaylistViewController.m
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/17/14.
//
//

#import "DFLBuildNewPlaylistViewController.h"
#import "DFLMainPlaylistViewController.h"

@interface DFLBuildNewPlaylistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation DFLBuildNewPlaylistViewController

@synthesize playlistNameTextInput;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"Preparing for segue... from %@", sender);
    NSLog(@"Done Button id: %@", self.doneButton);
    
    // This should never happen...
    // Or maybe "cancel button" calls this too...
    if (sender != self.doneButton) return;
    
    NSLog(@"Came from done button...");

    
    if ([segue.identifier isEqualToString:@"buildPlaylistSegue"]) {
        
        NSLog(@"Received from the correct segue...");
    
        // Else build a new playlist object
        if (self.textField.text.length > 0){
            
            NSLog(@"Building new playlist");
            
            self.playlist = [[DFLPlaylistObject alloc] init];
            self.playlist.name = self.textField.text;
            
            NSLog(@"Playlist Name set to %@", self.textField.text);
            
            // TODO: don't hard code these once implemented
            self.playlist.vetoEnabled = false;
            self.playlist.youtubeEnabled = false;
            
            NSLog(@"Playlist modes set");
            
            // Send the object to the MainPlaylistViewController
//            [segue.destinationViewController setPlaylistName:self.textField.text];
            
            DFLMainPlaylistViewController *dest = (DFLMainPlaylistViewController *)segue.destinationViewController;
            dest.playlistName = self.textField.text;
            
//            UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
//            DFLMainPlaylistViewController *dest = [[navController viewControllers] objectAtIndex:0];
//            dest.playlistName = self.textField.text;

            // TODO: How to send full obj instead of primatives?
            //destinationViewController.playlist = self.playlist;
            NSLog(@"Playlist Built");
        }
    }
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
