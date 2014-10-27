//
//  DFLAddTestItemViewController.m
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/15/14.
//
//

#import "DFLAddTestItemViewController.h"

@interface DFLAddTestItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation DFLAddTestItemViewController

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if (sender != self.doneButton) return;
    
    if(self.textField.text.length > 0) {
        self.testItem = [[DFLTestItem alloc] init];
        self.testItem.itemName = self.textField.text;
        self.testItem.completed = NO;
    }
}


@end
