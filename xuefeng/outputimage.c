#include "funcs.c"

void outputimage(double *out, double *in, mwSize mrows, mwSize ncols, mwSize iborder)
{
    mwSize i, j, offset, rim, imlength, imwidth, inshift;
	double angle, y, x, blurmax, blurmin, velmax, val;
	CPBCOLOUR *colptr;
    
    imlength = (ncols / 3) + iborder;
	imwidth = mrows + iborder;

	inshift = (mwSize) (ncols / 3);
    offset = iborder / 2;
	rim = (7 * offset) / 8;
    
    // get max and min values so can scale
	 blurmax = blurmin = velmax = 0;
	 for (i = 0; i < ncols / 3; ++i) {
        for (j = 0; j < mrows; ++j) {
			if (blurmax < in[i*mrows + j])
                blurmax = in[i*mrows + j];
			if (blurmin > in[i*mrows + j])
                blurmin = in[i*mrows + j];
			if (velmax < in[(i + inshift)*mrows + j])
				velmax = in[(i + inshift)*mrows + j];
		}
	}

     for (i = 0; i < imlength; ++i) {
		for (j = 0; j < imwidth; ++j) {
			/* if is in central portion */
			if (i >= offset && i < imlength - offset
			&& j >= offset && j < imwidth - offset) {
				val = 255 * (in[(i - offset)*mrows + j - offset] - blurmin) / (blurmax - blurmin);
				out[i*imwidth + j] = val;
				out[((imlength * 3) + i)*imwidth + j] = val;
				out[((imlength * 6) + i)*imwidth + j] = val;
				val = 255 * in[(inshift + i - offset)*mrows + j - offset] / velmax;
				out[(imlength + i)*imwidth + j] = val;
				out[((imlength * 4) + i)*imwidth + j] = val;
				out[((imlength * 7) + i)*imwidth + j] = val;
			}
			else {
				out[i*imwidth + j] = 128;
				out[((imlength * 3) + i)*imwidth + j] = 128;
				out[((imlength * 6) + i)*imwidth + j] = 128;
				out[(imlength + i)*imwidth + j] = 0;
				out[((imlength * 4) + i)*imwidth + j] = 0;
				out[((imlength * 7) + i)*imwidth + j] = 128;
			}
		}
	}
     
     for (i = 0; i < imlength; ++i) {
		for (j = 0; j < imwidth; ++j) {
			/* if is in central portion */
			if (i >= offset && i < imlength - offset
			&& j >= offset && j < imwidth - offset) {
				if (in[(inshift + i - offset)*mrows + j - offset] < VELMIN) {
					out[((imlength * 2) + i)*imwidth + j] = 0;
					out[((imlength * 5) + i)*imwidth + j] = 0;
					out[((imlength * 8) + i)*imwidth + j] = 0;
				}
				else {
					colptr = SetRGBfromAngle(180.0 - in[((2 * inshift) + i - offset)*mrows + j - offset]);
					out[((imlength * 2) + i)*imwidth + j] = colptr->red;
					out[((imlength * 5) + i)*imwidth + j] = colptr->green;
					out[((imlength * 8) + i)*imwidth + j] = colptr->blue;
				}
			}
			else if (i < rim || i >= imlength - rim
			|| j < rim || j >= imwidth - rim) {
				y = 0.0001 + (double) i - ((double) imlength / 2.0);
				x = 0.0001 + (double) j - ((double) imwidth / 2.0);
				angle = 180 + ((180.0 / PI) * atan2(x, y));
				colptr = SetRGBfromAngle(angle);
				out[((imlength * 2) + i)*imwidth + j] = colptr->red;
				out[((imlength * 5) + i)*imwidth + j] = colptr->green;
				out[((imlength * 8) + i)*imwidth + j] = colptr->blue;
			}
			else {
				out[((imlength * 2) + i)*imwidth + j] = 128;
				out[((imlength * 5) + i)*imwidth + j] = 128;
				out[((imlength * 8) + i)*imwidth + j] = 128;
			}
		}
	}     
}
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    mwSize mrows, ncols, iborder;
    double *out, *in, *border;
    
    /* Check for proper number of arguments. */
    if(nrhs!=2) { mexErrMsgTxt("Two inputs required."); }
    else if(nlhs>1) { mexErrMsgTxt("Too many output arguments.");}
    if(!mxIsDouble(prhs[0])) { mexErrMsgTxt("Input must be a scalar double."); }

    mrows = mxGetM(prhs[0]);
    ncols = mxGetN(prhs[0]);    
    in = mxGetPr(prhs[0]); border = mxGetPr(prhs[1]);
    
    iborder = (mwSize) ((border[0] < 0.0) ? 0 : border[0]);
    
    plhs[0] = mxCreateDoubleMatrix((mrows + iborder), (ncols/3 + iborder)*9, mxREAL);

    out = mxGetPr(plhs[0]);
    outputimage(out, in, mrows, ncols, iborder);
}