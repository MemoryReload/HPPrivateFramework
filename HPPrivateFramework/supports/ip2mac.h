//
//  ip2mac.h
//  NetWorkInfoTest
//
//  Created by Heping on 9/19/16.
//  Copyright © 2016 BONC. All rights reserved.
//

#ifndef ip2mac_h
#define ip2mac_h

/* getMacfromIP() :
 * return value :
 *    0 : success
 *   -1 : failure    */
int getMacfromIP(const char* ip,struct sockaddr *link_address);

#endif /* ip2mac_h */
