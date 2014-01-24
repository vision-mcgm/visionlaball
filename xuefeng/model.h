#define BASISFILE "c:\\model\\basis.bin"
#define INFILE "c:\\model\\input.bin"

#define NUM_TEMPORAL 3
#define ANGLES 24
#define MULT3 12.0
#define SPEED_MEASURES 4
#define DEFLENGTH 128
#define DEFWIDTH 128
#define DEFFRAMES 128

#define PI 3.14159265

#define CHAR_OUTPUT 1
#define INT_OUTPUT 2
#define FLOAT_OUTPUT 4
#define DOUBLE_OUTPUT 8

#define JUSTUNDERHALF 0.4999999
#define ZERO 0.0

#define VELMIN 0.00001

#define deffabs(x) ((x < 0.0) ? -x : x)
#define defdiv(a,b,t) (((deffabs(a) <= (t)) || (deffabs(b) <= (t))) ? 0.0 : (a) / (b))
#define deffilterthreshold(x, t) ((deffabs(x) <= (t)) ? 0.0 : (x))
#define frand() (((float) rand()) / ((float) RAND_MAX))
#define flipcoin() ((rand() > RAND_MAX / 2) ? 0 : 1)
#define square(x) (x * x)

typedef signed char SCHAR;
typedef unsigned char UCHAR;
typedef signed int SINT;
typedef unsigned int UINT;

typedef struct {
	UINT cols;
	UINT rows;
	UINT numimages;
	float *im;
} IMAGE;

typedef struct {
    UINT rows;
    UINT cols;
    double *hReal; 
} COMPLEXARRAY;

typedef struct {
	double red;
	double green;
	double blue;
} CPBCOLOUR;

typedef struct {
	char id[2];
	UCHAR headersize;
	UINT rows;
	UINT cols;
	UINT frames;
	UCHAR type;
	float max;
	float min;
	UINT offset;
} MODELINPUTHEADER;