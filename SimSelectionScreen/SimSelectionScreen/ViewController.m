//
//  ViewController.m
//  SimSelectionScreen
//
//  Created by Abbie on 06/08/20.
//  Copyright © 2020 Abbie. All rights reserved.
//

#import "ViewController.h"
#import<CoreTelephony/CTCallCenter.h>
#import<CoreTelephony/CTCall.h>
#import<CoreTelephony/CTCarrier.h>
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController ()<UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *sim1Name;
@property (strong, nonatomic) IBOutlet UILabel *sim2Name;
@property (strong, nonatomic) IBOutlet UIButton *sim1Choose;
@property (strong, nonatomic) IBOutlet UIButton *sim2Choose;
@property (strong, nonatomic) NSMutableArray *carrierNamesSIM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ _sim1Choose setImage: [UIImage imageNamed:@"unchecked.png"]forState:UIControlStateNormal];
    [_sim2Choose setImage: [UIImage imageNamed:@"checked.png"]forState: UIControlStateSelected];
    [_sim1Choose addTarget:self
              action:@selector(btnAction:)
    forControlEvents:UIControlEventTouchUpInside];
    [_sim2Choose addTarget:self
              action:@selector(btnAction:)
    forControlEvents:UIControlEventTouchUpInside];
    CTTelephonyNetworkInfo *networkInfo=[CTTelephonyNetworkInfo new];
    CTCarrier *aCarrier;
    NSDictionary *providers = [networkInfo serviceSubscriberCellularProviders];
    NSLog(@"%@", providers);
    _carrierNamesSIM = [[NSMutableArray alloc]init];
    for (NSString *aKey in providers) {
        aCarrier = providers[aKey];
        NSString *code = [aCarrier carrierName];
        [_carrierNamesSIM addObject:code];
        NSLog(@"Country code: %@", code);
    }
    NSLog(@"After loop, Code Array is %@", _carrierNamesSIM);
    _sim1Name.text = [_carrierNamesSIM objectAtIndex:0];
    _sim2Name.text = [_carrierNamesSIM objectAtIndex:1];
    
}


- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSMutableArray *)recipients{
 MFMessageComposeViewController *controller1 = [[MFMessageComposeViewController alloc] init] ;
 controller1 = [[MFMessageComposeViewController alloc] init] ;
 if([MFMessageComposeViewController canSendText])
{
    controller1.body = bodyOfMessage;
    controller1.recipients = recipients;
    controller1.messageComposeDelegate = self;
    [self presentViewController:controller1 animated:YES completion:Nil];
 }
}

- (void)btnAction:(id)sender {

if ([sender isSelected]) {
    [sender setSelected:NO];

    if (sender == self.sim1Choose) {
        [self.sim2Choose setSelected:YES];
    }
    if (sender == self.sim2Choose) {
        [self.sim1Choose setSelected:YES];
    }
}

else
{
    [sender setSelected:YES];

    if (sender == self.sim1Choose) {
        [self.sim2Choose setSelected:NO];
    }
    if (sender == self.sim2Choose) {
        [self.sim1Choose setSelected:NO];
    }

}
}

- (IBAction)proceedAction:(id)sender {
    if (_carrierNamesSIM.count != 0) {
        [self sendSMS:@"Abhi" recipientList:[NSMutableArray arrayWithObject:@"566788"]];
    }
}

@end
