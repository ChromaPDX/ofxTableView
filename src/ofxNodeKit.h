//
//  ofxNodeKit.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/18/14.
//
//

#import "ofxNode.h"
#import "ofxSceneNode.h"
#import "ofxSpriteNode.h"
#import "ofxScrollNode.h"

#import "ofxNodeAnimationHandler.h"

#define debugUI 1

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