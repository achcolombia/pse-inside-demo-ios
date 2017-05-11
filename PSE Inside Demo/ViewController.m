//
//  ViewController.m
//  PSE Inside Demo
//
//  Created by Iván Galaz-Jeria on 5/11/17.
//  Copyright © 2017 ach. All rights reserved.
//

#import "ViewController.h"

#import "UIViewController+Utils.h"
#import "RDHExpandingPickerView.h"
#import <khenshin/khenshin.h>

@interface ViewController () <RDHExpandingPickerViewDataSource, RDHExpandingPickerViewDelegate>

@property (strong, nonatomic) NSDictionary* authorizers;
@property (strong, nonatomic) NSDictionary* userTypes;

@property (weak, nonatomic) IBOutlet RDHExpandingPickerView *authorizerPicker;
@property (weak, nonatomic) IBOutlet RDHExpandingPickerView *userTypePicker;

@property (weak, nonatomic) IBOutlet UITextField *ecus;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITextField *commerce;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *returnURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[self authorizerPicker] setTitle:@"Autorizador" forState:UIControlStateNormal];
    [[self authorizerPicker] setPlaceholderValue:@"Seleccionar"];

    [[self userTypePicker] setTitle:@"Tipo de Usuario" forState:UIControlStateNormal];
    [[self userTypePicker] setPlaceholderValue:@"Seleccionar"];
}

- (NSDictionary*) authorizers {
    
    if (!_authorizers) {
        _authorizers = @{@"BANCO AGRARIO": @"1040",
                         @"BANCO AV VILLAS": @"1040" ,
                         @"BANCO BBVA COLOMBIA S.A.": @"1040" ,
                         @"BANCO CAJA SOCIAL": @"1040",
                         @"BANCO COLPATRIA": @"1040" ,
                         @"BANCO COOPERATIVO COOPCENTRAL": @"1040",
                         @"BANCO CORPBANCA S.A": @"1040" ,
                         @"BANCO DAVIVIENDA": @"1040" ,
                         @"BANCO DE BOGOTA": @"1040" ,
                         @"BANCO DE OCCIDENTE": @"1040",
                         @"BANCO FALABELLA": @"1040" ,
                         @"BANCO GNB SUDAMERIS": @"1040" ,
                         @"BANCO PICHINCHA S.A.": @"1040" ,
                         @"BANCO POPULAR": @"1040",
                         @"BANCO PROCREDIT": @"1040" ,
                         @"BANCOLOMBIA": @"1040" ,
                         @"BANCOOMEVA S.A.": @"1040" ,
                         @"CITIBANK": @"1040" ,
                         @"HELM BANK S.A.": @"1040",
                         @"NEQUI": @"1040"};
    }
    
    return _authorizers;
}

- (NSDictionary*) userTypes {
    
    if (!_userTypes) {
        _userTypes = @{@"Persona natural": @"0",
                       @"Persona jurídica": @"1"};
    }
    
    return _userTypes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    _authorizers = nil;
    _userTypes = nil;
}

#pragma mark - RDHExpandingPickerViewDataSource

-(NSUInteger)numberOfComponentsInExpandingPickerView:(RDHExpandingPickerView *)expandingPickerView {
    
    return 1;
}

-(NSUInteger)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView numberOfRowsInComponent:(NSUInteger)component {
    
    if (expandingPickerView == [self authorizerPicker]) {
        
        return [[self authorizers] count];
    } else if (expandingPickerView == [self userTypePicker]) {
        
        return [[self userTypes] count];
    }
    return 0;
}


#pragma mark - RDHExpandingPickerViewDelegate

-(NSString *)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView titleForRow:(NSUInteger)row forComponent:(NSUInteger)component {

    if (expandingPickerView == [self authorizerPicker]) {
        
        return [[[self authorizers] allKeys] objectAtIndex:row];
    } else if (expandingPickerView == [self userTypePicker]) {
        
        return [[[self userTypes] allKeys] objectAtIndex:row];
    }
    
    return @"";
}

#pragma mark - Khenshin

- (IBAction)goPay:(UIButton *)sender {
    
    if (! [self allValuesAreSet]) {
        
        [self showOKAlertWithTitle:@"Error"
                           message:@"Faltan valores en el formulario"];
        return;
    }
    
    
    NSString* userTypeId = [[self userTypes] valueForKey:[[[self userTypes] allKeys] objectAtIndex:[(NSNumber*)[[self userTypePicker] selectedObject][0] integerValue]]];
    NSString* authorizerId = [[self authorizers] valueForKey:[[[self authorizers] allKeys] objectAtIndex:[(NSNumber*)[[self authorizerPicker] selectedObject][0] integerValue]]];
    
    [KhenshinInterface startEngineWithAutomatonId:[NSString stringWithFormat:@"%@%@", userTypeId, authorizerId]
                                         animated:YES
                                       parameters:@{@"cus": [[self formValues] valueForKey:@"cus"],
                                                    @"amount": [[self formValues] valueForKey:@"amount"],
                                                    @"authorizedId": authorizerId,
                                                    @"subject": [[self formValues] valueForKey:@"subject"],
                                                    @"merchant": [[self formValues] valueForKey:@"merchant"],
                                                    @"cancelURL": [[self formValues] valueForKey:@"returnURL"],
                                                    @"paymentId": [[self formValues] valueForKey:@"cus"],
                                                    @"userType": @"roberto@opazo.cl",
                                                    @"returnURL": [[self formValues] valueForKey:@"returnURL"],
                                                    @"payerEmail": [[self formValues] valueForKey:@"payerEmail"]}
                                   userIdentifier:nil
                                          success:^(NSURL *returnURL) {
                                              
                                              NSLog(@"Volver con ¡éxito!");
                                          } failure:^(NSURL *returnURL) {
                                              
                                              NSLog(@"Volver con fracaso :(");
                                          }];
}

- (BOOL) allValuesAreSet {
    
    NSLog(@"[[self authorizerPicker] selectedObject][0]: %@", [[self authorizerPicker] selectedObject][0]);
    
    if ([self textFielsIsEmpty:[self ecus]] ||
        [self textFielsIsEmpty:[self amount]] ||
        [self textFielsIsEmpty:[self subject]] ||
        [self textFielsIsEmpty:[self commerce]] ||
        [self textFielsIsEmpty:[self email]] ||
        [self textFielsIsEmpty:[self returnURL]] ||
        [[self authorizerPicker] selectedObject] == NULL ||
        [[self userTypePicker] selectedObject] == NULL) {
        
        return NO;
    }
    
    return YES;
}

- (NSDictionary*) formValues {
    
    return @{@"cus": [[self ecus] text],
             @"amount": [[self amount] text],
             @"subject": [[self subject] text],
             @"merchant": [[self commerce] text],
             @"payerEmail": [[self email] text],
             @"returnURL": [[self returnURL] text]};
    
}

- (BOOL) textFielsIsEmpty:(UITextField*) textField {
    return [[[textField text] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] length] == 0;
}

@end
