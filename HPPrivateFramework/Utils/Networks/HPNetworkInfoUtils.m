//
//  BCNetworkInfoUtils.m
//  NetWorkInfoTest
//
//  Created by Heping on 9/7/16.
//  Copyright © 2016 BONC. All rights reserved.
//

#import "HPNetworkInfoUtils.h"
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <net/if_dl.h>

#import "getgateway.h"
#import "ip2mac.h"

#define WIFI          @"en0"
#define CELLULAR      @"pdp_ip0"


const NSString* NetworkInterfaceNameKey=@"Name";
const NSString* NetWorkInterfaceFlagsKey=@"Flag";
const NSString* NetworkInterfaceAddressKey=@"Address";
const NSString* NetworkInterfaceNetMaskKey=@"NetMask";

const NSString* NetworkInterfaceAddressTypeKey=@"AddressType";

const NSString* NetworkInterfaceAddressTypeUnknown=@"Unknown";
const NSString* NetworkInterfaceAddressTypeIPV4=@"IPv4";
const NSString* NetworkInterfaceAddressTypeIPV6=@"IPv6";
const NSString* NetworkInterfaceAddressTypeMac=@"MAC";

const NSString* NetworkSockAddressKey=@"SockAddress";


@interface BCNetworkInfoUtils ()
+(NSDictionary*)getSockaddrInfo:(struct sockaddr*)sockaddr;
+(NSDictionary*)getNetworkInterfaceInfo:(struct ifaddrs *)ifaddrs;
@end

@implementation BCNetworkInfoUtils


+(NSArray*)getEthernetInterfaces
{
    
    NSMutableArray* array=[[NSMutableArray alloc]init];
    
    struct ifaddrs *addrs=NULL;
    BOOL success=getifaddrs(&addrs);
    if (success) {
        return nil;
    }
    for (struct ifaddrs *ptr=addrs; ptr; ptr=ptr->ifa_next) {
        NSDictionary* interfaceInfo=[self getNetworkInterfaceInfo:ptr];
        if (interfaceInfo) {
            [array addObject:interfaceInfo];
        }
    }
    free(addrs);
    
    if (array.count==0) {
        array=nil;
    }
    
    return array;
}


+(NSString*)getHostIPAddressWithType:(NSString*)type
{
    if (type&&![type isEqualToString:(NSString*)NetworkInterfaceAddressTypeIPV4]&&![type isEqualToString:(NSString*)NetworkInterfaceAddressTypeIPV6]) {
        return nil;
    }
    
    NSString* ipType=type;
    if (!ipType) {
        ipType= (NSString*)NetworkInterfaceAddressTypeIPV4;
    }
    
    NSString* ipAddress;
    //优先查找wifi
    for (NSDictionary* interface in [self getEthernetInterfaces]) {
        NSString* interfaceType=[interface valueForKey:(NSString*)NetworkInterfaceAddressTypeKey];
        NSString* name=[interface valueForKey:(NSString*)NetworkInterfaceNameKey];
        if ([interfaceType isEqualToString:ipType]&&[name isEqualToString:WIFI]) {
            ipAddress=[interface valueForKey:(NSString*)NetworkInterfaceAddressKey];
            break;
        }
    }
    
    if (ipAddress) {
        return ipAddress;
    }
    
    //如果wifi查找失败（没有打开），查找蜂窝网络
    for (NSDictionary* interface in [self getEthernetInterfaces]) {
        NSString* interfaceType=[interface valueForKey:(NSString*)NetworkInterfaceAddressTypeKey];
        NSString* name=[interface valueForKey:(NSString*)NetworkInterfaceNameKey];
        if ([interfaceType isEqualToString:ipType]&&[name isEqualToString:CELLULAR]) {
            ipAddress=[interface valueForKey:(NSString*)NetworkInterfaceAddressKey];
            break;
        }
    }
    
    return ipAddress;
}


+(NSString*)getHostMacAddress
{
    NSString* macAddress;
    //优先查找wifi
    for (NSDictionary* interface in [self getEthernetInterfaces]) {
        NSString* interfaceType=[interface valueForKey:(NSString*)NetworkInterfaceAddressTypeKey];
        NSString* name=[interface valueForKey:(NSString*)NetworkInterfaceNameKey];
        if ([interfaceType isEqualToString:(NSString*)NetworkInterfaceAddressTypeMac]&&[name isEqualToString:WIFI]) {
            macAddress=[interface valueForKey:(NSString*)NetworkInterfaceAddressKey];
            break;
        }
    }

    if (macAddress) {
        return macAddress;
    }

    //如果wifi查找失败（没有打开），查找蜂窝网络
    for (NSDictionary* interface in [self getEthernetInterfaces]) {
        NSString* interfaceType=[interface valueForKey:(NSString*)NetworkInterfaceAddressTypeKey];
        NSString* name=[interface valueForKey:(NSString*)NetworkInterfaceNameKey];
        if ([interfaceType isEqualToString:(NSString*)NetworkInterfaceAddressTypeMac]&&[name isEqualToString:CELLULAR]) {
            macAddress=[interface valueForKey:(NSString*)NetworkInterfaceAddressKey];
            break;
        }
    }

    return macAddress;
}

