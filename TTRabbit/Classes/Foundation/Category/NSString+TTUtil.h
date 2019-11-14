//
//  NSString+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/18.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 解析字符串。一定返回一个字符串
 */
static inline NSString * TTSureString(NSString *src) {
    if ([src isKindOfClass:[NSString class]]) { return src; }
    if ([src isKindOfClass:[NSNumber class]]) { return [((NSNumber *)src) stringValue]; }
    return @"";
}

/*
 字符串是否有值。
 */
static inline BOOL TTStringIsInvalid(NSString *src) {
    if (![src isKindOfClass:[NSString class]]) { return YES; }
    if (!src.length) { return YES; }
    static NSArray *nilValues;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nilValues = @[@"NIL", @"Nil", @"nil", @"NULL", @"Null", @"null", @"(NULL)", @"(Null)", @"(null)", @"<NULL>", @"<Null>", @"<null>"];
    });
    return [nilValues containsObject:src];
}

@interface NSString (TTUtil)

@property (nonatomic, assign, readonly) NSRange tt_fullRange;
@property (nonatomic, assign, readonly) NSRange tt_firstCharRange;
@property (nonatomic, assign, readonly) NSRange tt_lastCharRange;

/**
 带html标签的文本转富文本
 */
- (void)tt_convertHtmlStringToNSAttributedString:(void(^)(NSAttributedString *))block;


/**
 如果没有这个前缀，就添加前缀
 @param prefix 前缀
 */
- (NSString *)tt_stringByPrependingPrefixIfNeeded:(NSString *)prefix;

/**
 如果没有这个后缀，就添加后缀
 @param suffix 后缀
 */
- (NSString *)tt_stringByAppendingSuffixIfNeeded:(NSString *)suffix;

/**
 如果有这个前缀，就删掉
 @param prefix 前缀
 */
- (NSString *)tt_stringByDeletingPrefix:(NSString *)prefix;

/**
 如果有这个后缀就删掉
 @param suffix 后缀
 */
- (NSString *)tt_stringByDeletingSuffix:(NSString *)suffix;

/**
 删除所有的空格
 */
- (NSString *)tt_stringByTrimmingWhitespaceThroughout;

/**
 首字母大写
 */
- (NSString *)tt_stringByCapitalizingFirstChar;

#pragma mark - Truncating

/**
 截取字符串，最后以'...'结束
 
 @param width 最大宽度
 @param font 字体
 @return 截取后的字符串
 */
- (NSString *)tt_stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font;

/**
 截取字符串，最后以'...'结束
 
 @param size 最大范围
 @param attributes 富文本属性，UIFont必传
 @param lastLineTailInset 最后一行缩进，正值
 @return 截取后的字符串
 */
- (NSString *)tt_stringByTruncatingToSize:(CGSize)size
                       withTextAttributes:(NSDictionary *)attributes
                        lastLineTailInset:(CGFloat)lastLineTailInset;

#pragma mark - URL

/**
 通过url格式添加key和value
 */
- (NSString *)tt_urlStringByAppendingKey:(NSString *)key value:(NSString *)value;

/**
 通过url格式添加参数（keysAndValues）
 */
- (NSString *)tt_urlStringByAppendingQueries:(NSDictionary *)queries;

/**
 把参数urlencode
 */
- (NSString *)tt_urlStringByQueryEncode;

/**
 获取url参数
 */
- (NSDictionary *)tt_urlQueries;

#pragma mark - Validating

/**
 是否是中文
 */
- (BOOL)tt_isChinese;

/**
 是否是有效的邮箱
 */
- (BOOL)tt_isValidEmail;

/**
 是否是有效的url地址
 */
- (BOOL)tt_isValidHttpURL;

/**
 收否是有效的手机号，弱验证，只验证开头两位和总长度是11位
 */
- (BOOL)tt_isValidPhoneNumber;

/**
 是否是纯数字
 */
- (BOOL)tt_isPureInteger;

/**
 是否是小数
 */
- (BOOL)tt_isFloat;

/**
 是否是有效的微信号
 */
- (BOOL)tt_isValidWXNumber;

/**
 是否是有效的QQ号
 */
- (BOOL)tt_isValidQQ;

#pragma mark - Formatter

/**
 把字节数转换为文件大小的描述，例如30.9 MB
 */
+ (NSString *)tt_fileSizeStringWithByteCount:(long long)byteCount;

/**
 把剩余时间转换为倒计时格式的字符串，例如1:03:54
 */
+ (NSString *)tt_countdownStringWithInteval:(NSTimeInterval)interval;

/**
 把浮点数转换为字符串，不会丢失精度
 */
+ (NSString *)tt_decimalFormatedStringWithNumber:(CGFloat)number;

@end

NS_ASSUME_NONNULL_END
