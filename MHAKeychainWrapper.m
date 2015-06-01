//
//  MHAKeychainWrapper.m
//  Med
//
//  Created by Med on 01/06/15.
//  Copyright (c) 2015 Med. All rights reserved.
//

#import "MHAKeychainWrapper.h"
#import "MHAKeychainController.h"


@implementation MHAKeychainWrapper

+ (MHAKeychainWrapper *)sharedKeychain {
	return [[MHAKeychainController sharedController] keychain];
}

- (id)objectForKey:(NSString *)key {
    return [[MHAKeychainController sharedController] valueForKeyPath:[NSString stringWithFormat:@"values.%@", key]];
}

- (void)setObject:(NSString *)value forKey:(NSString *)key {
    [[MHAKeychainController sharedController] setValue:value forKeyPath:[NSString stringWithFormat:@"values.%@", key]];
}

- (void)setObject:(NSString *)value forKey:(NSString *)key accessibleAttribute:(CFTypeRef)accessibleAttribute {
    [[MHAKeychainController sharedController] setValue:value forKeyPath:[NSString stringWithFormat:@"values.%@", key] accessibleAttribute:accessibleAttribute];
}

- (void)setString:(NSString *)value forKey:(NSString *)key {
    [[MHAKeychainController sharedController] setValue:value forKeyPath:[NSString stringWithFormat:@"values.%@", key]];
}

- (void)setString:(NSString *)value forKey:(NSString *)key accessibleAttribute:(CFTypeRef)accessibleAttribute {
    [[MHAKeychainController sharedController] setValue:value forKeyPath:[NSString stringWithFormat:@"values.%@", key] accessibleAttribute:accessibleAttribute];
}

- (void)removeObjectForKey:(NSString *)key {
    [[MHAKeychainController sharedController] setValue:nil forKeyPath:[NSString stringWithFormat:@"values.%@", key]];
}

- (NSString *)stringForKey:(NSString *)key {
    return (NSString *) [self objectForKey:key];
}


#pragma mark - Utils
- (NSString *)udidForKey:(NSString *)key {
    if (!key || [key isEqualToString:@""]) {
        return nil;
    }
    
    
    NSString *deviceId = nil;
    id uuid = [self objectForKey:key];
    if (uuid) {
        deviceId = (NSString *)uuid;
    }
    else {
        CFStringRef cfUuid = CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
        deviceId = (__bridge NSString *)cfUuid;
        [self setObject:deviceId forKey:key];
    }
    
    return deviceId;
}
@end
