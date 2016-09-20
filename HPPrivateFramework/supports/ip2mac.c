//
//  ip2mac.c
//  NetWorkInfoTest
//
//  Created by Heping on 9/19/16.
//  Copyright © 2016 BONC. All rights reserved.
//



#include <stdio.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>
#include <net/if_dl.h>
#include <err.h>

#include "route.h"
#include "if_ether.h"

#include "ip2mac.h"

int getMacfromIP(const char* ip,struct sockaddr * link_address)
{
    int flag=-1;
    
    u_long addr = inet_addr(ip);
    
    int mib[6];
    size_t needed;
    char  *lim, *buf, *next;
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0){
        return flag;
    }
    
    if (needed>0) {
        
        if ((buf = malloc(needed)) == NULL) return flag;
        
        if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0)
        {
          free(buf);
          return flag;
        }
        
        lim = buf + needed;
        for (next = buf; next < lim; next += rtm->rtm_msglen) {
            rtm = (struct rt_msghdr *)next;
            sin = (struct sockaddr_inarp *)(rtm + 1);
            sdl = (struct sockaddr_dl *)(sin + 1);
            
            if (addr == sin->sin_addr.s_addr) {
                if (sdl->sdl_alen) {
                    memcpy(link_address, sdl, sizeof(struct sockaddr));
                    flag=0;
                    break;
                }
            };
        }
        
        free(buf);
    }
    
    return flag;
}