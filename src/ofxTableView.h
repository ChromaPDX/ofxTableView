#ifndef ofxTableView_H_INCLUDED
#define ofxTableView_H_INCLUDED


#include "ofxScrollView.h"

#include "ofxTableViewNSUtils.h"
#include "ofxTableViewCell.h"
#include "ofxTableViewController.h"
#include "ucontainer.h"

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
    
    ofRectangle            getChildRect(ofxScrollView *v);
    bool                    containsPoint(int x, int y);
    
    // @METHODS
    JAD::UniversalContainer dictionary;
    
    // DICT HELPERS
    
    void addDataSourceForCell(ofxTableViewCell *cell);
    
};



#endif // ofxTableView_H_INCLUDED
