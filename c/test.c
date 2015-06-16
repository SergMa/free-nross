/******************************************************************************/
/* TEST PROGRAMM FOR NOISE REMOVER                                            */
/* test.c                                                                     */
/* (c) Sergei Mashkin, 2015                                                   */
/******************************************************************************/

#include <stdio.h>
#include <stdlib.h>

void usage(progname)
{
    printf("%s usage:\n",progname);
    printf("\t%s <wavefile1> <wavefile2>\n", progname);
    printf("\t\tprocess <wavefile1> and write result into <wavefile2>\n");
    printf("\t%s --help", progname);
    printf("\t\tshow this message\n");
    return;
}


int main( int argc, char **argv )
{
    struct noise_remover_s nrm;
    int          err;
    char       * progname;
    char       * input_filename;
    char       * output_filename;
    wavefile_t * iwf = NULL;
    wavefile_t * owf = NULL;
    int16_t      x;
    int16_t      y;
    uint32_t     samples;
    uint32_t     processed;

    if(argc<=0) {
        printf("error: unexpected error\n");
        exit(0);
    }
    progname = argv[0];

    /**** Get and process command options ****/
    if(argc<=1 || argc>3) {
        printf("error: invalid number of arguments\n");
        usage(progname);
        exit(0);
    }
    else if(argc==2 && 0==strcmp(argv[1],"--help")) {
        usage(progname);
        exit(0);
    }
    else if(argc==3) {
        input_filename  = argv[1];
        output_filename = argv[2];
        //go-go-go
    }

    /**** initialize variables ****/
    err = noise_remover_init( &nrm );
    if(err<0) {
        printf("error: noise_remover_init() failed\n");
        goto exit_fail;
    }
    iwf = wavefile_create();
    if(!iwf) {
        printf("error: wavefile_create() failed for input wavefile\n");
        goto exit_fail;
    }
    owf = wavefile_create();
    if(!owf) {
        printf("error: wavefile_create() failed for output wavefile\n");
        goto exit_fail;
    }

    /**** open input wavefile and show file-info ****/
    err = wavefile_read_open( iwf, input_filename );
    if(err<0) {
        printf("error: could not open input wavefile \"%s\"\n", input_filename);
        goto exit_fail;
    }
    printf("wavefile info:\n");
    printf("filename : %s\n", input_filename);
    printf("format   : ");
    switch( wavefile_get_wavetype( iwf ) ) {
    case WAVETYPE_MONO_8000HZ_PCM16:   printf("pcm16 8000 Hz\n"); break;
    case WAVETYPE_MONO_8000HZ_PCMA:    printf("pcma 8000 Hz\n"); break;
    case WAVETYPE_MONO_8000HZ_PCMU:    printf("pcmu 8000 Hz\n"); break;
    case WAVETYPE_MONO_8000HZ_GSM610:  printf("gsm0610 8000 Hz\n"); break;
    default:
        printf("unsupported\n");
        printf("error: only 8000 hz pcm16/pcma/pcmu/gsm formats are supported\n");
        goto exit_fail;
    }
    printf("filesize : %lu bytes\n", wavefile_get_bytes  ( iwf ) );
    printf("length   : %lu sec\n",   wavefile_get_seconds( iwf ) );
    samples = wavefile_get_samples( iwf );
    printf("samples  : %lu\n", samples );
    printf("\n");

    /**** open output wavefile ****/
    err = wavefile_write_open ( owf, output_filename, WAVETYPE_MONO_8000HZ_PCM16 );
    if(err<0) {
        printf("error: could not open output wavefile \"%s\"\n", output_filename);
        goto exit_fail;
    }
    
    /**** process audio sample by sample, make noise reduction ****/
    processed = 0;
    while(1) {
        /* wavefile_read_voice() returns:
         *  0 = ok
         *  1 = end of file
         * -1 = error
         */
        err = wavefile_read_voice ( iwf, &x, 1 );  /* samples=1 */
        if(err<0) {
            printf("\nerror: could not read sample from input file\n");
            break;
        }
        else if(err==1) {
            break;
        }
        /* process audio */
        у = noise_remover ( &nrm, x, 1 );  /* training=1 */
    
        /* write cleaned sound to output wavefile */
        err = wavefile_write_voice ( owf, &y, 1 ); /* samples=1 */
        if(err<0) {
            printf("\nerror: could not write sample to output file\n");
            break;
        }
        
        processed++;
        printf("\rprocessed: %lu %%", processed*100/samples);
    }
    printf("\n");
    printf("%lu samples has been processed\n", processed);
    
    /* Close input/output wave-files */
    (void) wavefile_close( owf );
    (void) wavefile_close( iwf );

    /* free memory */
    wavefile_destroy( owf );
    wavefile_destroy( iwf );

    exit(EXIT_SUCCESS);

exit_fail:
    if(owf) {
        (void) wavefile_close( owf );
        wavefile_destroy( owf );
    }
    if(iwf) {
        (void) wavefile_close( iwf );
        wavefile_destroy( iwf );
    }
    exit(EXIT_FAILURE);
}
