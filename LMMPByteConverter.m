//
//  LMMPByteConverter.m
//  
//
//  Created by jeremy on 2023/9/28.
//

#import "LMMPByteConverter.h"

@implementation LMMPByteConverter

///nsdata to hexstring
- (NSString *)hexStringFromeData:(NSData*)data{
  if (!data || [data length] == 0) {
    return @"";
  }
  NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
  
  unsigned char *dataBytes = (unsigned char*)data.bytes;
  NSUInteger length = data.length;
  for (int i = 0; i<length; i++) {
    NSString* hexStr = [NSString stringWithFormat:@"%02x",dataBytes[i]];
    [string appendString:hexStr];
  }
  return string;
}

//十六进制数据字符串转换为data
+ (NSData *)byteHexStringToData:(NSString *)value {
    if (!value || [value length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([value length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [value length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [value substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
@end
