#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* socket definitions */
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>

/* location of IFF_* constants */
#include <net/if.h>

/* location of getifaddrs() definition */
#ifdef USE_GETIFADDRS
#include <ifaddrs.h>
#endif

#ifndef SIOCGIFCONF
#include <sys/sockio.h>
#endif

#ifdef OSIOCGIFCONF
#define MY_SIOCGIFCONF OSIOCGIFCONF
#else
#define MY_SIOCGIFCONF SIOCGIFCONF
#endif

#ifdef PerlIO
typedef PerlIO * InputStream;
#else
#define PERLIO_IS_STDIO 1
typedef FILE * InputStream;
#define PerlIO_fileno(f) fileno(f)
#endif

static double
constant_IFF_N(char *name, int len, int arg)
{
    errno = 0;
    if (5 + 1 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[5 + 1]) {
    case 'A':
	if (strEQ(name + 5, "OARP")) {	/* IFF_N removed */
#ifdef IFF_NOARP
	    return IFF_NOARP;
#else
	    goto not_there;
#endif
	}
    case 'T':
	if (strEQ(name + 5, "OTRAILERS")) {	/* IFF_N removed */
#ifdef IFF_NOTRAILERS
	    return IFF_NOTRAILERS;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_IFF_PO(char *name, int len, int arg)
{
    errno = 0;
    switch (name[6 + 0]) {
    case 'I':
	if (strEQ(name + 6, "INTOPOINT")) {	/* IFF_PO removed */
#ifdef IFF_POINTOPOINT
	    return IFF_POINTOPOINT;
#else
	    goto not_there;
#endif
	}
    case 'R':
	if (strEQ(name + 6, "RTSEL")) {	/* IFF_PO removed */
#ifdef IFF_PORTSEL
	    return IFF_PORTSEL;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_IFF_P(char *name, int len, int arg)
{
    errno = 0;
    switch (name[5 + 0]) {
    case 'O':
	return constant_IFF_PO(name, len, arg);
    case 'R':
	if (strEQ(name + 5, "ROMISC")) {	/* IFF_P removed */
#ifdef IFF_PROMISC
	    return IFF_PROMISC;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_IFF_A(char *name, int len, int arg)
{
    errno = 0;
    switch (name[5 + 0]) {
    case 'L':
	if (strEQ(name + 5, "LLMULTI")) {	/* IFF_A removed */
#ifdef IFF_ALLMULTI
	    return IFF_ALLMULTI;
#else
	    goto not_there;
#endif
	}
    case 'U':
	if (strEQ(name + 5, "UTOMEDIA")) {	/* IFF_A removed */
#ifdef IFF_AUTOMEDIA
	    return IFF_AUTOMEDIA;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_IFF_M(char *name, int len, int arg)
{
    errno = 0;
    switch (name[5 + 0]) {
    case 'A':
	if (strEQ(name + 5, "ASTER")) {	/* IFF_M removed */
#ifdef IFF_MASTER
	    return IFF_MASTER;
#else
	    goto not_there;
#endif
	}
    case 'U':
	if (strEQ(name + 5, "ULTICAST")) {	/* IFF_M removed */
#ifdef IFF_MULTICAST
	    return IFF_MULTICAST;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_IFF(char *name, int len, int arg)
{
    errno = 0;
    if (3 + 1 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[3 + 1]) {
    case 'A':
	if (!strnEQ(name + 3,"_", 1))
	    break;
	return constant_IFF_A(name, len, arg);
    case 'B':
	if (strEQ(name + 3, "_BROADCAST")) {	/* IFF removed */
#ifdef IFF_BROADCAST
	    return IFF_BROADCAST;
#else
	    goto not_there;
#endif
	}
    case 'D':
	if (strEQ(name + 3, "_DEBUG")) {	/* IFF removed */
#ifdef IFF_DEBUG
	    return IFF_DEBUG;
#else
	    goto not_there;
#endif
	}
    case 'L':
	if (strEQ(name + 3, "_LOOPBACK")) {	/* IFF removed */
#ifdef IFF_LOOPBACK
	    return IFF_LOOPBACK;
#else
	    goto not_there;
#endif
	}
    case 'M':
	if (!strnEQ(name + 3,"_", 1))
	    break;
	return constant_IFF_M(name, len, arg);
    case 'N':
	if (!strnEQ(name + 3,"_", 1))
	    break;
	return constant_IFF_N(name, len, arg);
    case 'P':
	if (!strnEQ(name + 3,"_", 1))
	    break;
	return constant_IFF_P(name, len, arg);
    case 'R':
	if (strEQ(name + 3, "_RUNNING")) {	/* IFF removed */
#ifdef IFF_RUNNING
	    return IFF_RUNNING;
#else
	    goto not_there;
#endif
	}
    case 'S':
	if (strEQ(name + 3, "_SLAVE")) {	/* IFF removed */
#ifdef IFF_SLAVE
	    return IFF_SLAVE;
#else
	    goto not_there;
#endif
	}
    case 'U':
	if (strEQ(name + 3, "_UP")) {	/* IFF removed */
#ifdef IFF_UP
	    return IFF_UP;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant_I(char *name, int len, int arg)
{
    errno = 0;
    if (1 + 1 >= len ) {
	errno = EINVAL;
	return 0;
    }
    switch (name[1 + 1]) {
    case 'F':
	if (!strnEQ(name + 1,"F", 1))
	    break;
	return constant_IFF(name, len, arg);
    case 'H':
	if (strEQ(name + 1, "FHWADDRLEN")) {	/* I removed */
#ifdef IFHWADDRLEN
	    return IFHWADDRLEN;
#else
	    goto not_there;
#endif
	}
    case 'N':
	if (strEQ(name + 1, "FNAMSIZ")) {	/* I removed */
#ifdef IFNAMSIZ
	    return IFNAMSIZ;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant(char *name, int len, int arg)
{
    errno = 0;
    switch (name[0 + 0]) {
    case 'I':
	return constant_I(name, len, arg);
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

int Ioctl (InputStream sock,int operation,void* result) {
  int fd = PerlIO_fileno(sock);
  return ioctl(fd,operation,result) == 0;
}

#ifdef IFHWADDRLEN
char* parse_hwaddr (char *string, struct sockaddr* hwaddr) {
  int          len,i,consumed;
  unsigned int converted;
  char*        s;
  s = string;
  len = strlen(s);
  for (i = 0; i < IFHWADDRLEN && len > 0; i++) {
    if (sscanf(s,"%x%n",&converted,&consumed) <= 0)
      break;
    hwaddr->sa_data[i] = converted;
    s += consumed + 1;
    len -= consumed + 1;
  }
  if (i != IFHWADDRLEN)
    return NULL;
  else 
    return string;
}

/* No checking for string buffer length. Caller must ensure at least
   3*4 + 3 + 1 = 16 bytes long */
char* format_hwaddr (char *string, struct sockaddr* hwaddr) {
  int i,len;
  char *s;
  s = string;
  s[0] = '\0';
  for (i = 0; i < IFHWADDRLEN; i++) {
    if (i < IFHWADDRLEN-1)
      len = sprintf(s,"%02x:",(unsigned char)hwaddr->sa_data[i]);
    else
      len = sprintf(s,"%02x",(unsigned char)hwaddr->sa_data[i]);
    s += len;
  }
  return string;
}
#endif

MODULE = IO::Interface		PACKAGE = IO::Interface

double
constant(sv,arg)
    PREINIT:
	STRLEN		len;
    PROTOTYPE: $;$
    INPUT:
	SV *		sv
	char *		s = SvPV(sv, len);
	int		arg
    CODE:
	RETVAL = constant(s,len,arg);
    OUTPUT:
	RETVAL

char*
if_addr(sock, name, ...)
     InputStream sock
     char*       name
     PROTOTYPE: $$;$
     PREINIT:
     STRLEN        len;
     int           operation;
     struct ifreq  ifr;
     char*         newaddr;
     CODE:
   {
#if !(defined(HAS_IOCTL) && defined(SIOCGIFADDR))
     XSRETURN_UNDEF;
#else
     if (strncmp(name,"any",3) == 0) {
       RETVAL = "0.0.0.0";
     } else {
       bzero((void*)&ifr,sizeof(struct ifreq));
       strncpy(ifr.ifr_name,name,IFNAMSIZ-1);
       ifr.ifr_addr.sa_family = AF_INET;
       if (items > 2) {
	 newaddr = SvPV(ST(2),len);
	 if ( inet_aton(newaddr,&((struct sockaddr_in*)&ifr.ifr_addr)->sin_addr) == 0 ) 
	   croak("Invalid inet address");
	 operation = SIOCSIFADDR; 
       } else {
	 operation = SIOCGIFADDR;
       }
       if (!Ioctl(sock,operation,&ifr)) XSRETURN_UNDEF;
       if (ifr.ifr_addr.sa_family != AF_INET) croak ("Address is not in the AF_INET family.\n");
       RETVAL = inet_ntoa(((struct sockaddr_in*) &ifr.ifr_addr)->sin_addr);
     }
#endif
   }
   OUTPUT:
     RETVAL

char*
if_broadcast(sock, name, ...)
     InputStream sock
     char*       name
     PROTOTYPE: $$;$
     PREINIT:
     STRLEN        len;
     int           operation;
     struct ifreq  ifr;
     char*         newaddr;
     CODE:
   {
#if !(defined(HAS_IOCTL) && defined(SIOCGIFBRDADDR))
     XSRETURN_UNDEF;
#else
     bzero((void*)&ifr,sizeof(struct ifreq));
     strncpy(ifr.ifr_name,name,IFNAMSIZ-1);
     ifr.ifr_addr.sa_family = AF_INET;
     if (items > 2) {
       newaddr = SvPV(ST(2),len);
       if ( inet_aton(newaddr,&((struct sockaddr_in*)&ifr.ifr_addr)->sin_addr) == 0 ) 
	 croak("Invalid inet address");
         operation = SIOCSIFBRDADDR; 
     } else {
	  operation = SIOCGIFBRDADDR;
     }
     if (!Ioctl(sock,operation,&ifr)) XSRETURN_UNDEF;
     if (ifr.ifr_addr.sa_family != AF_INET) croak ("Address is not in the AF_INET family.\n");
     RETVAL = inet_ntoa(((struct sockaddr_in*) &ifr.ifr_addr)->sin_addr);
#endif
   }
   OUTPUT:
     RETVAL

char*
if_netmask(sock, name, ...)
     InputStream sock
     char*       name
     PROTOTYPE: $$;$
     PREINIT:
     STRLEN         len;
     int            operation;
     struct ifreq   ifr;
     char*          newaddr;
     CODE:
   {
#if !(defined(HAS_IOCTL) && defined(SIOCGIFNETMASK))
     XSRETURN_UNDEF;
#else
     bzero((void*)&ifr,sizeof(struct ifreq));
     strncpy(ifr.ifr_name,name,IFNAMSIZ-1);
     ifr.ifr_addr.sa_family = AF_INET;
     if (items > 2) {
       newaddr = SvPV(ST(2),len);
       if ( inet_aton(newaddr,&((struct sockaddr_in*)&ifr.ifr_addr)->sin_addr) == 0 ) 
	 croak("Invalid inet address");
         operation = SIOCSIFNETMASK; 
     } else {
	  operation = SIOCGIFNETMASK;
     }
     if (!Ioctl(sock,operation,&ifr)) XSRETURN_UNDEF;
     if (ifr.ifr_addr.sa_family != AF_INET) croak ("Address is not in the AF_INET family.\n");
     RETVAL = inet_ntoa(((struct sockaddr_in*) &ifr.ifr_addr)->sin_addr);
#endif
   }
   OUTPUT:
     RETVAL

char*
if_dstaddr(sock, name, ...)
     InputStream sock
     char*       name
     PROTOTYPE: $$;$
     PREINIT:
     STRLEN         len;
     int            operation;
     struct ifreq   ifr;
     char*          newaddr;
     CODE:
   {
#if !(defined(HAS_IOCTL) && defined(SIOCGIFDSTADDR))
     XSRETURN_UNDEF;
#else
     bzero((void*)&ifr,sizeof(struct ifreq));
     strncpy(ifr.ifr_name,name,IFNAMSIZ-1);
     ifr.ifr_addr.sa_family = AF_INET;
     if (items > 2) {
       newaddr = SvPV(ST(2),len);
       if ( inet_aton(newaddr,&((struct sockaddr_in*)&ifr.ifr_addr)->sin_addr) == 0 ) 
	 croak("Invalid inet address");
       operation = SIOCSIFDSTADDR;
     } else {
       operation = SIOCGIFDSTADDR;
     }
     if (!Ioctl(sock,operation,&ifr)) XSRETURN_UNDEF;
     if (ifr.ifr_addr.sa_family != AF_INET) croak ("Address is not in the AF_INET family.\n");
     RETVAL = inet_ntoa(((struct sockaddr_in*) &ifr.ifr_addr)->sin_addr);
#endif
   }
   OUTPUT:
     RETVAL

char*
if_hwaddr(sock, name, ...)
     InputStream sock
     char*       name
     PROTOTYPE: $$;$
     PREINIT:
     STRLEN	    len;
     int            operation;
     struct ifreq   ifr;
     char           *newaddr,hwaddr[128];
     CODE:
   {
#if !(defined(HAS_IOCTL) && defined(SIOCGIFHWADDR))
     XSRETURN_UNDEF;
#else
     bzero((void*)&ifr,sizeof(struct ifreq));
     strncpy(ifr.ifr_name,name,IFNAMSIZ-1);
     ifr.ifr_hwaddr.sa_family = AF_UNSPEC;
     if (items > 2) {
       newaddr = SvPV(ST(2),len);
       if (parse_hwaddr(newaddr,&ifr.ifr_hwaddr) == NULL)
	 croak("Invalid hardware address");
       operation = SIOCSIFHWADDR;
     } else {
       operation = SIOCGIFHWADDR;
     }
     if (!Ioctl(sock,operation,&ifr)) XSRETURN_UNDEF;
     RETVAL = format_hwaddr(hwaddr,&ifr.ifr_hwaddr);
#endif
   }
   OUTPUT:
     RETVAL

int
if_flags(sock, name, ...)
     InputStream sock
     char*       name
     PROTOTYPE: $$;$
     PREINIT:
     int            operation,flags;
     struct ifreq   ifr;
     CODE:
   {
#if !(defined(HAS_IOCTL) && defined(SIOCGIFFLAGS))
     XSRETURN_UNDEF;
#endif
     bzero((void*)&ifr,sizeof(struct ifreq));
     strncpy(ifr.ifr_name,name,IFNAMSIZ-1);
     if (items > 2) {
       ifr.ifr_flags = SvIV(ST(2));
       operation = SIOCSIFFLAGS;
     } else {
       operation = SIOCGIFFLAGS;
     }
     if (!Ioctl(sock,operation,&ifr)) XSRETURN_UNDEF;
     RETVAL = ifr.ifr_flags;
   }
   OUTPUT:
     RETVAL

void
_if_list(sock)
     InputStream sock
     PROTOTYPE: $
     PREINIT:
#ifdef USE_GETIFADDRS
       struct ifaddrs *ifa_start;
       struct ifaddrs *ifa;
#else
       struct ifconf ifc;
       struct ifreq  *ifr;
       int    lastlen,len;
       char   *buf,*ptr;
#endif
     PPCODE:
#ifdef USE_GETIFADDRS
       if (getifaddrs(&ifa_start) < 0)
	 XSRETURN_EMPTY;

       for (ifa = ifa_start ; ifa ; ifa = ifa->ifa_next)
	 XPUSHs(sv_2mortal(newSVpv(ifa->ifa_name,0)));

       freeifaddrs(ifa_start);
#else
       lastlen = 0;
       len     = 10 * sizeof(struct ifreq); /* initial buffer size guess */
       for ( ; ; ) {
	 if ( (buf = safemalloc(len)) == NULL)
	   croak("Couldn't malloc buffer for ioctl: %s",strerror(errno));
	 ifc.ifc_len = len;
	 ifc.ifc_buf = buf;
	 if (ioctl(PerlIO_fileno(sock),MY_SIOCGIFCONF,&ifc) < 0) {
	   if (errno != EINVAL || lastlen != 0)
	     XSRETURN_EMPTY;
	 } else {
	   if (ifc.ifc_len == lastlen) break;  /* success, len has not changed */
	   lastlen = ifc.ifc_len;
	 }
	 len += 10 * sizeof(struct ifreq); /* increment */
	 safefree(buf);
       }
       
       for (ptr = buf ; ptr < buf + ifc.ifc_len ; ptr += sizeof(struct ifreq)) {
	 ifr = (struct ifreq*) ptr;
	 XPUSHs(sv_2mortal(newSVpv(ifr->ifr_name,0)));
       }
       safefree(buf);
#endif
