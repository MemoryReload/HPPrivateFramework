//
//  getgateway.c
//  NetWorkInfoTest
//
//  Created by Heping on 9/18/16.
//  Copyright © 2016 BONC. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <netinet/in.h>
#include <string.h>

#include "route.h"

#include "getgateway.h"


#if defined(BSD) || defined(__APPLE__)

#define ROUNDUP(a) \
((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))

int getdefaultgateway( struct sockaddr * addr)
{
    
    int flag= -1;
    if (!addr) {
        return flag;
    }
    
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_FLAGS, RTF_GATEWAY};
    size_t l;
    char * buf, * p;
    struct rt_msghdr * rt;
    struct sockaddr * sa;
    struct sockaddr * sa_tab[RTAX_MAX];
    int i;
    
    if(sysctl(mib, sizeof(mib)/sizeof(int), 0, &l, 0, 0) < 0) {
        return flag;
    }
    
    if(l>0) {
        
        buf = malloc(l);
        if (buf==NULL) {
            return flag;
        }
        
        if(sysctl(mib, sizeof(mib)/sizeof(int), buf, &l, 0, 0) < 0) {
            return flag;
        }
        
        for(p=buf; p<buf+l; p+=rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr *)(rt + 1);
            for(i=0; i<RTAX_MAX; i++) {
                if(rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }
            
            if((rt->rtm_addrs & (RTA_DST|RTA_GATEWAY)) == (RTA_DST|RTA_GATEWAY)) {
                if(((struct sockaddr_in *)sa_tab[RTAX_DST])->sin_addr.s_addr == 0) {
                    char ifName[128];
                    if_indextoname(rt->rtm_index,ifName);
                    if(strcmp("en0",ifName)==0){
                        memcpy(addr, sa_tab[RTAX_GATEWAY],sizeof(struct sockaddr));
                        flag = 0;
                        break;
                    }
                }
            }
        }
        
        free(buf);
    }
    
    return flag;
}
#endif