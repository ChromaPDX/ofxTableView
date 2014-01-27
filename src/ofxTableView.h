#ifndef ofxTableView_H_INCLUDED
#define ofxTableView_H_INCLUDED


#include "ofxScrollView.h"
#include "ofxTableViewCell.h"
#include "ofxTableViewController.h"


class ofxTableViewCell;

class   ofxTableView : public ofxScrollView
{


    
public:
    
    ofxTableView();                           //constructor
    ~ofxTableView();                          //destructor
    
    ofxTableViewCell* addCell(ofxTableViewCellStyle ncellStyle, float nheightPct);
    
    // @OVERRIDE FROM BASE CLASS
    
    void            initWithParent(ofxScrollView *parent, ofRectangle frame);

    void            draw();
    
    // @METHODS
    
    
    
    
};



#endif // ofxTableView_H_INCLUDED
