//
//  BCNetworkInfoUtils.h
//  NetWorkInfoTest
//
//  Created by Heping on 9/7/16.
//  Copyright © 2016 BONC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Constant keys to obtain interface infomation
 */
extern const NSString* NetworkInterfaceNameKey;
extern const NSString* NetWorkInterfaceFlagsKey;
extern const NSString* NetworkInterfaceAddressKey;
extern const NSString* NetworkInterfaceNetMaskKey;

/**
 *  Constant keys to obtain address type
 */
extern const NSString* NetworkInterfaceAddressTypeKey;

/**
 *  Constant values for address type
 */
extern const NSString* NetworkInterfaceAddressTypeUnknown;
extern const NSString* NetworkInterfaceAddressTypeIPV4;
extern const NSString* NetworkInterfaceAddressTypeIPV6;
extern const NSString* NetworkInterfaceAddressTypeMac;


@interface BCNetworkInfoUtils : NSObject
+(NSArray*)getEthernetInterfaces;
+(NSString*)getHostIPAddressWithType:(NSString*)type;
+(NSString*)getHostMacAddress;
+(NSString*)getGateWayIPAddress;
+(NSString*)getGateWayMACAddress;
@end
