//
//  MHAKeychainController.h
//  Med
//
//  Created by Med on 01/06/15.
//  Copyright (c) 2015 Med. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHAKeychainWrapper.h"


@interface MHAKeychainController : NSObject {

@private
    MHAKeychainWrapper *_keychainWrapper;
    NSMutableDictionary *_valueBuffer;
}

+ (MHAKeychainController *)sharedController;
- (MHAKeychainWrapper *) keychain;

- (id)values;
- (NSString*)stringForKey:(NSString*)key;
- (BOOL)storeString:(NSString*)string forKey:(NSString*)key;
- (BOOL)storeString:(NSString*)string forKey:(NSString*)key accessibleAttribute:(CFTypeRef)accessibleAttribute;
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath accessibleAttribute:(CFTypeRef)accessibleAttribute;
@end

