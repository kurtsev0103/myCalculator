//
//  ViewController.m
//  MyCalculator
//
//  Created by Oleksandr Kurtsev on 11.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) OKMathematicalOperation operation;

@property (nonatomic, assign) CGFloat firstValue;
@property (nonatomic, assign) CGFloat secondValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.operation = OperationNone;
    self.displayLabel.text = [NSString stringWithFormat:@"%g", self.firstValue];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)performMathAction {
    
    switch (self.operation) {
        case OperationAdd:
            self.firstValue += self.secondValue;
            break;
        case OperationSubtract:
            self.firstValue -= self.secondValue;
            break;
        case OperationMultiply:
            self.firstValue *= self.secondValue;
            break;
        case OperationDivide:
            self.firstValue /= self.secondValue;
            break;
        case OperationPercent:
            self.firstValue /= 100;
            break;
        default:
            break;
    }

    self.secondValue = 0;
    self.displayLabel.text = [NSString stringWithFormat:@"%g", self.firstValue];
}

#pragma mark - Actions

- (IBAction)actionSelectNumber:(UIButton *)sender {
    
    if (sender.tag == 0) {
        self.zeroLabel.enabled = YES;
    }
    
    NSString* string;
    
    if (self.secondValue == 0 && self.operation == OperationNone) {
        
        if (self.firstValue == 0) {
            
            if (self.displayLabel.text.length > 1) {
                string = self.displayLabel.text;
                string = [string stringByAppendingFormat:@"%ld", (long)sender.tag];
                self.displayLabel.text = string;
                self.firstValue = [self.displayLabel.text floatValue];
            } else {
                self.firstValue = sender.tag;
                self.displayLabel.text = [NSString stringWithFormat:@"%ld", sender.tag];
            }
            
        } else {
            string = self.displayLabel.text;
            string = [string stringByAppendingFormat:@"%ld", (long)sender.tag];
            self.displayLabel.text = string;
            self.firstValue = [self.displayLabel.text floatValue];
        }

    } else if (self.operation != OperationNone && self.operation != OperationResult) {
        
        if (self.secondValue == 0 &&
            [[NSString stringWithFormat:@"%g", self.firstValue] isEqualToString:self.displayLabel.text]) {
            
            self.secondValue = sender.tag;
            self.displayLabel.text = [NSString stringWithFormat:@"%ld", sender.tag];
   
        } else {
            string = self.displayLabel.text;
            string = [string stringByAppendingFormat:@"%ld", (long)sender.tag];
            self.displayLabel.text = string;
            self.secondValue = [self.displayLabel.text floatValue];
        }
        
    } else if (self.operation == OperationResult) {
        
        if ([self.displayLabel.text isEqualToString:@".0"]) {
            string = self.displayLabel.text;
            string = [string stringByAppendingFormat:@"%ld", (long)sender.tag];
            self.displayLabel.text = string;
            self.secondValue = 0;
        } else {
            self.firstValue = sender.tag;
            self.displayLabel.text = [NSString stringWithFormat:@"%ld", sender.tag];
            self.firstValue = [self.displayLabel.text floatValue];
            self.operation = OperationNone;
            self.secondValue = 0;
        }
        
    }
    
}

- (IBAction)actionMathematicalOperation:(UIButton *)sender {
    
    void (^refreshDisplay)(void) = ^{
        
        NSString* str = self.displayLabel.text;
        self.displayLabel.text = @"";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.displayLabel.text = str;
        });
    };
    
    if (self.operation != OperationNone &&
        self.operation != OperationPercent &&
        self.secondValue == [[NSString stringWithFormat:@"%@", self.displayLabel.text] floatValue]) {
        [self performMathAction];
    } else {
        refreshDisplay();
    }
    
    switch (sender.tag) {
        case 10:
            self.operation = OperationDivide;
            break;
        case 11:
            self.operation = OperationMultiply;
            break;
        case 12:
            self.operation = OperationSubtract;
            break;
        case 13:
            self.operation = OperationAdd;
            break;
        case 14:
            self.operation = OperationResult;
            break;
        case 15:
            self.operation = OperationPercent;
            [self performMathAction];
            refreshDisplay();
            break;
    }
    
}

- (IBAction)actionReset:(UIButton *)sender {
    self.firstValue = self.secondValue = 0;
    
    self.displayLabel.text = @"";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.displayLabel.text = [NSString stringWithFormat:@"%g", self.firstValue];
    });

    self.operation = OperationNone;
}

- (IBAction)actionPositiveOrNegativeNumber:(UIButton *)sender {
    
    if ([[NSString stringWithFormat:@"%g", self.firstValue] isEqualToString:self.displayLabel.text] && self.firstValue != 0) {
        self.firstValue *= -1;
        
        self.displayLabel.text = @"";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.displayLabel.text = [NSString stringWithFormat:@"%g", self.firstValue];
        });
        
    } else if ([[NSString stringWithFormat:@"%g", self.secondValue] isEqualToString:self.displayLabel.text] && self.secondValue != 0) {
        self.secondValue *= -1;
        
        self.displayLabel.text = @"";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.displayLabel.text = [NSString stringWithFormat:@"%g", self.secondValue];
        });
    }
}

- (IBAction)actionPoint:(UIButton *)sender {
    
    NSRange range = [self.displayLabel.text rangeOfString:@"."
                                                  options:NSBackwardsSearch
                                                    range:NSMakeRange(0, [self.displayLabel.text length])];
    
    if (range.location != NSNotFound) {
        
        if (range.location == self.displayLabel.text.length - 1) {
            self.displayLabel.text = [self.displayLabel.text substringToIndex:self.displayLabel.text.length - 1];
        }
        
    } else {

        NSString* string = [NSString stringWithFormat:@"%@", self.displayLabel.text];
        string = [string stringByAppendingFormat:@"."];
        self.displayLabel.text = [NSString stringWithFormat:@"%@", string];
        
    }
    
}

- (IBAction)actionTouchDownZero:(UIButton *)sender {
    self.zeroLabel.enabled = NO;
}

#pragma mark - Orientation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
