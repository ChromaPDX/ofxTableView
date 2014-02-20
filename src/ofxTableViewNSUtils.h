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

#import <Foundation/Foundation.h>
#import "ofxScrollView.h"

inline void logFrame(frame3d frame){
    NSLog(@"FRAME3D :: %f %f %f :: %f %f", frame.x, frame.y, frame.z, frame.w, frame.h);
}

inline void logRect(ofRectangle frame){
    NSLog(@"FRAME :: %f %f :: %f %f", frame.x, frame.y, frame.width, frame.height);
}

#endif
