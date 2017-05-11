//
//  SuccessPaymentViewController.m
//  Browser2AppDemo
//
//  Created by Iván Galaz-Jeria on 1/4/17.
//  Copyright © 2017 khipu. All rights reserved.
//

#import "SuccessPaymentViewController.h"
#import "UIViewController+Utils.h"
#import "UIImageViewAligned.h"

@interface SuccessPaymentViewController ()

@property (weak, nonatomic) IBOutlet UILabel*   viewTitle;
@property (weak, nonatomic) IBOutlet UILabel*   message;
@property (weak, nonatomic) IBOutlet UIImageViewAligned *bankImageHeader;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (strong, nonatomic) void (^finishBlock)(void);
@property (strong, nonatomic) NSString*         titleText;
@property (strong, nonatomic) NSString*         messageText;
@property (strong, nonatomic) NSURL*            merchantImageURL;

@end

@implementation SuccessPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    
    [self.viewTitle setAttributedText:[self attributedTextWithString:[self titleText]
                                          originalAttributedString:self.viewTitle.attributedText]];

    [self.message setAttributedText:[self attributedTextWithString:[self messageText]
                                          originalAttributedString:self.message.attributedText]];
    
    [self setImageTo:[self bankImageHeader]
            imageURL:[self merchantImageURL]];
    [self paint:[self finishButton]];
    [[self finishButton] setTitle:@"Terminar"
                         forState:UIControlStateNormal];
}

- (void) configureWithPaymentSubject:(NSString*) subject
           formattedAmountAsCurrency:(NSString*) amount
                        merchantName:(NSString*) merchantName
                    merchantImageURL:(NSString*) merchantImageURL
                       paymentMethod:(NSString*) paymentMethod
                               title:(NSString*) title
                             message:(NSString*) message
                              finish:(void (^)(void)) finish {
    
    [self setFinishBlock:finish];
    [self setTitleText:NSLocalizedString(title, nil)];
    [self setMessageText:NSLocalizedString(message, nil)];
    [self setMerchantImageURL:[self safeURLWithString:merchantImageURL]];
}

- (IBAction)finishClicked:(id)sender {
    
    [self finishBlock]();
}

@end
