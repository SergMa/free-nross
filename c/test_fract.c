/******************************************************************************/
/* TEST PROGRAMM FOR FRACT16/FRACT32 UTILITES                                 */
/* test_fract.c                                                               */
/* (c) Sergei Mashkin, 2015                                                   */
/******************************************************************************/

#include <my_fract.h>
#include <test_fract.h>
#include <stdio.h>

void test_fract16(void)
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

    return;
}

void test_fract32(void)
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

    return;
}
