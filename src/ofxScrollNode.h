//
//  ofxTableNode.h
//  example-ofxTableView
//
//  Created by Chroma Developer on 2/18/14.
//
//

#import "ofxSceneNode.h"

#define DEFAULT_FONT_STRING "ofxTableViewDefault.ttf"
#define DEFAULT_FONT_SIZE 16

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

@interface ofxScrollNode : ofxSpriteNode

{ // private
    
    int             state;
    
    // Touch Handliing
    
 
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

    
    bool            scrollingEnabled;
    bool            shouldRasterize;
    bool            clipToBounds;
    bool            isModal;
    
    int             verticalPadding;
    int             horizontalPadding;

    int             scrollPostion;

    
}

// INIT

-(instancetype) initWithParent:(ofxScrollNode *)parent autoSizePct:(float)autoSizePct;

@property    (nonatomic) ofTrueTypeFont *sharedFont;

// Scroll

@property    (nonatomic) bool            highlighted;
@property    (nonatomic) ScrollPhase scrollPhase;
@property   (nonatomic) float scrollPosition;
@property   (nonatomic) float autoSizePct;
@property   (nonatomic)  int displayId;
@property   (nonatomic) bool            scrollDirectionVertical;
@property   (nonatomic)   bool fdirty;
-(void) setScrollPosition:(int) offset animated:(bool) animated;

// Getter based properties
@property (nonatomic, readonly) float outOfBounds;
@property (nonatomic, readonly) float contentSize;
@property (nonatomic, readonly) bool shouldCull;

@end
