/*
 * microsoft surface 2.0 open source driver 0.0.1
 *
 * Copyright (c) 2012 by Florian Echtler <floe@butterbrot.org>
 * Licensed under GNU General Public License (GPL) v2 or later
 *
 * this is so experimental that the warranty shot itself.
 * so don't expect any.
 *
 */

#include "surface.h"

#include <stdlib.h> // random() etc.
#include <string.h> // strlen() etc.
#include <sstream>
#include <stdio.h>  // printf() etc.
#include <time.h>   // time()
#include <math.h>   // fabsf()

using namespace std;

#include <unistd.h> // fcntl()
#include <fcntl.h>

#include <opencv/cv.h>
//#include <opencv/cvaux.h>
#include <opencv/highgui.h>  
#include <opencv/cxcore.h>

#include <oscpack/osc/OscOutboundPacketStream.h>
#include <oscpack/ip/UdpSocket.h>


#define ADDRESS "127.0.0.1"
#define PORT 57120

#define OUTPUT_BUFFER_SIZE 1024



usb_dev_handle* s40;



int thresh = 50;
IplImage* img = 0;
IplImage* img0 = 0;
CvMemStorage* storage = 0;

UdpTransmitSocket transmitSocket( IpEndpointName( ADDRESS, PORT ) );
char buffer[OUTPUT_BUFFER_SIZE];

CvSeq* contours;
CvSeq* result;
CvSize sz;

int findSquares4( IplImage* img, CvMemStorage* storage )
{
    sz = cvSize( img->width & -2, img->height & -2 );
    IplImage* timg = cvCloneImage( img ); // make a copy of input image
    IplImage* gray = cvCreateImage( sz, 8, 1 );
    IplImage* gray2 = cvCreateImage( sz, 8, 1 );
    IplImage* pyr = cvCreateImage( cvSize(sz.width/2, sz.height/2), 8, 1 );

    // select the maximum ROI in the image
    // with the width and height divisible by 2
    cvSetImageROI( timg, cvRect( 0, 0, sz.width, sz.height ));

    // down-scale and upscale the image to filter out the noise
    cvPyrDown( timg, pyr, 7 );
    cvPyrUp( pyr, timg, 7 );

    // apply Canny. Take the upper threshold from slider
    // and set the lower to 0 (which forces edges merging)
    cvCanny( timg, gray, 0, thresh, 5 );
    // dilate canny output to remove potential
    // holes between edge segments
    cvDilate( gray, gray, 0, 1 );


    // find contours and store them all as a list
    cvFindContours( gray, storage, &contours, sizeof(CvContour), CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0) );

	int ii = 0;

	//cout << outStream.str() << endl;
	osc::OutboundPacketStream p( buffer, OUTPUT_BUFFER_SIZE ); 
	p << osc::BeginBundleImmediate << osc::BeginMessage( "/polygons" );

	while(contours) {
		ostringstream outStream;

        result = cvApproxPoly( contours, sizeof(CvContour), storage,
            CV_POLY_APPROX_DP, cvContourPerimeter(contours)*0.02, 0 );

		if(fabs(cvContourArea(result,CV_WHOLE_SEQ)) > 500) {
			ii++;
			CvPoint* firstp = (CvPoint*)cvGetSeqElem( result, 0 );
			CvPoint* lastp = (CvPoint*)cvGetSeqElem( result, 0 );

			printf("Contour: %u %u: ", ii, result->total);
			outStream << result->total << ":";

			printf("%u %u   ", firstp->x, firstp->y);
			outStream << firstp->x << "/" << firstp->y << ",";

			for(int iii=1; iii<result->total; iii++) {
				CvPoint* p = (CvPoint*)cvGetSeqElem( result, iii );
				printf("%u %u   ", p->x, p->y);
				outStream << p->x << "/" << p->y << ",";

				if(iii>1) {
					cvLine(gray2, cvPoint(lastp->x, lastp->y), cvPoint(p->x, p->y), cvScalar(100,100,100), 1);
					lastp = p;
				}
			}

			cvLine(gray2, cvPoint(lastp->x, lastp->y), cvPoint(firstp->x, firstp->y), cvScalar(100,100,100), 1);

			printf("\n");
			string s = outStream.str();
			s = s.substr(0, s.size()-1);

  			printf("%s\n", s.c_str());
			p << s.c_str();
		}
		contours = contours->h_next;
	}

	p << "END" << osc::EndMessage << osc::EndBundle;
	transmitSocket.Send( p.Data(), p.Size() );




	printf("----------------------\n");

	cvShowImage( "Polygons", gray2 );

    // release all the temporary images
    cvReleaseImage( &gray );
    cvReleaseImage( &gray2 );
    cvReleaseImage( &pyr );
    cvReleaseImage( &timg );

    return 0;
}


/******************************* MAIN *******************************/

int main(int argc, char* argv[]) {
    
	s40 = usb_get_device_handle( ID_MICROSOFT, ID_SURFACE );
	surface_init( s40 );

	uint8_t surface_img[VIDEO_BUFFER_SIZE]; //518400

	// create a window
	cvNamedWindow("Black/White", CV_WINDOW_AUTOSIZE); 
	cvMoveWindow("Black/White", 100, 100);

	cvNamedWindow("Polygons", CV_WINDOW_AUTOSIZE); 
	cvMoveWindow("Polygons", 1100, 100);

	IplImage* img_gray = cvCreateImage(cvSize(960,540),IPL_DEPTH_8U,1);
	IplImage* img_bw = cvCreateImage(cvGetSize(img_gray),IPL_DEPTH_8U,1);

	while(true) {
		surface_get_image( s40, surface_img );
		
		cvSetData( img_gray , surface_img , 960);

		cvThreshold(img_gray, img_bw, 150, 255, CV_THRESH_BINARY);


		storage = cvCreateMemStorage(0);
		img = cvCloneImage( img_bw );

	    cvShowImage( "Black/White", img );

		findSquares4( img, storage );

		cvReleaseMemStorage(&storage);
		cvReleaseImage( &img );

		// wait for a key
		int key = cvWaitKey(500);
		if(key == 113) {
			usb_close( s40 );
			return 0;
		}
	}
}


