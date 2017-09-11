//
//  ViewController.h
//  MyCalculator
//
//  Created by Oleksandr Kurtsev on 11.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    OperationAdd,
    OperationSubtract,
    OperationMultiply,
    OperationDivide,
    OperationResult,
    OperationNone,
    OperationPercent
    
} OKMathematicalOperation;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroLabel;

- (IBAction)actionPositiveOrNegativeNumber:(UIButton *)sender;
- (IBAction)actionMathematicalOperation:(UIButton *)sender;
- (IBAction)actionTouchDownZero:(UIButton *)sender;
- (IBAction)actionSelectNumber:(UIButton *)sender;
- (IBAction)actionReset:(UIButton *)sender;
- (IBAction)actionPoint:(UIButton *)sender;

@end

