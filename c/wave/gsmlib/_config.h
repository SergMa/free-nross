/*
 * Copyright 1992 by Jutta Degener and Carsten Bormann, Technische
 * Universitaet Berlin.  See the accompanying file "COPYRIGHT" for
 * details.  THERE IS ABSOLUTELY NO WARRANTY FOR THIS SOFTWARE.
 */

/*$Header: /cvsroot/linphone/linphone/gsmlib/config.h,v 1.1.1.1 2001/11/19 19:50:11 smorlat Exp $*/

#ifndef     CONFIG_H
#define     CONFIG_H

/********************************************************/
/********************************************************/

/* Define to 1 if you have the <fcntl.h> header file. */
#define HAVE_FCNTL_H 1

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Defined if you have lrand48 */
#define HAVE_LRAND48

/* Define to 1 if you have the <malloc.h> header file. */
#define HAVE_MALLOC_H 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the <semaphore.h> header file. */
#define HAVE_SEMAPHORE_H 1

/* Define to 1 if you have the <signal.h> header file. */
#define HAVE_SIGNAL_H 1

/* Define to 1 if you have the <stdarg.h> header file. */
#define HAVE_STDARG_H 1

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdio.h> header file. */
#define HAVE_STDIO_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if the system has the type `struct timeval'. */
#define HAVE_STRUCT_TIMEVAL 1

/* Define to 1 if you have the <syslog.h> header file. */
#define HAVE_SYSLOG_H 1

/* Define to 1 if you have the <sys/select.h> header file. */
#define HAVE_SYS_SELECT_H 1

/* Define to 1 if you have the <sys/sem.h> header file. */
#define HAVE_SYS_SEM_H 1

/* Define to 1 if you have the <sys/signal.h> header file. */
#define HAVE_SYS_SIGNAL_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/time.h> header file. */
#define HAVE_SYS_TIME_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <sys/unistd.h> header file. */
#define HAVE_SYS_UNISTD_H 1

/* Define to 1 if you have the <time.h> header file. */
#define HAVE_TIME_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to 1 if you have the <varargs.h> header file. */
/* #undef HAVE_VARARGS_H */

/* Define to the necessary symbol if this constant uses a non-standard name on
   your system. */
/* #undef PTHREAD_CREATE_JOINABLE */

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Define to 1 if you have the <arpa/inet.h> header file. */
#define HAVE_ARPA_INET_H 1

/* Define to 1 if you have the <arpa/nameser.h> header file. */
#define HAVE_ARPA_NAMESER_H 1

/* Define to 1 if you have the `getifaddrs' function. */
/* #define HAVE_GETIFADDRS 1 */

/* Define to 1 if you have the <netdb.h> header file. */
#define HAVE_NETDB_H 1

/* Define to 1 if you have the <resolv8_compat.h> header file. */
/* #undef HAVE_RESOLV8_COMPAT_H */

/* Define to 1 if you have the <resolv.h> header file. */
#define HAVE_RESOLV_H 1

/* Define to 1 if you have the <sys/soundcard.h> header file. */
#define HAVE_SYS_SOUNDCARD_H 1

/* Define to 1 if you have the <varargs.h> header file. */
/* #undef HAVE_VARARGS_H */

/* GSM:
 * If NDEBUG _is_ defined and no debugging should be performed,
 * calls to functions in this module are #defined to nothing
 * in private.h.
 */
#define NDEBUG 1

/* GSM
 * If your machine does multiply integers fast enough,
 * leave USE_FLOAT_MUL undefined.  The results should be the
 * same in both cases.
 *
 * On machines with fast floating point arithmetic, defining
 * both USE_FLOAT_MUL and FAST makes a run-time library
 * option available that will (in a few crucial places) use
 * ``native'' floating point operations rather than the bit-by-bit
 * defined ones of the GSM standard.  If you use this fast
 * option, the outcome will not be bitwise identical to the
 * results prescribed by the standard, but it is compatible with
 * the standard encoding, and a user is unlikely to notice a
 * difference.
 */
//#define USE_FLOAT_MUL 1
//#ifdef USE_FLOAT_MUL
//  #define FAST
//#endif

/* GSM:
 * Define SASR if >> is a signed arithmetic shift (-1 >> 1 == -1)
 */
#define SASR 1

/* GSM:
 * Define to enable the GSM library's option to pack GSM frames
 * in the style used by the WAV #49 format.  If you want to write
 * a tool that produces .WAV files which contain GSM-encoded data,
 * define this, and read about the GSM_OPT_WAV49 option in the
 * manual page on gsm_option(3).
 */
//#define WAV49 1

/* GSM:
 * Define to enable the GSM library's long-term correlation
 * approximation option---faster, but worse; works for
 * both integer and floating point multiplications.
 * This flag is still in the experimental stage.
 */
//#define LTP_CUT 1

/* GSM:
 */
#define NeedFunctionPrototypes 1
 
#endif  /* CONFIG_H */
