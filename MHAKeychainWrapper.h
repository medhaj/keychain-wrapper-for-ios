//
//  MHAKeychainWrapper.h
//  Med
//
//  Created by Med on 01/06/15.
//  Copyright (c) 2015 Med. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MHAKeychainWrapper : NSObject


+ (MHAKeychainWrapper *)sharedKeychain;

- (id)objectForKey:(NSString *)defaultName;
- (NSString *)stringForKey:(NSString *)defaultName;

- (void)setObject:(NSString *)value forKey:(NSString *)key;
- (void)setString:(NSString *)value forKey:(NSString *)key;

- (void)setObject:(NSString *)value forKey:(NSString *)key accessibleAttribute:(CFTypeRef)accessibleAttribute;
- (void)setString:(NSString *)value forKey:(NSString *)key accessibleAttribute:(CFTypeRef)accessibleAttribute;

- (void)removeObjectForKey:(NSString *)key;

- (NSString *)udidForKey:(NSString *)key;
@end
