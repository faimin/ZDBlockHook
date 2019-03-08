//
//  ViewController.m
//  ZDBlockHookDemo
//
//  Created by Zero.D.Saber on 2019/3/8.
//  Copyright © 2019 Zero.D.Saber. All rights reserved.
//

#import "ViewController.h"
#import <ZDBlockHook/ZDBlockHook.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupData];
}

- (void)setupData {
    //[self hookBlockIMP];
    [self testHookBlock];
}

- (void)testHookBlock {
    __auto_type block = ^NSString *(NSString *name, NSUInteger age, id<NSObject> value) {
        NSString *blockResult = [NSString stringWithFormat:@"%@ + %ld + %@", name, age, value];
        NSLog(@"block执行了: %@", blockResult);
        return blockResult;
    };
    
    {
        [self zd_hookBlock:&block hookWay:ZDHookWay_Libffi];
        
        NSString *result1 = block(@"Zero.D.Saber", 28, @100);
        NSLog(@"执行结果1 = %@", result1);
    }
    {
        [self zd_hookBlock:&block hookWay:ZDHookWay_Libffi];
        
        NSString *result2 = block(@"ABC", 100, @123);
        NSLog(@"执行结果2 = %@", result2);
    }
    
    /*
     NSString *(*originFunc)(id blockSelf, NSString *name, NSUInteger age, NSNumber *) = (__typeof__(originFunc))originIMP;
     NSString *result2 = originFunc(block, @"Zero.D.Saber", 28, @100);
     NSLog(@"执行结果2 = %@", result2);
     */
}

@end
