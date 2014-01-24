#include "funcs.c"

void sqweight(double *out, double *orders, double *zone, double *offset)
{
    int ix, iy, it, px, py, pt, p;
    int x_orders, y_orders, t_orders, x_zone, y_zone, t_zone;
	float mult1, mult2, mult3, x, y, t, weight, timeoffset;
    
	x_zone = (int) zone[0];	y_zone = (int) zone[1];	t_zone = (int) zone[2];    
    x_orders = (int) orders[0];	y_orders = (int) orders[1];	t_orders = (int) orders[2];
    timeoffset = (float) offset[0];
    
    mult1 = (float) ((0.5 / sqrt( 0.5 *tan(PI/(float)ANGLES))));
	mult2 = (float) (1.0 / mult1);	mult3 = (float) MULT3;
    
    p = 0;
	for (pt = 0; pt < t_orders; pt++){
		for (py = 0; py < y_orders; py++){
			 for (px = 0; px < x_orders; px++){
				out[p] = 0.0;
				for (it = 0; it < t_zone; it++){
					t = (float) ((float)it - ((float) t_zone - 1.0)/2.0 + timeoffset);
					for (iy = 0; iy < y_zone; iy++){
						y = (float) ((float)iy - ((float) y_zone - 1.0)/2.0);
						for (ix = 0; ix < x_zone; ix++){
							x = (float) ((float)ix- ((float) x_zone - 1.0)/2.0);
							weight = ( trap_pow( x/mult1, (float) px) * trap_pow( y/mult2, (float) py)* trap_pow( mult3*t, (float) pt)) / (float)(fac(px) * fac(py)* fac(pt));
							out[p] += weight * weight;
						}
					}
				}
				++p;
			}
		}
	}
}

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    double *out, *orders, *zone, *offset;
    
    /* Check for proper number of arguments. */
    if(nrhs!=3) { mexErrMsgTxt("Three input required."); }
    else if(nlhs>1) { mexErrMsgTxt("Too many output arguments.");}
  
    if(!mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1])) { mexErrMsgTxt("Input must be a scalar double."); }
  
    orders = mxGetPr(prhs[0]);
    zone = mxGetPr(prhs[1]);
    offset = mxGetPr(prhs[2]);    

    plhs[0] = mxCreateDoubleMatrix((int)orders[0] * (int)orders[1] * (int)orders[2], 1, mxREAL);
  
    out = mxGetPr(plhs[0]);
    sqweight(out, orders, zone, offset);
}