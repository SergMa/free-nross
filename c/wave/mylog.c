/******************************************************************************/
/* LOG-OUT UTILITES                                                           */
/* mylog.c                                                                    */
/* (c) Sergei Mashkin, 2015                                                   */
/******************************************************************************/

#include "mylog.h"

char   mylog_strbuff[4096];
int    mylog_len;

//------------------------------------------------------------
//Print out log message into log device (for MYLOG_USER)
//returns:  0 = ok
//         -1 = error
void mylog_out( const char * logtype, int line, const char * func, const char * format, ... )
{
    va_list   arg;
    char    * funcstr;
    int       funclen;

    funclen = strlen(func);
    if(funclen<=20)
            funcstr = (char*)func;
    else    funcstr = (char*)func + (funclen-20);


    if(log_settings.device==MYLOG_DEVICE_STDOUT) {
        printf( "[%s] " PROCNAME ":%s:%20s:%6d: ", datetime(), logtype, funcstr, line );
        va_start( arg, format );
        vprintf( format, arg );
        va_end( arg );
        printf("\n");
#ifdef MYLOGSYNC_ENABLE
        fflush(stdout);
#endif
    }
    else {
        mylog_len = snprintf( mylog_strbuff, sizeof(mylog_strbuff), "%s:%20s:%6d: ", logtype, funcstr, line );
        va_start( arg, format );
        vsnprintf( mylog_strbuff + mylog_len, sizeof(mylog_strbuff) - mylog_len, format, arg );
        va_end( arg );
        syslog(LOG_INFO,mylog_strbuff);
    }
}

//------------------------------------------------------------
//Print out log message into log device (for MYLOG_ERROR)
//returns:  0 = ok
//         -1 = error
void mylog_out_error( int line, const char * func, const char * format, ... )
{
    va_list   arg;
    char    * funcstr;
    int       funclen;

    funclen = strlen(func);
    if(funclen<=20)
            funcstr = (char*)func;
    else    funcstr = (char*)func + (funclen-20);

    if(log_settings.device==MYLOG_DEVICE_STDOUT) {
        printf( "[%s] " PROCNAME ":ERR:%20s:%6d: ", datetime(), funcstr, line );
        va_start( arg, format );
        vprintf( format, arg );
        va_end( arg );
        printf("\n");
#ifdef MYLOGSYNC_ENABLE
        fflush(stdout);
#endif
    }
    else {
        mylog_len = snprintf( mylog_strbuff, sizeof(mylog_strbuff), "ERR:%20s:%6d: ", funcstr, line );
        va_start( arg, format );
        vsnprintf( mylog_strbuff + mylog_len, sizeof(mylog_strbuff) - mylog_len, format, arg );
        va_end( arg );
        syslog(LOG_ERR,mylog_strbuff);
    }
}
