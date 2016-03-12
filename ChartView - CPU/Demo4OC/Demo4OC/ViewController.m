//
//  ViewController.m
//  Demo4OC
//
//  Created by 胡 帅 on 16/2/1.
//  Copyright © 2016年 Disney. All rights reserved.
//

#import "ViewController.h"
#import "Demo4OC-Swift.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet ChartView * test;

@end

@implementation ViewController

- (IBAction)swithDisplayLevel:(UIBarButtonItem *)sender {
    [_test setDisplayLevel:sender.tag];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_test setBackgroundColor:[UIColor whiteColor]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"500_data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    
    NSMutableArray *mArr = [NSMutableArray array];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([json isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)json;
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            CVRecord *record = [[CVRecord alloc] init];
            record.date = [self timestampFromString:(NSString *)(((NSDictionary *)json[idx])[@"date"])];
            record.lowValue = [(NSNumber *)((NSDictionary *)json[idx])[@"lowValue"] floatValue];
            record.highValue = [(NSNumber *)((NSDictionary *)json[idx])[@"highValue"] floatValue];
            [mArr addObject:record];
        }];
    }
    CVRecordSet *dataSource = [[CVRecordSet alloc] init];
    dataSource.data = mArr;
    
    
    [_test setDataSource:dataSource];
    
    _test.UI_HighCurve_Color = [UIColor blackColor];
    [_test reloadData];
}

//字符串时间——时间戳
- (NSTimeInterval) timestampFromString:(NSString *)theTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:theTime];
    return [date timeIntervalSince1970];
}

@end
