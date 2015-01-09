//
//  ViewController.m
//  历遍数据
//
//  Created by admin on 2014/12/29.
//  Copyright (c) 2014年 Eveian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(strong, nonatomic) NSArray* arrayDataSource;
@property(strong, nonatomic) NSDictionary* dictionaryDataSource;
@property(weak, nonatomic) IBOutlet UITextView* messageView;
@property(strong, nonatomic) NSMutableString* messageString;
@end

static NSString* const kTempString = @"abcMN123OPdQRefg4hABCijSTUklm5VWXnoDEF67pqYrGHIstJ7KL8uXv9wx0yz";
#define OUT(A, ...) [self addMessage:[NSString stringWithFormat:A, ## __VA_ARGS__]]

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.messageString = [NSMutableString new];
    [self testArrayFunction];
    [self testDictionaryFunction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ---------------------------------------------------------------------------------------------------------------
#pragma mark - setup data source
// ---------------------------------------------------------------------------------------------------------------
-(NSArray*) arrayDataSource{
    if (!_arrayDataSource) {
        NSMutableArray* items = [@[]mutableCopy];
        for (int i = 0; i< 1000; ++i) {
            [items addObject:@(i)];
        }
        _arrayDataSource = [[NSArray alloc] initWithArray:items];
    }
    return _arrayDataSource;
}

-(NSDictionary*) dictionaryDataSource{
    if (!_dictionaryDataSource) {
        NSMutableDictionary* dic = [@{}mutableCopy];
        for (int i = 0; i< 1000; ++i) {
            int stringLen = arc4random()%[kTempString length]+1;
            NSMutableString *randomString = [NSMutableString stringWithCapacity:stringLen];
            for (int i=0; i<stringLen; i++) {
                [randomString appendFormat: @"%C", [kTempString characterAtIndex: arc4random() % [kTempString length]]];
            }
            [dic setObject:randomString forKey:@(i)];
        }
        _dictionaryDataSource = [[NSDictionary alloc] initWithDictionary:dic];
    }
    return _dictionaryDataSource;
}

-(void) addMessage:(NSString*)string{
    [self.messageString appendString:string];
    self.messageView.text =self.messageString;
}

// ---------------------------------------------------------------------------------------------------------------
#pragma mark - Array
// ---------------------------------------------------------------------------------------------------------------
-(void) testArrayFunction{
    NSNumber* findIndex = @(arc4random() %1000+1);
    NSTimeInterval lastTime;
    
    OUT(@"======NSArray 数据历遍===========\n");
    OUT(@"方法1: 利用 Statement找到资料(%@)\n",findIndex);
    lastTime = [[NSDate date] timeIntervalSince1970];
    OUT(@"找到 %lu,共花了 %f\n",(unsigned long)[self findArrayIndexDataForStatement:findIndex],[[NSDate date] timeIntervalSince1970]-lastTime);
    
    OUT(@"--------------------\n");
    OUT(@"方法2: 利用 For in 找到资料(%@)\n",findIndex);
    lastTime = [[NSDate date] timeIntervalSince1970];
    OUT(@"找到 %lu,共花了 %f\n",(unsigned long)[self findArrayIndexDataForIn:findIndex],[[NSDate date] timeIntervalSince1970]-lastTime);
    
    OUT(@"--------------------");
    OUT(@"方法3-1: 利用 Block 正向 找到资料(%@)\n",findIndex);
    lastTime = [[NSDate date] timeIntervalSince1970];
    OUT(@"找到 %lu,共花了 %f\n",(unsigned long)[self findArrayIndexDataBlock:findIndex],[[NSDate date] timeIntervalSince1970]-lastTime);
    
    OUT(@"--------------------\n");
    OUT(@"方法3-2: 利用 Block 反向 找到资料(%@)\n",findIndex);
    lastTime = [[NSDate date] timeIntervalSince1970];
    OUT(@"找到 %lu,共花了 %f\n",(unsigned long)[self findArrayIndexDataBlockReverse:findIndex],[[NSDate date] timeIntervalSince1970]-lastTime);
    
    OUT(@"--------------------\n");
    OUT(@"方法4-1: 利用 Enumerator 正向 找到资料(%@)\n",findIndex);
    lastTime = [[NSDate date] timeIntervalSince1970];
    OUT(@"找到 %lu,共花了 %f\n",(unsigned long)[self findArrayIndexDataEnumerator:findIndex],[[NSDate date] timeIntervalSince1970]-lastTime);
    
    OUT(@"--------------------\n");
    OUT(@"方法4-2: 利用 Enumerator 反向 找到资料(%@)\n",findIndex);
    lastTime = [[NSDate date] timeIntervalSince1970];
    OUT(@"找到 %lu,共花了 %f\n",(unsigned long)[self findArrayIndexDataReverseEnumerator:findIndex],[[NSDate date] timeIntervalSince1970]-lastTime);
    OUT(@"=============================\n\n");
}

-(NSUInteger) findArrayIndexDataForStatement:(NSNumber*)value{
    for (int i = 0; i < [self.arrayDataSource count]; ++i) {
        NSNumber* number = [self.arrayDataSource objectAtIndex:i];
        if ([number isEqualToNumber:value]) {
            return i;
        }
    }
    return -1;
}

-(NSUInteger) findArrayIndexDataForIn:(NSNumber*)value{
    for (NSNumber* number in self.arrayDataSource){
        if ([number isEqualToNumber:value]) {
            return [self.arrayDataSource indexOfObject:number];
        }
    }
    return -1;
}

-(NSUInteger) findArrayIndexDataBlock:(NSNumber*)value{
    __block NSUInteger index = -1;
    [self.arrayDataSource enumerateObjectsUsingBlock:^(NSNumber* number, NSUInteger idx, BOOL *stop) {
        if ([number isEqualToNumber:value]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

-(NSUInteger) findArrayIndexDataBlockReverse:(NSNumber*)value{
    __block NSUInteger index = -1;
    [self.arrayDataSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSNumber* number, NSUInteger idx, BOOL *stop) {
        if ([number isEqualToNumber:value]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

-(NSUInteger) findArrayIndexDataEnumerator:(NSNumber*)value{
    NSEnumerator* enumerator = [self.arrayDataSource objectEnumerator];
    NSNumber* number;
    while (number =[enumerator nextObject]) {
        if ([number isEqualToNumber:value]) {
            return [self.arrayDataSource indexOfObject:number];
        }
    }
    return -1;
}

-(NSUInteger) findArrayIndexDataReverseEnumerator:(NSNumber*)value{
    NSEnumerator* enumerator = [self.arrayDataSource reverseObjectEnumerator];
    NSNumber* number;
    while (number =[enumerator nextObject]) {
        if ([number isEqualToNumber:value]) {
            return [self.arrayDataSource indexOfObject:number];
        }
    }
    return -1;
}
// ---------------------------------------------------------------------------------------------------------------
#pragma mark - NSDictionary
// ---------------------------------------------------------------------------------------------------------------
-(void) testDictionaryFunction{
    NSNumber* findKey = @(arc4random() %1000+1);
    NSTimeInterval lastTime;
    OUT(@"======NSDictionary 数据历遍===========\n");
    OUT(@"方法1: 利用 Statement 找到资料(%@)\n",findKey);
    lastTime = [[NSDate date] timeIntervalSince1970];
    OUT(@"找key :%@ value:%@,共花了 %f\n",findKey,[self findDictionaryValueForStatement:findKey],[[NSDate date] timeIntervalSince1970]-lastTime);
    OUT(@"--------------------\n");
    OUT(@"方法2: 利用 For in 找到资料(%@)\n",findKey);
    lastTime = [[NSDate date] timeIntervalSince1970];
    OUT(@"找key :%@ value:%@,共花了 %f\n",findKey,[self findDictionaryValueForIn:findKey],[[NSDate date] timeIntervalSince1970]-lastTime);
    OUT(@"--------------------\n");
    OUT(@"方法3: 利用 Block 找到资料(%@)\n",findKey);
    lastTime = [[NSDate date] timeIntervalSince1970];
    OUT(@"找key :%@ value:%@,共花了 %f\n",findKey,[self findDictionaryValueBlock:findKey],[[NSDate date] timeIntervalSince1970]-lastTime);
    OUT(@"--------------------\n");
    OUT(@"方法4: 利用 Enumerator 找到资料(%@)\n",findKey);
    lastTime = [[NSDate date] timeIntervalSince1970];
    OUT(@"找key :%@ value:%@,共花了 %f\n",findKey,[self findDictionaryValueEnumerator:findKey],[[NSDate date] timeIntervalSince1970]-lastTime);
    OUT(@"=============================\n\n");
}

-(NSString*) findDictionaryValueForStatement:(NSNumber*)key{
    NSArray* allKeys = [self.dictionaryDataSource allKeys];
    for (int i =0; i< [allKeys count]; ++i) {
        NSNumber* keyNumber = [allKeys objectAtIndex:i];
        if ([keyNumber isEqualToNumber:key]) {
            return [self.dictionaryDataSource objectForKey:keyNumber];
        }
    }
    return nil;
}

-(NSString*) findDictionaryValueForIn:(NSNumber*)key{
    for (NSNumber* keyNumber in [self.dictionaryDataSource allKeys]){
        if ([keyNumber isEqualToNumber:key]) {
            return [self.dictionaryDataSource objectForKey:keyNumber];
        }
    }
    return nil;
}

-(NSString*) findDictionaryValueBlock:(NSNumber*)key{
    __block NSString* dicValue = nil;
    [self.dictionaryDataSource enumerateKeysAndObjectsUsingBlock:^(NSNumber* keyNumber, NSString* value, BOOL *stop) {
        if ([keyNumber isEqualToNumber:key]) {
            dicValue = value;
            *stop = YES;
        }
    }];
    return dicValue;
}

-(NSString*) findDictionaryValueEnumerator:(NSNumber*)key{
    NSEnumerator* enumerator = [self.dictionaryDataSource keyEnumerator];
    
    NSNumber* keyNumber;
    while (keyNumber = [enumerator nextObject]) {
        if ([keyNumber isEqualToNumber:key]) {
            return [self.dictionaryDataSource objectForKey:keyNumber];
        }
    }
    return nil;
}
@end
