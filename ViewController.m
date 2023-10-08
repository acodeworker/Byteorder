//
//  ViewController.m
//  LoginDemo
//
//  Created by jeremy on 2022/9/15.
//  Copyright © 2022 aqara. All rights reserved.
//

#import "ViewController.h"
#import <TinyCborObjc/NSObject+DSCborEncoding.h>
#import <TinyCborObjc/NSData+DSCborDecoding.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <LMFramework/LMFramework.h>
#import <LMDeviceAccessNet/LMDeviceAccessNet.h>
#import "LoginDemo-Swift.h"
#import <Masonry/Masonry.h>

//#import <LMDashboard/LMDashboard.h>

@interface ViewController ()<UITableViewDataSource,UITextViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSArray *dataSource;

@property(nonatomic, assign)NSInteger num;

@end

@implementation ViewController

/*
- (void)viewDidLoad {
//  NSString* str = @"12324";
//  NSDictionary *dictionary = @{@"name":@"jame"};
//  NSData *cborData = [dictionary ds_cborEncodedObject];
//  NSLog(@"%@",cborData);
//
//  NSError *error = nil;
//  id decoded = [cborData ds_decodeCborError:&error];
//  NSLog(@"%@",decoded);
  self.view.backgroundColor = [UIColor whiteColor];
  self.title = @"点击屏幕，开始扫描";
  DDLogDebug(@"%s",__func__);
  self.definesPresentationContext = YES;
//  self.hidesBottomBarWhenPushed = YES;
//  [NSThread sleepForTimeInterval:4];
  
  UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 200, 44)];
  textField.placeholder = @"请输入要采集的数据个数";
//  textField.text = @"2";
  textField.delegate = self;
  [self.view addSubview:textField];
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  
  int number = 0x01030417;
  char* arr = (char*)&number;
  NSLog(@"%x,%x,%x,%x",arr[0],arr[1],arr[2],arr[3]);
  
  CFByteOrder order = CFByteOrderGetCurrent();
  NSLog(@"当前大小端模式:%ld",(long)order);
  
  int16_t num = 15;
  int16_t swap_num = CFSwapInt16(num);
  NSLog(@"CFSwapInt16-num:%x,swap_num:%x",num,swap_num);
  
  num = 15;
  swap_num = CFSwapInt16BigToHost(num);
  NSLog(@"CFSwapInt16BigToHost-num:%x,swap_num:%x",num,swap_num);

  
  
  NSData* testData = [NSData dataWithBytes:(const char[]){0x1,0x21,0x21,0x3F} length:4];
  
  NSString* resultstr = [self hexStringFromeData:testData];
  NSLog(@"---str-----%@",resultstr);
  
  NSString* hexStr = @"121213f0";
  NSData* resultData = [self byteHexStringToData:hexStr];
  NSLog(@"%@:%@",hexStr,resultData);
  return;
    //设置超链接富文本
    NSString *str1 = @"abc";
    NSString *str2 = @"fff";
    NSString *str3 = @"xtayqria";
    NSString *str = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
    NSRange range1 = [str rangeOfString:str1];
    NSRange range2 = [str rangeOfString:str2];
    NSRange range3 = [str rangeOfString:str3];
     
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.delegate = self;
    textView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    //通过设置UITextView的dataDetectorTypes属性，可以实现识别链接、电话、地址等功能，editable需要设置为NO。
  [self.view addSubview:textView];
      
  [textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(20);
    make.top.mas_equalTo(100);
    make.right.mas_equalTo(-20);
    make.height.mas_equalTo(100);
  }];
  
    NSMutableAttributedString *mastring = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22.0f]}];
    //设置不同范围的文字颜色
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range1];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range3];
 
    //设置富文本超链接属性
    // 1.必须要用前缀（firstPerson，secondPerson），随便写但是要有
    // 2.要有后面的方法，如果含有中文，url会无效，所以转码
    NSString *valueString1 = [[NSString stringWithFormat:@"firstPerson://%@", str1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *valueString3 = [[NSString stringWithFormat:@"secondPerson://%@", str3] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [mastring addAttribute:NSLinkAttributeName value:valueString1 range:range1];
    [mastring addAttribute:NSLinkAttributeName value:valueString3 range:range3];
 
    //清除超链接本身的颜色
    textView.linkTextAttributes = @{};
    //将你设置的文本信息赋值给textview
    textView.attributedText = mastring;
}

- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(NSURL*)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
 
    if ([[URL scheme] isEqualToString:@"firstPerson"]) {
        NSString *titleString = [NSString stringWithFormat:@"你点击了第一个文字:%@", [URL host]];
        [self clickLinkTitle:titleString];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"secondPerson"]) {
        NSString *titleString = [NSString stringWithFormat:@"你点击了第二个文字:%@", [URL host]];
        [self clickLinkTitle:titleString];
        return NO;
    }
 
    return YES;
 
}
 
- (void)clickLinkTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
 
}



//data转换为十六进制数据字符串
- (NSString *)hexStringFromeData:(NSData*)data{
//    NSData *data = [NSData dataWithBytes:bytes length:length];
//    if (!data || [data length] == 0) {
//        return @"";
//    }
  NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
  unsigned char *dataBytes = (unsigned char*)data.bytes;
  NSUInteger length = data.length;
  for (int i = 0; i<length; i++) {
    NSString* hexStr = [NSString stringWithFormat:@"%02x",dataBytes[i]];
    [string appendString:hexStr];
  }
  
//    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
//        unsigned char *dataBytes = (unsigned char*)bytes;
//        for (NSInteger i = 0; i < byteRange.length; i++) {
//            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
//            if ([hexStr length] == 2) {
//                [string appendString:hexStr];
//            } else {
//                [string appendFormat:@"0%@", hexStr];
//            }
//        }
//    }];
    return string;
}
 - (NSData *)byteHexStringToData:(NSString *)value {
    if (!value || [value length] == 0) {
        return nil;
    }
   NSMutableData* result = [NSMutableData data];
   if(value.length%2 != 0){//补齐
     value = [@"0" stringByAppendingString:value];
   }
   NSRange range = NSMakeRange(0, 2);
   NSInteger length = value.length;
   unsigned int temp = 0;
   unsigned int* num = &temp;
   for (int i = 0; i<length; i+=2) {
     NSString* str = [value substringWithRange:range];
     NSScanner* scanner = [[NSScanner alloc]initWithString:str];
     [scanner scanHexInt:num];
     NSData* objData = [NSData dataWithBytes:num length:1];
     [result appendData:objData];
     range.location += 2;
   }
   return result;
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  DDLogDebug(@"%s",__func__);
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  DDLogDebug(@"%s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  DDLogDebug(@"%s",__func__);

}

- (void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  DDLogDebug(@"%s",__func__);
}

@end
