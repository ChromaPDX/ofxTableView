//
//  ofxTableNode.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/18/14.
//
//

#import "ofxSceneNode.h"

typedef enum ScrollPhase {
    ScrollPhaseNil,
    ScrollPhaseBegan,
    ScrollPhaseRecognized,
    ScrollPhaseBeginFail,
    ScrollPhaseFailed,
    ScrollPhaseEnded,
    ScrollPhaseRestitution
} ScrollPhase;

typedef enum TransitionStyle {
    TransitionStyleNone,
    TransitionStyleEnterFromRight,
    TransitionStyleEnterFromLeft,
    TransitionStyleExitToLeft,
    TransitionStyleExitToRight,
    TransitionStyleZoomIn,
    TransitionStyleZoomOut,
    TransitionStyleFade
} TransitionStyle;

@interface ofxScrollNode : ofxSceneNode

{ // private
    
    int             state;
    
    // Touch Handliing
    
    bool fdirty;
    bool cdirty;
    
    int contentSize;
    // SCROLLING INTERNAL VARIABLES
    
    int restitution;
    int easeIn;
    bool easeOut;
    
    int xOrigin;
    int yOrigin;
    float scrollVel;
    float counterVel;
    float drag ;

    float _scale;
    
    float alpha;

    
    int             referenceId ;
    int             displayId;

    bool            scrollDirectionVertical;
    bool            scrollingEnabled;
    bool            shouldRasterize;
    bool            clipToBounds;
    bool            isModal;
    
    int             verticalPadding;
    int             horizontalPadding;
    
   
    
    float           autoSizePct;
    
    int             scrollPostion;

    
}

// Scroll

@property    (nonatomic) bool            highlighted;
@property    (nonatomic) ScrollPhase scrollPhase;
@property   (nonatomic) float scrollPosition;

-(void) setScrollPosition:(int) offset animated:(bool) animated;

// Getter based properties
@property (nonatomic, readonly) float outOfBounds;
@property (nonatomic, readonly) float contentSize;
@property (nonatomic, readonly) bool shouldCull;

@end
