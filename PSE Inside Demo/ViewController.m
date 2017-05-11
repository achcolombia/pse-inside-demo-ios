//
//  ViewController.m
//  PSE Inside Demo
//
//  Created by Iván Galaz-Jeria on 5/11/17.
//  Copyright © 2017 ach. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *authorizerPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *userTypePicker;

@property (strong, nonatomic) NSDictionary* authorizers;
@property (strong, nonatomic) NSDictionary* userTypes;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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

#pragma mark - UIPickerViewDataSource

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == [self authorizerPicker]) {
        
        return [[self authorizers] count];
    } else if (pickerView == [self userTypePicker]) {
        
        return [[self userTypes] count];
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == [self authorizerPicker]) {
        
        return [[[self authorizers] allKeys] objectAtIndex:row];
    } else if (pickerView == [self userTypePicker]) {
        
        return [[[self userTypes] allKeys] objectAtIndex:row];
    }
    
    return @"";

}


@end
