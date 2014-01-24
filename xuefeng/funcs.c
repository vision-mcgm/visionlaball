#include "model.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "mex.h"

float trap_pow(float a, float b)
{
	if (b == 0.0)
		return 1.0;
	if (a == 0.0)
		return 0.0;

	return (float) pow(a, b);
}

int fac(int n)
{
	int i, retval = 1;

	if (n == 0 || n == 1)
		return 1;

	for (i = 2; i <= n; ++i)
		retval *= i;

	return retval;
}

int AllocImage(IMAGE *image, unsigned int cols, unsigned int rows, unsigned int numimages)
{
	image->im = (float *) malloc(sizeof(float) * cols * rows * numimages);
	if (image->im == NULL)
		return 2;
	image->cols = cols;
	image->rows = rows;
    image->numimages = numimages;

	return 0;
}

void CPBCopyImage(COMPLEXARRAY *out, IMAGE in)
{
	UINT i, j;
	float *tmp;
	tmp = in.im;

	for (i = 0; i < out->cols; ++i) {
		for (j = 0; j < out->rows; ++j) {
			out->hReal[i*out->rows + j] = (double) *tmp++;
		}
	}
}

int comb(int num, int c)
{
		return fac(num) / (fac(num - c) * fac(c));
}

CPBCOLOUR *SetRGBfromAngle(double angle)
{
	static CPBCOLOUR col;
	double r, g, b, y, biggest;

	angle -= 90.0;

	/* scales angle between 0 and 360 */
	while (angle < -180)
		angle += 360;
	while (angle >= 180)
		angle -= 360;

	angle += 180;

	while (angle > 360)
		angle -= 360;

	if (angle >= 0 && angle < 90) {
		r = (angle / 90.0);
		y = ((90.0 - angle) / 90.0);
		b = 0.0;
		g = 0.0;
	}
	else if (angle >= 90 && angle < 180) {
		r = ((180.0 - angle) / 90.0);
		y = 0.0;
		b = ((angle - 90.0) / 90.0);
		g = 0.0;

	}
	else if (angle >= 180 && angle < 270) {
		r = 0.0;
		y = 0.0;
		b = ((270.0 - angle) / 90.0);
		g = ((angle - 180.0) / 90.0);
	}
	else if (angle >= 270) {
		r = 0.0;
		y = ((angle - 270.0) / 90.0);
		b = 0.0;
		g = ((360.0 - angle) / 90.0);
	}

	if (y > 0.0) {
		if (r > g && r > b)
			biggest = r;
		else
			biggest = g;
		y *= (1.0 - biggest);
		r += y;
		g += y;
	}

	col.red = (255.0 * r);
	col.green = (255.0 * g);
	col.blue = (255.0 * b);

	return &col;
}

double test_angle(double x, double y)
{
	double retval;

	if (x == 0 && y == 0) {
		retval = 0.0;
	}
	else {
		retval = (180.0 / PI) * atan2(y, x);
	}


	while (retval >= 360.0)
		retval -= 360.0;
	while (retval < 0.0)
		retval += 360.0;

	return retval;
}

float *col_convolve(IMAGE out, COMPLEXARRAY filters, unsigned int n, COMPLEXARRAY im)
{
	UINT i, j, p;
	float *tmp;
	tmp = out.im;
    
	for (i = 0; i < out.cols; ++i) {
		for (j = 0; j < out.rows; ++j) {
			*tmp = 0.0;
			for (p = 0; p < filters.rows; ++p) {
				*tmp += (float) (im.hReal[(i + p)*im.rows + j] * filters.hReal[n*filters.rows + p]);
			}
			++tmp;
		}
	}
	return tmp;
}

void row_convolve(IMAGE out, COMPLEXARRAY filters, unsigned int n, IMAGE in)
{
	UINT i, j, p;
	float *tmp_in, *tmp_out;

	tmp_out = out.im;

	for (i = 0; i < out.cols; ++i) {
		tmp_in = in.im + (i * in.rows);
		for (j = 0; j < out.rows; ++j) {
			*tmp_out = 0.0;
			for (p = 0; p < filters.rows; ++p) {
				*tmp_out += (float) (*(tmp_in + p) * filters.hReal[n*filters.rows + p]);
			}
			++tmp_out;
			++tmp_in;
		}
	}
}

int getsize(unsigned int *c, unsigned int *r)
{
	FILE *fptr;

// 	if (state == 1) {
// 		if (imcols > 0 && imrows > 0) {
// 			*c = imcols;
// 			*r = imrows;
// 			return 0;
// 		}
// 		else {
// 			return 9;
// 		}
// 	}
// 	else {
		if ((fptr = fopen(BASISFILE, "rb")) == NULL) {
			return 5;
		}

		/* number of spatial filters used to generate basis set */
		if (fread((void *) c, sizeof(unsigned int), 1, fptr) != 1)
			return 5;
		/* number of col in each filter output */
		if (fread((void *) c, sizeof(unsigned int), 1, fptr) != 1)
			return 5;
		/* number of rows in each filter output */
		if (fread((void *) r, sizeof(unsigned int), 1, fptr) != 1)
			return 5;

		fclose(fptr);
// 	}

	return 0;
}