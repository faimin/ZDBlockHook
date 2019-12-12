//
//  ZDBlock.h
//  ZDToolKit
//
//  Created by Zero.D.Saber on 2017/11/14.
//

#import <Foundation/Foundation.h>

#pragma mark - Block Define
#pragma mark -

// http://clang.llvm.org/docs/Block-ABI-Apple.html#high-level
// https://opensource.apple.com/source/libclosure/libclosure-67/Block_private.h.auto.html
// Values for Block_layout->flags to describe block objects
typedef NS_OPTIONS(NSUInteger, ZDBlockDescriptionFlags) {
    BLOCK_DEALLOCATING =      (0x0001),  // runtime
    BLOCK_REFCOUNT_MASK =     (0xfffe),  // runtime
    BLOCK_NEEDS_FREE =        (1 << 24), // runtime
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25), // compiler
    BLOCK_HAS_CTOR =          (1 << 26), // compiler: helpers have C++ code
    BLOCK_IS_GC =             (1 << 27), // runtime
    BLOCK_IS_GLOBAL =         (1 << 28), // compiler
    BLOCK_USE_STRET =         (1 << 29), // compiler: undefined if !BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE  =    (1 << 30), // compiler
    BLOCK_HAS_EXTENDED_LAYOUT=(1 << 31)  // compiler
};

// revised new layout

#define BLOCK_DESCRIPTOR_1 1
struct ZDBlock_descriptor_1 {
    uintptr_t reserved;
    uintptr_t size;
};

#define BLOCK_DESCRIPTOR_2 1
struct ZDBlock_descriptor_2 {
    // requires BLOCK_HAS_COPY_DISPOSE
    void (*copy)(void *dst, const void *src);
    void (*dispose)(const void *);
};

#define BLOCK_DESCRIPTOR_3 1
struct ZDBlock_descriptor_3 {
    // requires BLOCK_HAS_SIGNATURE
    const char *signature;
    const char *layout;     // contents depend on BLOCK_HAS_EXTENDED_LAYOUT
};

struct ZDBlock_layout {
    void *isa;  // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    volatile int flags; // contains ref count
    int reserved;
    void (*invoke)(void *, ...);
    struct Block_descriptor_1 *descriptor;
    // imported variables
};

//################################################################
#pragma mark - --------------------- 方案1 ==> MessageForward ------------------------

typedef void * ZDBlockIMP;

/// 获取block的typeCoding
FOUNDATION_EXPORT const char *ZD_BlockSignatureTypes(id block);

/// 获取block的函数指针(这种方式获取的函数指针,当调用执行时,第一参数为block自己,后面才是block的参数类型)
FOUNDATION_EXPORT ZDBlockIMP ZD_BlockInvokeIMP(id block);

/// 获取msg_forward函数指针
FOUNDATION_EXPORT IMP ZD_MsgForwardIMP(const char *methodTypes);

/// 判断当前函数指针是否指向的msg_froward
FOUNDATION_EXPORT BOOL ZD_IsMsgForwardIMP(IMP imp);

/// 简化block方法签名
FOUNDATION_EXPORT NSString *ZD_ReduceBlockSignatureCodingType(const char *signatureCodingType);

/// 打印block参数(消息转发实现)
/// @return 返回一个新的block
/// @note IMP的第一个参数是block自己，剩余的参数是参数列表中的参数，不存在selector
FOUNDATION_EXPORT id ZD_HookBlock(id block);


//*************************************************************
#pragma mark - --------------------- 方案2 ==> Libffi ---------------------
#pragma mark -
//*************************************************************

#define USE_LIBFFI (__has_include(<ffi.h>) || __has_include("ffi.h"))

#if USE_LIBFFI
/// 利用libffi实现
@interface ZDFfiBlockHook : NSObject

+ (instancetype)hookBlock:(id)block;

@end
#endif


//*************************************************************
#pragma mark - ---------------------- 整合 -----------------------
#pragma mark -

typedef NS_ENUM(NSInteger, ZDHookWay) {
    ZDHookWay_MsgForward = 0,
    ZDHookWay_Libffi     = 1,
};

@interface NSObject (ZDHookBlock)

- (void)zd_hookBlock:(id *)block hookWay:(ZDHookWay)hookWay;

@end

//*************************************************************
