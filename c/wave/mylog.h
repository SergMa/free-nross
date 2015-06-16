/******************************************************************************/
/* LOG-OUT UTILITES                                                           */
/* mylog.h                                                                    */
/* (c) Sergei Mashkin, 2015                                                   */
/******************************************************************************/

#ifndef MYLOG_H
#define MYLOG_H

#include "../../shared/log_settings.h"
#include "../../shared/utilites.h"

#include <stdarg.h>
#include <syslog.h>
#include <sys/types.h>

#define MYLOGSYNC_ENABLE 1 //uncomment this to enable fflush, fsunc for log files

extern char   mylog_strbuff[4096];
extern int    mylog_len;
extern char * mylog_ptr;

//---- FUNCTIONS ---------------------------------------------

void mylog_out      ( const char * logtype, int line, const char * func, const char * format, ... );
void mylog_out_error(                       int line, const char * func, const char * format, ... );


#define PROCNAME "RTP"

#define MYLOGDEVICE_NOLOGS     0
#define MYLOGDEVICE_STDOUT     1  //printf()
#define MYLOGDEVICE_SYSLOG     2  //syslog()

#ifndef MYLOGDEVICE
#define MYLOGDEVICE MYLOGDEVICE_NOLOGS
#endif

    //////////////////////////////////////////////////////////////
#if MYLOGDEVICE == MYLOGDEVICE_NOLOGS
    //////////////////////////////////////////////////////////////

    #define MYLOG_SCREEN(mess...) \
        do{                       \
            printf(mess);         \
            printf("\n");         \
        }while(0)

    #define MYLOG_USER(mess...)
    #define MYLOG_ERROR(mess...)
    #define MYLOG_WARNING(mess...)
    #define MYLOG_EVENT(mess...)
    #define MYLOG_MESSAGE(mess...)
    #define MYLOG_STATE(mess...)
    #define MYLOG_DEBUG(mess...)
    #define MYLOG_TRACE(mess...)
    #define MYLOG_GOD(mess...)
    #define MYLOG_REALTIME(mess...)

    //////////////////////////////////////////////////////////////
#elif (MYLOGDEVICE == MYLOGDEVICE_STDOUT) || (MYLOGDEVICE == MYLOGDEVICE_SYSLOG)
    //////////////////////////////////////////////////////////////

    #define MYLOG_SCREEN(mess...)                                 \
        do{                                                       \
            printf(mess);                                         \
            printf("\n");                                         \
        }while(0)

    #define MYLOG_USER(mess...)                                   \
        do{                                                       \
            if(log_settings.enabled & MYLOG_ENABLED_USER) {       \
                mylog_out("USE",__LINE__,__FUNCTION__,mess);      \
            }                                                     \
        }while(0)

    #define MYLOG_ERROR(mess...)                                  \
        do{                                                       \
            if(log_settings.enabled & MYLOG_ENABLED_ERROR) {      \
                mylog_out_error(__LINE__,__FUNCTION__,mess);      \
            }                                                     \
        }while(0)

    #define MYLOG_WARNING(mess...)                                \
        do{                                                       \
            if(log_settings.enabled & MYLOG_ENABLED_WARNING) {    \
                mylog_out("WAR",__LINE__,__FUNCTION__,mess);      \
            }                                                     \
        }while(0)

    #define MYLOG_EVENT(mess...)                                  \
        do{                                                       \
            if(log_settings.enabled & MYLOG_ENABLED_EVENT) {      \
                mylog_out("EVE",__LINE__,__FUNCTION__,mess);      \
            }                                                     \
        }while(0)

    #define MYLOG_MESSAGE(mess...)                                \
        do{                                                       \
            if(log_settings.enabled & MYLOG_ENABLED_MESSAGE) {    \
                mylog_out("MES",__LINE__,__FUNCTION__,mess);      \
            }                                                     \
        }while(0)

    #define MYLOG_STATE(mess...)                                  \
        do{                                                       \
            if(log_settings.enabled & MYLOG_ENABLED_STATE) {      \
                mylog_out("STA",__LINE__,__FUNCTION__,mess);      \
            }                                                     \
        }while(0)

    #define MYLOG_DEBUG(mess...)                                  \
        do{                                                       \
            if(log_settings.enabled & MYLOG_ENABLED_DEBUG) {      \
                mylog_out("DEB",__LINE__,__FUNCTION__,mess);      \
            }                                                     \
        }while(0)

    #define MYLOG_TRACE(mess...)                                  \
        do{                                                       \
            if(log_settings.enabled & MYLOG_ENABLED_TRACE) {      \
                mylog_out("TRA",__LINE__,__FUNCTION__,mess);      \
            }                                                     \
        }while(0)

    #define MYLOG_GOD(mess...)                                    \
        do{                                                       \
            if(log_settings.enabled & MYLOG_ENABLED_GOD) {        \
                mylog_out("GOD",__LINE__,__FUNCTION__,mess);      \
            }                                                     \
        }while(0)

    #define MYLOG_REALTIME(mess...)                               \
        do{                                                       \
            if(log_settings.enabled & MYLOG_ENABLED_REALTIME) {   \
                mylog_out("REA",__LINE__,__FUNCTION__,mess);      \
            }                                                     \
        }while(0)

    //////////////////////////////////////////////////////////////
#endif // MYLOGDEVICE
    //////////////////////////////////////////////////////////////


#endif //MYLOG_H