//+(NSString*)getHostMacAddress
//{
//    NSString* ip=[self getHostIPAddressWithType:(NSString *)NetworkInterfaceAddressTypeIPV4];
//    const char* address=[ip cStringUsingEncoding:NSUTF8StringEncoding];
//    if (address) {
//        struct sockaddr sockAddress;
//        if (!getMacfromIP(address, &sockAddress)) {
//            NSDictionary* addressInfo=[self getSockaddrInfo:&sockAddress];
//            return [addressInfo valueForKey:(NSString*)NetworkSockAddressKey];
//        }
//    }
//    return nil;
//}

+(NSString*)getGateWayIPAddress
{
    NSString *ipString = nil;
    struct sockaddr gatewayaddr;
    if(!getdefaultgateway(&gatewayaddr)) {
        NSDictionary* addressInfo=[self getSockaddrInfo:&gatewayaddr];
        ipString=[addressInfo valueForKey:(NSString*)NetworkSockAddressKey];
    }
    return ipString;
}

+(NSString *)getGateWayMACAddress
{
    NSString* ip=[self getGateWayIPAddress];
    const char* address=[ip cStringUsingEncoding:NSUTF8StringEncoding];
    if (address) {
        struct sockaddr sockAddress;
        if (!getMacfromIP(address, &sockAddress)) {
            NSDictionary* addressInfo=[self getSockaddrInfo:&sockAddress];
            return [addressInfo valueForKey:(NSString*)NetworkSockAddressKey];
        }
    }
    return nil;
}

#pragma mark - Private Method

+(NSDictionary*)getSockaddrInfo:(struct sockaddr*)sockaddr
{
    if (!sockaddr) {
        return nil;
    }
    
    NSMutableDictionary* sockaddrInfo=[[NSMutableDictionary alloc]init];
    
    unsigned int length=0;
    if (sockaddr->sa_family==AF_INET||sockaddr->sa_family==AF_INET6) {
        if (sockaddr->sa_family==AF_INET) {
            [sockaddrInfo setObject:NetworkInterfaceAddressTypeIPV4 forKey:NetworkInterfaceAddressTypeKey];
            length=INET_ADDRSTRLEN;
        }
        else if (sockaddr->sa_family==AF_INET6){
            [sockaddrInfo setObject:NetworkInterfaceAddressTypeIPV6 forKey:NetworkInterfaceAddressTypeKey];
            length=INET6_ADDRSTRLEN;
        }
        char* addrbuf=malloc(length);
        memset(addrbuf, 0, length);
        const char* temp=inet_ntop(sockaddr->sa_family, &(((struct sockaddr_in*)sockaddr)->sin_addr), addrbuf, length);
        if (temp) {
            [sockaddrInfo setObject:[NSString stringWithUTF8String:addrbuf] forKey:NetworkSockAddressKey];
        }
        free(addrbuf);
    }else if(sockaddr->sa_family==AF_LINK){
        [sockaddrInfo setObject:NetworkInterfaceAddressTypeMac forKey:NetworkInterfaceAddressTypeKey];
        struct sockaddr_dl* linkaddr=(struct sockaddr_dl*)sockaddr;
        if (linkaddr->sdl_alen>0) {
            NSMutableString* address=[[NSMutableString alloc]init];
            unsigned char *octetp=(unsigned char *)LLADDR(linkaddr);
            NSString* sep= @"\n";
            for (int i = 0; i < linkaddr->sdl_alen; i++) {
                if (![sep isEqualToString:@"\n"]) [address appendString:sep];
                [address appendString:[NSString stringWithFormat:@"%02x",octetp[i]]];
                sep = @":";
            }
            [sockaddrInfo setObject:address forKey:NetworkSockAddressKey];
        }
        else{
            [sockaddrInfo setObject:@"" forKey:NetworkSockAddressKey];
        }
    }else{
        [sockaddrInfo setObject:NetworkInterfaceAddressTypeUnknown forKey:NetworkInterfaceAddressTypeKey];
    }
    
    if (sockaddrInfo.count==0) {
        return nil;
    }
    return sockaddrInfo;
}

+(NSDictionary*)getNetworkInterfaceInfo:(struct ifaddrs *)ifaddrs
{
    NSString* name, *flag;
    NSDictionary *ipaddr , *netmask;
    //网络接口名称
    name=[NSString stringWithUTF8String:ifaddrs->ifa_name];
    //网络接口状态
    flag=[NSString stringWithFormat:@"0x%x",ifaddrs->ifa_flags];
    //网络接口ip
    ipaddr=[self getSockaddrInfo:ifaddrs->ifa_addr];
    //网络接口掩码
    netmask=[self getSockaddrInfo:ifaddrs->ifa_netmask];
    
    NSMutableDictionary* interfaceInfo=[[NSMutableDictionary alloc]initWithObjectsAndKeys:name,NetworkInterfaceNameKey,flag,NetWorkInterfaceFlagsKey, nil];
    
    [interfaceInfo addEntriesFromDictionary:ipaddr];
    NSString* addressIp=[ipaddr valueForKey:(NSString*)NetworkSockAddressKey];
    if (addressIp) {
        [interfaceInfo removeObjectForKey:NetworkSockAddressKey];
        [interfaceInfo setObject:addressIp forKey:NetworkInterfaceAddressKey];
    }
    
    [interfaceInfo addEntriesFromDictionary:netmask];
    NSString* maskIP=[netmask valueForKey:(NSString*)NetworkSockAddressKey];
    if (maskIP) {
        [interfaceInfo removeObjectForKey:NetworkSockAddressKey];
        [interfaceInfo setObject:maskIP forKey:NetworkInterfaceNetMaskKey];
    }
    
    return interfaceInfo;
}
@end
