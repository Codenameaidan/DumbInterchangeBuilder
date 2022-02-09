//Dumb Interchange Builder
//Created by Aidan J. Walsh

//List of all roads
ArrayList<Road> roads = new ArrayList<Road>(); 

//UI Buttons (x,y coordinates, width, height)
Button[] globalButtons = 
{
 new Button(10,150,85,40, 0),
 new Button(105,150,85,40, 1),
 new Button(10,200,180,40, 2)
};

//Buttons for when user clicks a point (x,y coordinates, width, height)
Button[] nodeButtons = 
{
 new Button(150,283,20,20, 0),
 new Button(150,308,20,20, 1),
 new Button(100,350,20,20, 2),
 new Button(100,375,20,20, 3),
 new Button(10,600,180,40, 4),
 new Button(10,450,180,40, 5),
 new Button(10,500,180,40, 6),
 new Button(10,400, 80, 30, 7),
 new Button(100,400, 80, 30, 8)
 
};

//User options
boolean showNodes = true;
int selectedBackground = 1;
int selectedColor = 1;

//Colors
color[] backgrounds = {#006400, #e8e8e8, #242424};
color[] roadBacks =   {#363636, #ed9039, #4a0714, #4f4f4f};
color[] roadFronts =  {#808080, #ffdb59, #de8395, #f7f7f7};

//UI colors
final color leftAddColor = #cc9600;
final color rightAddColor = #c9005b;

//Road data
final int elevationAdd = 20; //Always add this elevation amount to every road
final int roadSize = 20; //Starting road size

//Current node/road info
boolean isNodeBeingMoved = false; 
Point selectedNode = null;
Road selectedRoad;

void setup(){
  size(1000,800, P3D);
}

void draw(){
  background(backgrounds[selectedBackground]);
  displayAllRoads();
  if(showNodes){
    displayAllNodes();
  }
  displayUI();
}

void displayUI(){
  //UI box background
  fill(215);
  noStroke();
  rect(0,0,200,displayHeight);
  fill(40);
  rect(200,0,10,displayHeight);
  rect(0,250,200,10);
  
  //Title
  textSize(32);
  text("Dumb\nInterchange\nBuilder",5,30);
  
  //Colors
  textSize(13);
  fill(150);
  rect(globalButtons[0].x, globalButtons[0].y, globalButtons[0].w, globalButtons[0].h);
  rect(globalButtons[1].x, globalButtons[1].y, globalButtons[1].w, globalButtons[1].h);
  fill(0);
  text("Background", 15,180);
  text("Road Color", 110,180);
  
  //Show/Hide nodes
  textSize(23);
  fill(150);
  rect(globalButtons[2].x, globalButtons[2].y, globalButtons[2].w, globalButtons[2].h); 
  fill(0);
  if(showNodes)
    text("Hide Nodes", 15,230);
  else
    text("Show Nodes", 15,230);
  
  //Node stuff
  if(selectedNode != null){ //A point is selected
    fill(0,0,255);
    for(int i = 0;i<4;i++){
      rect(nodeButtons[i].x, nodeButtons[i].y, nodeButtons[i].w, nodeButtons[i].h );
    }
    //Node info
    text("(x,y)="+selectedNode.x+","+selectedNode.y+"\nElevation:"+(selectedNode.elevation+elevationAdd)+"\n\nSize:"+selectedRoad.size,0,280); 
    
    fill(255);
    
    //elevation
    text("+",nodeButtons[0].x+1, nodeButtons[0].y+17);
    text("-",nodeButtons[1].x+3, nodeButtons[1].y+17);
    
    //size
    text("+",nodeButtons[2].x+1, nodeButtons[2].y+17);
    text("-",nodeButtons[3].x+3, nodeButtons[3].y+17);
     
    //Add/move left
    fill(leftAddColor);
    rect(nodeButtons[5].x, nodeButtons[5].y, nodeButtons[5].w, nodeButtons[5].h);
    rect(nodeButtons[7].x, nodeButtons[7].y, nodeButtons[7].w, nodeButtons[7].h);
    fill(255);
    text("Add Node(L)", nodeButtons[5].x+20, nodeButtons[5].y+27);
     
    //Add/move right
    fill(rightAddColor);
    rect(nodeButtons[6].x, nodeButtons[6].y, nodeButtons[6].w, nodeButtons[6].h);
    rect(nodeButtons[8].x, nodeButtons[8].y, nodeButtons[8].w, nodeButtons[8].h);
    fill(255);
    text("Add Node(R)", nodeButtons[6].x+20, nodeButtons[6].y+27);
    
    text("<",nodeButtons[7].x+20, nodeButtons[7].y+20);
    text(">",nodeButtons[8].x+20, nodeButtons[8].y+20);
    
    //Delete
    fill(255,0,0);
    rect(nodeButtons[4].x, nodeButtons[4].y, nodeButtons[4].w, nodeButtons[4].h);
    fill(255);
    text("Delete Node", nodeButtons[4].x+20, nodeButtons[4].y+27);
    
    //Display selected node (with lines)!
    fill(0,0,255);
    stroke(0,0,255);
    strokeWeight(3);
    ellipse(selectedNode.x, selectedNode.y,30,30);
    
    //Highlight node in draw menu
    int index = selectedRoad.points.indexOf(selectedNode);
    noStroke();
    fill(leftAddColor);
    if(index > 0){ //If there is a node to the left...
      Point prevPoint = selectedRoad.points.get(index-1);
      ellipse(prevPoint.x, prevPoint.y,30,30);
      
      stroke(leftAddColor);
      strokeWeight(2);
      line(selectedNode.x,selectedNode.y, prevPoint.x, prevPoint.y);  
    }else{ //No node to left
      strokeWeight(5);
      ellipse(selectedNode.x, selectedNode.y,40,40);
    }
    noStroke();
    fill(rightAddColor);
    if(index < selectedRoad.points.size()-1){ //If there is a node to the right...
      Point prevPoint = selectedRoad.points.get(index+1);
      ellipse(prevPoint.x, prevPoint.y,30,30);
      
      stroke(rightAddColor);
      strokeWeight(2);
      line(selectedNode.x,selectedNode.y, prevPoint.x, prevPoint.y);
    }else{ //No node to right
      strokeWeight(5);
      ellipse(selectedNode.x, selectedNode.y,40,40);
    }
    
  }else{ //If no node highlighted
    text("(Drag to\ncreate a road!)",0,280);
  }
  
}

//Called when user preses non node-specific button...
void pressGlobalButton(int buttonNum){
 if(buttonNum == 0) //Change background color
 {
   if(selectedBackground == backgrounds.length-1)
     selectedBackground = 0;
   else
     selectedBackground ++;
     
 }else if(buttonNum == 1){ //Change road color
   if(selectedColor == roadBacks.length-1)
     selectedColor = 0;
   else
     selectedColor ++;
     
 }else if(buttonNum == 2){ //Show/hide nodes
  showNodes = !showNodes; 
  isNodeBeingMoved = false;
  selectedNode = null;
 }
  
}

//Called when user presses a button on a specific node
void pressNodeButton(int buttonNum){
 if(selectedNode == null) return; //If no node actually selected
 
 if(buttonNum == 0){ //Increase elevation
   selectedNode.elevation += 1; 
 }
 else if(buttonNum == 1){ //Decrease elevation
   selectedNode.elevation -= 1; 
 }
 else if(buttonNum == 2){ //Increase size
  selectedRoad.size+=1;
 }
 else if(buttonNum == 3){ //Decrease size
  selectedRoad.size-=1;
 }
 else if(buttonNum == 4){ //Delete node
  selectedRoad.points.remove(selectedNode); 
  isNodeBeingMoved = false;
  selectedNode = null;
  if(selectedRoad.points.size() == 0){ //If deleting last node in a road, delete the road too
     roads.remove(selectedRoad); 
  }
 }else if(buttonNum == 5){ //Add node to the left
   int index = selectedRoad.points.indexOf(selectedNode);
   if(index == 0){
     selectedRoad.points.add(index, new Point(selectedNode.x-20,selectedNode.y, selectedNode.elevation));
   }
   else{
     Point p = selectedRoad.points.get(index-1);
     selectedRoad.points.add(index, new Point((p.x+selectedNode.x)/2,(p.y+selectedNode.y)/2, selectedNode.elevation));
   }
 }else if(buttonNum == 6){ //Add node to the right
   int index = selectedRoad.points.indexOf(selectedNode);
   if(index == selectedRoad.points.size()-1){
     selectedRoad.points.add(new Point(selectedNode.x-20,selectedNode.y, selectedNode.elevation));
   }else{
     Point p = selectedRoad.points.get(index+1);
     selectedRoad.points.add(index+1, new Point((p.x+selectedNode.x)/2,(p.y+selectedNode.y)/2, selectedNode.elevation));
   }
 }else if(buttonNum == 7){ //move left
   int index = selectedRoad.points.indexOf(selectedNode);
   if(index != 0){
     selectedNode = selectedRoad.points.get(index - 1);
   }
 }else if(buttonNum == 8){ //move right
   int index = selectedRoad.points.indexOf(selectedNode);
   if(index != selectedRoad.points.size()-1){
     selectedNode = selectedRoad.points.get(index + 1);
   }
 }
  
}

//Key shortcuts for button presses
void keyPressed() {
  if(selectedNode != null){
    if (key == DELETE) pressNodeButton(4);
    else if(key == 'l') pressNodeButton(5);
    else if(key == 'r') pressNodeButton(6);
    else if(keyCode == LEFT) pressNodeButton(7);
    else if(keyCode == RIGHT) pressNodeButton (8);
  }
}

//
void mousePressed() {
  if(overRect(0,0,200,displayHeight)){ //If in 'UI' part of the screen (on the left...)
    for(int x = 0;x<globalButtons.length;x++){ //Iterate over global buttons, see if they clicked one of those
      if(overRect(globalButtons[x].x,globalButtons[x].y,globalButtons[x].w,globalButtons[x].h)){
        pressGlobalButton(globalButtons[x].function); //If over button, 'press' button
        return;
      }
    }
    
    for(int x = 0;x<nodeButtons.length;x++) //Iterate over node buttons, see if one of those was clicked
    {
      if(overRect(nodeButtons[x].x,nodeButtons[x].y,nodeButtons[x].w,nodeButtons[x].h)){
        pressNodeButton(nodeButtons[x].function); //'press' button
        return;
      }
    }
    return;
  }
  for(int j = 0; j < roads.size(); j++){ //Iterate over roads
    Road oneRoad = roads.get(j);
    for(int i = 0; i < oneRoad.points.size(); i++){ //Iterate over points in road
      if(overCircle(oneRoad.points.get(i).x, oneRoad.points.get(i).y, 30)){ //See if mouse is over any nodes
        isNodeBeingMoved = true;
        selectedNode = oneRoad.points.get(i);
        selectedRoad = oneRoad;
        return;
      }
     
    }
    
  }

  if(selectedNode == null){ //If no node selected... create new road!
    Road temp = new Road(roadSize);
    
    //Start with 2 points, select the 2nd point
    Point tempPoint = new Point(mouseX,mouseY,-elevationAdd);
    Point tempPoint2 = new Point(mouseX,mouseY,-elevationAdd);
    temp.points.add(tempPoint);
    temp.points.add(tempPoint2);
    roads.add(temp);
    isNodeBeingMoved = true;
    selectedNode = tempPoint2;
    selectedRoad = temp;
  }else{ //Deselect road
    selectedNode = null;
  }
  
}

//Mouse being dragged...
void mouseDragged(){
  if(isNodeBeingMoved){ //Are we moving a node?
    //Keep within bounds of screen and x > 200 (to avoid UI)
    if(mouseX > 200 && mouseX < width){
      selectedNode.x = mouseX;
    }
    if(mouseY > 0 && mouseY < height){
      selectedNode.y = mouseY;
    }
  }
}

//When mouse releases, stop moving node
void mouseReleased(){
  isNodeBeingMoved = false;
}

//Check if mouse is over circle with given coordinates
boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

//Check if mouse is over rectangle with given coordinates
boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}


void displayAllRoads()
{
  for(int i = 0; i < roads.size(); i++){
    roads.get(i).displayBack();
  }
  for(int i = 0; i < roads.size(); i++){
    roads.get(i).displayFront();
  }
}

void displayAllNodes(){
  for(int i = 0; i < roads.size(); i++){
    roads.get(i).displayNodes();
  }
}


class Button
{
  int x,y,w,h, function;
  Button(int x, int y, int w, int h, int function){
   this.x = x;
   this.y = y;
   this.w = w;
   this.h = h;
   this.function = function;
  }
  
}

class Road
{
  ArrayList<Point> points;
  int size;
  public Road(int size){
    this.size =size;
    this.points = new ArrayList<Point>();
  }
  
  //Displays the 'back' color part of this road
  void displayBack()
  {
    noFill();
    strokeWeight(size);
    stroke(roadBacks[selectedColor]);
    beginShape();
    curveVertex(points.get(0).x, points.get(0).y, points.get(0).elevation);
    curveVertex(points.get(0).x, points.get(0).y, points.get(0).elevation);
    
    for(int i = 1; i < points.size()-1; i++){
      curveVertex(points.get(i).x, points.get(i).y, points.get(i).elevation);
    }
    
    curveVertex(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(points.size()-1).elevation);
    curveVertex(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(points.size()-1).elevation);
    
    endShape();
  }
  
  //Displays the 'front' color part of this road
  void displayFront(){
    strokeWeight(size-5); //Slightly smaller inner line
    stroke(roadFronts[selectedColor]);
    beginShape();
    curveVertex(points.get(0).x, points.get(0).y, points.get(0).elevation);
    curveVertex(points.get(0).x, points.get(0).y, points.get(0).elevation);
    
    for(int i = 1; i < points.size()-1; i++){
      curveVertex(points.get(i).x, points.get(i).y, points.get(i).elevation);
    }
    
    curveVertex(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(points.size()-1).elevation);
    curveVertex(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(points.size()-1).elevation);
    
    endShape();
   
  }
  
  void displayNodes()
  {
    for(int i = 0; i < points.size(); i++){
      fill(0,255,255);
      strokeWeight(10);
      stroke(0,255,255);
      ellipse(points.get(i).x, points.get(i).y, 20,20);
    }
    
  }
  
}
class Point
{
  int x,y, elevation; 
  public Point(int x, int y, int elevation){
   this.x = x;
   this.y = y;
   this.elevation = elevation;
  }
}
