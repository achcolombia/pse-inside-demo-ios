//
//  PSEHeader.m
//  Khipu
//
//  Created by Iván Galaz-Jeria on 11/11/16.
//  Copyright © 2016 Khipu. All rights reserved.
//

#import "PSEHeader.h"
#import "UIImageView+AFNetworking.h"

@interface PSEHeader()

@property (weak, nonatomic) IBOutlet UILabel *subjectAmount;
@property (weak, nonatomic) IBOutlet UILabel *merchantName;
@property (weak, nonatomic) IBOutlet UIImageView *merchantImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation PSEHeader

- (CGSize) intrinsicContentSize {
    
    NSLog(@"\n\n\nShowing intrinsic size!\n\n\n");
    return CGSizeMake(UIViewNoIntrinsicMetric, 146);
}

- (void) configureWithSubject:(NSString*) subject
    formattedAmountAsCurrency:(NSString*) amount
                 merchantName:(NSString*) merchantName
             merchantImageURL:(NSString*) merchantImageURL
                paymentMethod:(NSString *) paymentMethod {
    
    [self adjustViewLayout:[[UIScreen mainScreen] bounds].size];
    [[self merchantName] setText:[NSString stringWithFormat:@"%@",merchantName]];
    [self downloadMerchantImageWithMerchantImageURL:merchantImageURL];
    
    NSMutableAttributedString *mutableAttributedString = [[[self subjectAmount] attributedText] mutableCopy];
    
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, [[self subjectAmount] attributedText].length)
                                           withString:[NSString stringWithFormat:@"%@: %@", subject, amount]];
    
    [[self subjectAmount] setAttributedText:mutableAttributedString];
}

- (void)downloadMerchantImageWithMerchantImageURL:(NSString*) pictureURL {
    
    
    NSURLRequest *merchantPictureRequest = [NSURLRequest requestWithURL:[self safeURLWithString:pictureURL]
                                                            cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                        timeoutInterval:90];
    
    [self.merchantImage setImageWithURLRequest:merchantPictureRequest
                              placeholderImage:[UIImage imageNamed:@"Merchant Stand In"]
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

                                           [self.merchantImage setImage:image];
                                       } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {

                                           NSLog(@"failed loading: %@", error);
                                       }
     ];
}

- (NSURL *) safeURLWithString:(NSString *)URLString {
    
    return [NSURL URLWithString:[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

- (void)adjustViewLayout:(CGSize)size {
    
    if (CGSizeEqualToSize(size, CGSizeMake(320, 480))) { // iPhone 4S in portrait
        
        [[self heightConstraint] setConstant:60];
    } else if (CGSizeEqualToSize(size, CGSizeMake(320, 568))) { // iPhone 5/5S in portrait
        
        [[self heightConstraint] setConstant:60];
    } else if (CGSizeEqualToSize(size, CGSizeMake(375, 667))) { // iPhone 6 in portrait
        
        [[self heightConstraint] setConstant:70];
    } else if (CGSizeEqualToSize(size, CGSizeMake(414, 736))) { // iPhone 6 Plus in portrait
        
        [[self heightConstraint] setConstant:75];
    }
    
    [self setNeedsLayout];
    
}
@end
