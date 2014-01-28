
#include "ofxTableViewController.h"
#include "ofxTableView.h"


ofxTableViewController:: ofxTableViewController()//constructor
{
    initialize();
}

ofxTableViewController::~ ofxTableViewController()//destructor
{
}

void  ofxTableViewController::update(){
    
    for (int i = 0; i < tableViews.size(); i++) {
        tableViews[i]->update();
    }
    
    
}

void     ofxTableViewController::initialize()
{
    
    isHidden = false;
    hideKey = 'h';
    keysWhileHidden = true;
    
    isTypingBlocked = false;
    
    ofxMultiTouch.addListener(this);
    
    //ofMouseEvents.addListener(this);
	//ofKeyEvents.addListener(this);
    
	//ofAppEvents.addListener(this);
    //PanelList = new ofxTableView[5];
}

ofxTableView*    ofxTableViewController::addTableView(int x,int y,int w, int h)
{
    ofxTableView* tableView = new ofxTableView;
    
    tableView->initWithParent(0, ofRectangle(x,y,w,h));
    
    tableViews.push_back(tableView);
    
    return tableView;
}



void     ofxTableViewController::draw()
{
    if (isHidden == false)
    {
        for (int i = 0; i <  tableViews.size(); i++ )
        {
            tableViews[i]->draw();
        }
    }
}

void     ofxTableViewController::hide()
{
    isHidden = true;
    isTypingBlocked = true;
    
}

void     ofxTableViewController::unHide()
{
    isHidden = false;
    isTypingBlocked = false;
}


void  ofxTableViewController::touchMoved(float x, float y, int touchId){
    if (touchId == 0){
        if (isHidden == false)
        {
            
            
            
            for (int i = 0; i <  tableViews.size(); i++ )
            {
                if (  tableViews[i]->containsPoint(x,y) == true)
                {
                   // NSLog(@"touch moved! %f %f %d", x,y,touchId);
                    
                    tableViews[i]->touchMoved(x,y,touchId);
                }
                else
                {
                    
                }
            }
        }
    }
}

void     ofxTableViewController::touchDown(float x, float y, int touchId){
    
    if (touchId == 0){
        if (isHidden == false)
        {
            
            
            for (int i = 0; i <  tableViews.size(); i++ )
            {
                if (  tableViews[i]->containsPoint(x,y) == true)
                {
                    
                    tableViews[i]->touchDown(x,y,touchId);
                }
                
                
            }//end panel size.
        }
    }
}

void  ofxTableViewController::touchUp(float x, float y, int touchId){
    if (touchId == 0){
        if (isHidden == false)
        {
            
            for (int i = 0; i <  tableViews.size(); i++ )
            {
                tableViews[i]->touchUp(x, y, touchId);
            }
        }
    }
}

void  ofxTableViewController::touchDoubleTap(float x, float y, int touchId){
    
}



void  ofxTableViewController::setHideKey(int key)
{
    hideKey = key;
}


//bool    ofxTableViewController::isSafeToType()
//{
//    bool keypressOK = true;
//    for (int i = 0; i <  tableViews.size(); i++ )
//    {
//        for (int j = 0; j <  tableViews[i]->elements.size(); j++ )
//        {
//            if (  tableViews[i]->elements[j]->checkType() == "TEXTFIELD")
//            {
//                if(  tableViews[i]->elements[j]->keyPressOK() == false)
//                {
//                    keypressOK = false;
//                }
//            }
//        }
//    }
//    return keypressOK;
//}

bool       ofxTableViewController::isGuiHidden()
{
    return isHidden;
}



void         ofxTableViewController::disableKeys()
{
    isTypingBlocked = true;
}
void         ofxTableViewController::enableKeys()
{
    isTypingBlocked = false;
}


