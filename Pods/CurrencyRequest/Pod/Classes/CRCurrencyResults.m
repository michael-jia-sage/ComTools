//
//  CurrencyResults.m
//  Pods
//
//  Created by Sam Kaufman on 9/8/15.
//
//

#import <objc/runtime.h>
@import Foundation;
#import "CRCurrencyResults.h"


@interface CRCurrencyResults () <NSXMLParserDelegate>

@end


@implementation CRCurrencyResults {
    NSDictionary *_pkg;
    NSMutableDictionary *_workingToRet;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSGenericException
                                   reason:@"init unimplemented"
                                 userInfo:nil];
}

- (instancetype)_initWithXMLData:(NSData *)data {
    self = [super init];
    if (self) {
        assert(!_workingToRet);
        
        _workingToRet = [NSMutableDictionary dictionary];
        NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithData:data];
        xmlparser.delegate = self;
        BOOL success = [xmlparser parse];
        
        if (!success) {
            NSLog(@"Error parsing currency data: %@", xmlparser.parserError);
            return nil;
        }
        
        if (![_workingToRet count]) {
            // if nothing was found, that's an error
            NSLog(@"Error parsing currency data; ended up with zero rates");
            return nil;
        }
        
        // Return immutable copy
        _pkg = [NSDictionary dictionaryWithDictionary:_workingToRet];
        _workingToRet = nil;
    }
    return self;
}

- (double)_rateForCurrency:(NSString *)currency {
    
    if ([currency isEqualToString:@"USD"]) {
        return 1.0;
    }
    
    double usdAgainstEuro = [_pkg[@"USD"] doubleValue];
    if ([currency isEqualToString:@"EUR"]) {
        return 1.0 / usdAgainstEuro;
    }
    
    NSString *strResult = _pkg[currency];
    if (!strResult) {
        NSString *reason = [NSString stringWithFormat:@"unknown currency: %@", currency];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    
    //
    // TODO: Translate through USD base
    //
    
    double rateAgainstEuro = [strResult doubleValue];
    return rateAgainstEuro / usdAgainstEuro;
}

+ (NSString *)_nameForCurrency:(NSString *)currency {
    if ([currency isEqualToString:@"CAD"])
        return @"Canadian Dollar";
    else if ([currency isEqualToString:@"CNY"])
        return @"China Yuan RMB";
    else if ([currency isEqualToString:@"EUR"])
        return @"Euro";
    else if ([currency isEqualToString:@"JPY"])
        return @"Japan Yen";
    else if ([currency isEqualToString:@"BGN"])
        return @"Bulgaria Lev";
    else if ([currency isEqualToString:@"CZK"])
        return @"Czech Republic Koruna";
    else if ([currency isEqualToString:@"DKK"])
        return @"Denmark Krone";
    else if ([currency isEqualToString:@"GBP"])
        return @"United Kingdom Pound";
    else if ([currency isEqualToString:@"HUF"])
        return @"Hungary Forint";
    else if ([currency isEqualToString:@"PLN"])
        return @"Poland Zloty";
    else if ([currency isEqualToString:@"RON"])
        return @"Romania New Leu";
    else if ([currency isEqualToString:@"SEK"])
        return @"Sweden Krona";
    else if ([currency isEqualToString:@"CHF"])
        return @"Switzerland Franc";
    else if ([currency isEqualToString:@"INR"])
        return @"India Rupee";
    else if ([currency isEqualToString:@"MXN"])
        return @"Mexico Peso";
    else
        return @"US Dollar";
}

# pragma mark - Dynamically resolved public methods

@dynamic USD;
@dynamic CAD;
@dynamic CNY;
@dynamic EUR;
@dynamic JPY;
@dynamic BGN;
@dynamic CZK;
@dynamic DKK;
@dynamic GBP;
@dynamic HUF;
@dynamic PLN;
@dynamic RON;
@dynamic SEK;
@dynamic CHF;
@dynamic INR;
@dynamic MXN;

- (id)valueForUndefinedKey:(NSString *)key {
    
    if ([[[self class] supportedCurrencies] containsObject:key]) {
        return @([self _rateForCurrency:key]);
    }
    
    return [super valueForUndefinedKey:key];
}

+ (BOOL)resolveInstanceMethod:(SEL)aSel {
    
    NSString *selName = NSStringFromSelector(aSel);
    
    if ([[[self class] supportedCurrencies] containsObject:selName]) {
        const char *types = [[NSString stringWithFormat: @"%s%s%s%s", @encode(double), @encode(id), @encode(SEL), @encode(NSString *)] UTF8String];
        class_addMethod(self, aSel, (IMP)rateGetter, types);
        return YES;
    }
    return [super resolveInstanceMethod:aSel];
}

double rateGetter(id self, SEL _cmd) {
    NSString *selName = NSStringFromSelector(_cmd);
    return [self _rateForCurrency:selName];
}

- (NSString *)description {
    NSMutableString *buf = [NSMutableString new];
    [buf appendFormat:@"<%@> {\n", [self class]];
    for (NSString *cur in [CRCurrencyResults supportedCurrencies]) {
        [buf appendFormat:@"\t%@ = %.4f,\n", cur, [self _rateForCurrency:cur]];
    }
    [buf appendString:@"}"];
    return buf;
}


# pragma mark - Currencies

+ (NSSet *)supportedCurrencies {
    return [NSSet setWithObjects:@"USD", @"CAD", @"CNY", @"EUR", @"JPY", @"BGN", @"CZK", @"DKK",
            @"GBP", @"HUF", @"PLN", @"RON", @"SEK", @"CHF", @"INR", @"MXN", nil];
}


# pragma mark - NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    assert(_workingToRet);
    if (attributeDict[@"currency"] && attributeDict[@"rate"]) {
        _workingToRet[attributeDict[@"currency"]] = attributeDict[@"rate"];
    }
}

@end
