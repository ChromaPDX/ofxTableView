//
//  ofxNodeKit.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/18/14.
//
//

#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#import "ofxNode.h"
#import "ofxSceneNode.h"
#import "ofxSpriteNode.h"
#import "ofxScrollNode.h"
#import "ofxPrimitiveNode.h"

#import "ofxNodeAnimationHandler.h"

#define debugUI 0

inline string cppString(NSString *s){
    
    return string([s cStringUsingEncoding:NSUTF8StringEncoding]);
    
}

inline ofImage imgFromUIImage(UIImage* img) {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(img.CGImage));
    
    //const UInt8 *data = CFDataGetBytePtr(pixelData);
    
    const unsigned char * buffer =  CFDataGetBytePtr(pixelData);
    
    
    ofImage ofImg;
    ofImg.allocate(img.size.width,img.size.height, OF_IMAGE_COLOR);
    ofImg.setFromPixels(buffer, img.size.width, img.size.height, OF_IMAGE_COLOR_ALPHA,true);
    
    return ofImg;
    
}

static float getScreenScale(){
    
    if (ofxiOSGetOFWindow()->isRetinaEnabled()){
        return 2.0f;
    }
    return 1.0f;
}