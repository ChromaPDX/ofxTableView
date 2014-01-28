//
//  ofxTableViewNSUtils.h
//  ChromaNSFW
//
//  Created by Chroma Developer on 1/27/14.
//  Copyright (c) 2014 Chroma. All rights reserved.
//

#ifndef ChromaNSFW_ofxTableViewNSUtils_h
#define ChromaNSFW_ofxTableViewNSUtils_h

#pragma mark - UTILITY

static string cppString(NSString *s){
    
    return string([s cStringUsingEncoding:NSUTF8StringEncoding]);
    
}

static ofImage imgFromUIImage(UIImage* img) {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(img.CGImage));
    
    //const UInt8 *data = CFDataGetBytePtr(pixelData);
    
    const unsigned char * buffer =  CFDataGetBytePtr(pixelData);
    
    
    ofImage ofImg;
    ofImg.allocate(img.size.width,img.size.height, OF_IMAGE_COLOR);
    ofImg.setFromPixels(buffer, img.size.width, img.size.height, OF_IMAGE_COLOR_ALPHA,true);
    
    return ofImg;
    
    
}

#endif
