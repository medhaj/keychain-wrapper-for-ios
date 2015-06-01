Keychain wrapper for iOS 
==============================

This repository hosts a keychain wrapper for iOS apps.

##### Import the wrapper

To use the keychain wrapper, you need to import its header file. In your code, add the following line to import it


```objective-c
	
	#import "MHAKeychainWrapper.h"
	
```

Once imported you can start using it.

##### Store strings or objects

To store objects/strings in the keychain, use the folowing methods

```objective-c
	
	- (void)setObject:(NSString *)value forKey:(NSString *)key;
	- (void)setObject:(NSString *)value forKey:(NSString *)key 
					accessibleAttribute:(CFTypeRef)accessibleAttribute;
	
```

Example

```objective-c
	
	
	MHAKeychainWrapper *keychain = [MHAKeychainWrapper sharedKeychain];
    [keychain setString:emailTextField.text forKey:@"com.med.email-address"];
	
```

##### Read strings or objects

To get objects/strings from the keychain, use the following methods

 
 ```objective-c
	
	- (id)objectForKey:(NSString *)key;
	- (NSString *)stringForKey:(NSString *)key;
	
```

 Example

```objective-c
	
	MHAKeychainWrapper *keychain = [MHAKeychainWrapper sharedKeychain];
    NSString *email = [keychain stringForKey:@"com.med.email-address"];
	
```

##### Remove stored objects

To read objects/strings from the keychain, use the following methods

 
 ```objective-c
	
	- (void)removeObjectForKey:(NSString *)key;
	
```

 Example

```objective-c
	
	MHAKeychainWrapper *keychain = [MHAKeychainWrapper sharedKeychain];
	[keychain removeObjectForKey:@"com.med.email-address"];
	
```

##### Generate UDID

Using the keychain wrapper you can generate and store udid-like id.

 ```objective-c
	
	- (NSString *)udidForKey:(NSString *)key;
	
```

The key chain will return the stored udid if found or it will generate a new udid and store it.

Example 

```objective-c
	
	MHAKeychainWrapper *keychain = [MHAKeychainWrapper sharedKeychain];
	NSString *UDID = [keychain udidForKey:@"com.med.udid"];
	//use the id
	
```