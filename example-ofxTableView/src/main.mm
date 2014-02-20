#include "ofMain.h"
//#include "testApp.h"
#include "nodeTest.h"

int main(){
	ofSetupOpenGL(1024,768,OF_FULLSCREEN);			// <-------- setup the GL context

    ofxiOSGetOFWindow()->enableRetina();
    ofxiOSGetOFWindow()->enableDepthBuffer();
    ofxiOSGetOFWindow()->enableAntiAliasing(2);
	//ofRunApp(new testApp());
    ofRunApp(new nodeTest());
}
