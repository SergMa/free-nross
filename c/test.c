/******************************************************************************/
/* TEST PROGRAMM FOR NOISE REMOVER                                            */
/* test.c                                                                     */
/* (c) Sergei Mashkin, 2015                                                   */
/******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wave.h>
#include <noise_remover.h>


void usage(char * progname)
{
    printf("%s usage:\n",progname);
    printf("\t%s <wavefile1> <wavefile2>\n", progname);
    printf("\t\tprocess <wavefile1> and write result into <wavefile2>\n");
    printf("\t%s --test", progname);
    printf("\t\tmake tests for fract16,fract32 arithmetics\n");
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
    else if(argc==2 && 0==strcmp(argv[1],"--test")) {
        
        {
        float   a, b, c;
        fract16 af, bf, cf;
        int     s;

        printf("\nfract16 tests:\n");

        //ADD16
        printf("ADD16:\n");

        a = 0.5;
        b = 0.3;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = ADD16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  ADD16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = 0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = ADD16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  ADD16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = -0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = ADD16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  ADD16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        //SUB16
        printf("SUB16:\n");

        a = 0.5;
        b = 0.3;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = SUB16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  SUB16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = 0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = SUB16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  SUB16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = -0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = SUB16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  SUB16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        //MULT16
        printf("MULT16:\n");

        a = 0.5;
        b = 0.3;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MULT16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MULT16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = 0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MULT16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MULT16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = -0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MULT16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MULT16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        //ABS16
        printf("ABS16:\n");

        a = 0.5;
        af = FLOAT_TO_FRACT16(a);
        cf = ABS16(af);
        c = FRACT16_TO_FLOAT(cf);
        printf("  ABS16(%04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&cf,c);

        a = -0.5;
        af = FLOAT_TO_FRACT16(a);
        cf = ABS16(af);
        c = FRACT16_TO_FLOAT(cf);
        printf("  ABS16(%04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&cf,c);

        a = 1.0;
        af = FLOAT_TO_FRACT16(a);
        cf = ABS16(af);
        c = FRACT16_TO_FLOAT(cf);
        printf("  ABS16(%04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&cf,c);

        a = -1.0;
        af = FLOAT_TO_FRACT16(a);
        cf = ABS16(af);
        c = FRACT16_TO_FLOAT(cf);
        printf("  ABS16(%04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&cf,c);

        //NEG16
        printf("NEG16:\n");

        a = 0.5;
        af = FLOAT_TO_FRACT16(a);
        cf = NEG16(af);
        c = FRACT16_TO_FLOAT(cf);
        printf("  NEG16(%04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&cf,c);

        a = -0.5;
        af = FLOAT_TO_FRACT16(a);
        cf = NEG16(af);
        c = FRACT16_TO_FLOAT(cf);
        printf("  NEG16(%04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&cf,c);

        a = 1.0;
        af = FLOAT_TO_FRACT16(a);
        cf = NEG16(af);
        c = FRACT16_TO_FLOAT(cf);
        printf("  NEG16(%04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&cf,c);

        a = -1.0;
        af = FLOAT_TO_FRACT16(a);
        cf = NEG16(af);
        c = FRACT16_TO_FLOAT(cf);
        printf("  NEG16(%04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&cf,c);

        //ASHIFT16
        printf("ASHIFT16:\n");

        a = 0.1;
        s = +1;
        af = FLOAT_TO_FRACT16(a);
        cf = ASHIFT16(af,s);
        c = FRACT16_TO_FLOAT(cf);
        printf("  ASHIFT16(%04X/%f,%d)=%04X/%f\n", 0xFFFF&af,a, s, 0xFFFF&cf,c);

        a = 0.1;
        s = +2;
        af = FLOAT_TO_FRACT16(a);
        cf = ASHIFT16(af,s);
        c = FRACT16_TO_FLOAT(cf);
        printf("  ASHIFT16(%04X/%f,%d)=%04X/%f\n", 0xFFFF&af,a, s, 0xFFFF&cf,c);

        a = 0.1;
        s = -2;
        af = FLOAT_TO_FRACT16(a);
        cf = ASHIFT16(af,s);
        c = FRACT16_TO_FLOAT(cf);
        printf("  ASHIFT16(%04X/%f,%d)=%04X/%f\n", 0xFFFF&af,a, s, 0xFFFF&cf,c);

        //MIN16
        printf("MIN16:\n");

        a = 0.5;
        b = 0.3;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MIN16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MIN16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = 0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MIN16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MIN16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = -0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MIN16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MIN16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = 0.5;
        b = 0.5;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MIN16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MIN16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        //MAX16
        printf("MAX16:\n");

        a = 0.5;
        b = 0.3;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MAX16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MAX16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = 0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MAX16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MAX16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = -0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MAX16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MAX16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = 0.5;
        b = 0.5;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = MAX16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  MAX16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        //DIV16
        printf("DIV16:\n");

        a = 0.05;
        b = 0.2;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = DIV16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  DIV16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = 0.5;
        b = 0.8;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = DIV16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  DIV16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = -0.05;
        b = 0.2;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = DIV16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  DIV16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);

        a = -0.5;
        b = 0.8;
        af = FLOAT_TO_FRACT16(a);
        bf = FLOAT_TO_FRACT16(b);
        cf = DIV16(af,bf);
        c = FRACT16_TO_FLOAT(cf);
        printf("  DIV16(%04X/%f, %04X/%f)=%04X/%f\n", 0xFFFF&af,a, 0xFFFF&bf,b ,0xFFFF&cf,c);
        }

        {
        float   a, b, c;
        fract32 af, bf, cf;
        fract16 bf16, cf16;
        int     s;

        printf("\nfract32 tests:\n");

        //ADD32
        printf("ADD32:\n");
        
        a = 0.5;
        b = 0.3;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = ADD32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  ADD32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = 0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = ADD32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  ADD32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = -0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = ADD32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  ADD32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        //SUB32
        printf("SUB32:\n");

        a = 0.5;
        b = 0.3;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = SUB32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  SUB32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = 0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = SUB32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  SUB32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = -0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = SUB32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  SUB32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        //MULT32
        printf("MULT32:\n");

        a = 0.5;
        b = 0.3;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MULT32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MULT32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = 0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MULT32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MULT32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = -0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MULT32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MULT32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        //ABS32
        printf("ABS32:\n");

        a = 0.5;
        af = FLOAT_TO_FRACT32(a);
        cf = ABS32(af);
        c = FRACT32_TO_FLOAT(cf);
        printf("  ABS32(%08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&cf,c);

        a = -0.5;
        af = FLOAT_TO_FRACT32(a);
        cf = ABS32(af);
        c = FRACT32_TO_FLOAT(cf);
        printf("  ABS32(%08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&cf,c);

        a = 1.0;
        af = FLOAT_TO_FRACT32(a);
        cf = ABS32(af);
        c = FRACT32_TO_FLOAT(cf);
        printf("  ABS32(%08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&cf,c);

        a = -1.0;
        af = FLOAT_TO_FRACT32(a);
        cf = ABS32(af);
        c = FRACT32_TO_FLOAT(cf);
        printf("  ABS32(%08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&cf,c);

        //NEG32
        printf("NEG32:\n");

        a = 0.5;
        af = FLOAT_TO_FRACT32(a);
        cf = NEG32(af);
        c = FRACT32_TO_FLOAT(cf);
        printf("  NEG32(%08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&cf,c);

        a = -0.5;
        af = FLOAT_TO_FRACT32(a);
        cf = NEG32(af);
        c = FRACT32_TO_FLOAT(cf);
        printf("  NEG32(%08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&cf,c);

        a = 1.0;
        af = FLOAT_TO_FRACT32(a);
        cf = NEG32(af);
        c = FRACT32_TO_FLOAT(cf);
        printf("  NEG32(%08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&cf,c);

        a = -1.0;
        af = FLOAT_TO_FRACT32(a);
        cf = NEG32(af);
        c = FRACT32_TO_FLOAT(cf);
        printf("  NEG32(%08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&cf,c);

        //ASHIFT32
        printf("ASHIFT32:\n");

        a = 0.1;
        s = +1;
        af = FLOAT_TO_FRACT32(a);
        cf = ASHIFT32(af,s);
        c = FRACT32_TO_FLOAT(cf);
        printf("  ASHIFT32(%08lX/%f,%d)=%08lX/%f\n", 0xFFFFFFFF&af,a, s, 0xFFFFFFFF&cf,c);

        a = 0.1;
        s = +2;
        af = FLOAT_TO_FRACT32(a);
        cf = ASHIFT32(af,s);
        c = FRACT32_TO_FLOAT(cf);
        printf("  ASHIFT32(%08lX/%f,%d)=%08lX/%f\n", 0xFFFFFFFF&af,a, s, 0xFFFFFFFF&cf,c);

        a = 0.1;
        s = -2;
        af = FLOAT_TO_FRACT32(a);
        cf = ASHIFT32(af,s);
        c = FRACT32_TO_FLOAT(cf);
        printf("  ASHIFT32(%08lX/%f,%d)=%08lX/%f\n", 0xFFFFFFFF&af,a, s, 0xFFFFFFFF&cf,c);

        //MIN32
        printf("MIN32:\n");

        a = 0.5;
        b = 0.3;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MIN32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MIN32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = 0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MIN32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MIN32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = -0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MIN32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MIN32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = 0.5;
        b = 0.5;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MIN32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MIN32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        //MAX32
        printf("MAX32:\n");

        a = 0.5;
        b = 0.3;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MAX32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MAX32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = 0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MAX32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MAX32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = -0.5;
        b = 0.7;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MAX32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MAX32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        a = 0.5;
        b = 0.5;
        af = FLOAT_TO_FRACT32(a);
        bf = FLOAT_TO_FRACT32(b);
        cf = MAX32(af,bf);
        c = FRACT32_TO_FLOAT(cf);
        printf("  MAX32(%08lX/%f, %08lX/%f)=%08lX/%f\n", 0xFFFFFFFF&af,a, 0xFFFFFFFF&bf,b ,0xFFFFFFFF&cf,c);

        //DIV3216
        printf("DIV3216:\n");

        a = 0.05;
        b = 0.2;
        af = FLOAT_TO_FRACT32(a);
        bf16 = FLOAT_TO_FRACT16(b);
        cf16 = DIV3216(af,bf16);
        c = FRACT16_TO_FLOAT(cf16);
        printf("  DIV3216(%08lX/%f, %04X/%f)=%04X/%f\n", 0xFFFFFFFF&af,a, 0xFFFF&bf16,b ,0xFFFF&cf16,c);

        a = 0.5;
        b = 0.8;
        af = FLOAT_TO_FRACT32(a);
        bf16 = FLOAT_TO_FRACT16(b);
        cf16 = DIV3216(af,bf16);
        c = FRACT16_TO_FLOAT(cf16);
        printf("  DIV3216(%08lX/%f, %04X/%f)=%04X/%f\n", 0xFFFFFFFF&af,a, 0xFFFF&bf16,b ,0xFFFF&cf16,c);

        a = -0.05;
        b = 0.2;
        af = FLOAT_TO_FRACT32(a);
        bf16 = FLOAT_TO_FRACT16(b);
        cf16 = DIV3216(af,bf16);
        c = FRACT16_TO_FLOAT(cf16);
        printf("  DIV3216(%08lX/%f, %04X/%f)=%04X/%f\n", 0xFFFFFFFF&af,a, 0xFFFF&bf16,b ,0xFFFF&cf16,c);

        a = -0.5;
        b = 0.8;
        af = FLOAT_TO_FRACT32(a);
        bf16 = FLOAT_TO_FRACT16(b);
        cf16 = DIV3216(af,bf16);
        c = FRACT16_TO_FLOAT(cf16);
        printf("  DIV3216(%08lX/%f, %04X/%f)=%04X/%f\n", 0xFFFFFFFF&af,a, 0xFFFF&bf16,b ,0xFFFF&cf16,c);
        }
        
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
    printf("filesize : %u bytes\n", wavefile_get_bytes  ( iwf ) );
    printf("length   : %u sec\n",   wavefile_get_seconds( iwf ) );
    samples = wavefile_get_samples( iwf );
    printf("samples  : %u\n", samples );
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
        y = noise_remover ( &nrm, x, 1 );  /* training=1 */

        /* write cleaned sound to output wavefile */
        err = wavefile_write_voice ( owf, &y, 1 ); /* samples=1 */
        if(err<0) {
            printf("\nerror: could not write sample to output file\n");
            break;
        }
        
        processed++;
        printf("\rprocessed: %u %%", processed*100/samples);
    }
    printf("\n");
    printf("%u samples has been processed\n", processed);
    
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
