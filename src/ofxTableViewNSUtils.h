//
//  ofxTableViewNSUtils.h
//  ChromaNSFW
//
//  Created by Leif Shackelford on 1/27/14.
//  Copyright (c) 2014 Chroma. All rights reserved.
//

#ifndef ChromaNSFW_ofxTableViewNSUtils_h
#define ChromaNSFW_ofxTableViewNSUtils_h

#pragma mark - UTILITY

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

inline void logFrame(frame3d frame){
    NSLog(@"FRAME3D :: %f %f %f :: %f %f", frame.x, frame.y, frame.z, frame.w, frame.h);
}

#endif
