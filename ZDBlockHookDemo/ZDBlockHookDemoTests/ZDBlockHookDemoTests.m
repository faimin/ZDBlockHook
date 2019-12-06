//
//  ZDBlockHookDemoTests.m
//  ZDBlockHookDemoTests
//
//  Created by Zero.D.Saber on 2019/3/8.
//  Copyright © 2019 Zero.D.Saber. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZDBlockHook.h"

@interface ZDBlockHookDemoTests : XCTestCase

@end

@implementation ZDBlockHookDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testBlockHook {
    __auto_type block = ^NSString *(NSInteger count, NSString *str, NSObject *obj) {
        NSString *result = [NSString stringWithFormat:@"%ld, %@, %@", count*2, str, obj];
        return result;
    };
    id oldBlock = [block copy];
    
    ZDHookWay hookWay = ZDHookWay_MsgForward;
    [self zd_hookBlock:&block hookWay:hookWay];
    NSString*(^newBlock)(NSInteger count, NSString *str, NSObject *obj) = [block copy];
    
    if (hookWay == ZDHookWay_MsgForward) {
        XCTAssertNotEqual(oldBlock, newBlock);
    } else if (hookWay == ZDHookWay_Libffi) {
        XCTAssertEqual(oldBlock, newBlock);
    }
    
    NSString *blockResult = block(123, @"2019年01月14日12:04:26", @999);
    XCTAssertEqualObjects(blockResult, @"246, 2019年01月14日12:04:26, 999");
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
}

//------------------------------------------------------------------
#pragma mark -

static NSString *printHookMsg(id self, SEL _cmd) {
    NSLog(@"hookBlock");
    return @"hook successed";
}

- (void)testHookBlockIMP {
    __auto_type block = ^NSString *(NSString *name, NSUInteger age) {
        NSLog(@"block");
        return [NSString stringWithFormat:@"%@ + %ld", name, age];
    };
    
    //IMP imp = imp_implementationWithBlock(block);
    
    struct ZDBlock_layout *layout = (__bridge void *)block;
    if (!(layout->flags & BLOCK_HAS_SIGNATURE)) return;
    
    // ref orgin IMP
    IMP originIMP = (void *)(layout->invoke);
    NSString *(*originFunc)(id blockSelf, NSString *name, NSUInteger age) = (void *)originIMP;
    
    // replace origin IMP by new IMP
    layout->invoke = (void *)printHookMsg;
    
    NSString *result = block(@"Zero.D.Saber", 28);
    NSLog(@"原始block执行结果：---> %@", result);
    
    // 第一个参数是block自己，后面才是block需要的参数，无selector
    NSString *originIMPResult = originFunc(block, @"OriginIMP", 100);
    NSLog(@"原始IMP执行结果：====> %@", originIMPResult);
    
    NSString *codingType = ZD_ReduceBlockSignatureCodingType(ZD_BlockSignatureTypes(block));
    NSLog(@"********* : %@", codingType);
}

@end
