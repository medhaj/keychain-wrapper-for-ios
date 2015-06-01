//
//  MHAKeychainController.m
//  Med
//
//  Created by Med on 01/06/15.
//  Copyright (c) 2015 Med. All rights reserved.
//

#import "MHAKeychainController.h"
#import <Security/Security.h>

static MHAKeychainController *sharedController = nil;
@implementation MHAKeychainController

#pragma mark - Keychain Access
- (NSString*)serviceName {
	return [[NSBundle mainBundle] bundleIdentifier];
}

- (NSString*)stringForKey:(NSString*)key {
	OSStatus status;
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:(id)kCFBooleanTrue, kSecReturnData,
                           kSecClassGenericPassword, kSecClass,
                           key, kSecAttrAccount,
                           [self serviceName], kSecAttrService,
                           nil];
	
    CFDataRef stringData = NULL;
    status = SecItemCopyMatching((__bridge  CFDictionaryRef)query, (CFTypeRef*)&stringData);

    if(status) return nil;
	   
    NSString *string = [[NSString alloc] initWithData:(__bridge  id)stringData encoding:NSUTF8StringEncoding];
    CFRelease(stringData);
	return string;	
}


- (BOOL)storeString:(NSString*)string forKey:(NSString*)key {
    return [self storeString:string forKey:key accessibleAttribute:kSecAttrAccessibleWhenUnlocked];
}

- (BOOL)storeString:(NSString*)string forKey:(NSString*)key accessibleAttribute:(CFTypeRef)accessibleAttribute {
	if (!string) {
        NSDictionary *spec = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge  id)kSecClassGenericPassword, kSecClass,
                              key, kSecAttrAccount,[self serviceName], kSecAttrService, nil];
        
        return !SecItemDelete((__bridge  CFDictionaryRef)spec);
    }
    else {
        NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *spec = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge  id)kSecClassGenericPassword, kSecClass,
                              key, kSecAttrAccount,[self serviceName], kSecAttrService, nil];
        
        if(!string) {
            return !SecItemDelete((__bridge  CFDictionaryRef)spec);
        }
        else if([self stringForKey:key]) {
            NSDictionary *update = @{
                                     (__bridge id)kSecAttrAccessible:(__bridge  id)accessibleAttribute,
                                     (__bridge id)kSecValueData:stringData
                                     };
            
            
            return !SecItemUpdate((__bridge CFDictionaryRef)spec, (__bridge  CFDictionaryRef)update);
        }
        else{
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:spec];
            data[(__bridge  id)kSecValueData] = stringData;
            data[(__bridge id)kSecAttrAccessible] =(__bridge id)accessibleAttribute;
            return !SecItemAdd((__bridge CFDictionaryRef)data, NULL);
        }
    }
}

#pragma mark - Singleton accessors
+ (MHAKeychainController *)sharedController {
    static dispatch_once_t onceQueue;

    dispatch_once(&onceQueue, ^{
        sharedController = [[self alloc] init];
    });

	return sharedController;
}

- (MHAKeychainWrapper *)keychain {
    if (!_keychainWrapper) {
        _keychainWrapper = [[MHAKeychainWrapper alloc] init];
    }
    
    if (!_valueBuffer) {
        _valueBuffer = [[NSMutableDictionary alloc] init];
    }
    
    return _keychainWrapper;
}

-(id) values {
    if (!_valueBuffer) {
        _valueBuffer = [[NSMutableDictionary alloc] init];
    }
    
    return _valueBuffer;
}

#pragma mark - Process methods
- (id)valueForKeyPath:(NSString *)keyPath {
    NSRange firstSeven=NSMakeRange(0, 7);
    if (NSEqualRanges([keyPath rangeOfString:@"values."],firstSeven)) {
        NSString *subKeyPath = [keyPath stringByReplacingCharactersInRange:firstSeven withString:@""];
        NSString *retrievedString = [self stringForKey:subKeyPath];
        if (retrievedString) {
            if (![_valueBuffer objectForKey:subKeyPath] || ![[_valueBuffer objectForKey:subKeyPath] isEqualToString:retrievedString]) {
                [_valueBuffer setValue:retrievedString forKey:subKeyPath];
            }
        }
    }
    
    return [super valueForKeyPath:keyPath];
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath {
    [self setValue:value forKeyPath:keyPath accessibleAttribute:kSecAttrAccessibleWhenUnlocked];
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath accessibleAttribute:(CFTypeRef)accessibleAttribute {
    NSRange firstSeven=NSMakeRange(0, 7);
    if (NSEqualRanges([keyPath rangeOfString:@"values."],firstSeven)) {
        NSString *subKeyPath = [keyPath stringByReplacingCharactersInRange:firstSeven withString:@""];
        NSString *retrievedString = [self stringForKey:subKeyPath];
        if (retrievedString) {
            if (![value isEqualToString:retrievedString]) {
                [self storeString:value forKey:subKeyPath accessibleAttribute:accessibleAttribute];
            }
            
            if (![_valueBuffer objectForKey:subKeyPath] || ![[_valueBuffer objectForKey:subKeyPath] isEqualToString:value]) {
                [_valueBuffer setValue:value forKey:subKeyPath ];
            }
        } else {
            [self storeString:value forKey:subKeyPath accessibleAttribute:accessibleAttribute];
            [_valueBuffer setValue:value forKey:subKeyPath];
        }
    }
    
    [super setValue:value forKeyPath:keyPath];
}

@end
