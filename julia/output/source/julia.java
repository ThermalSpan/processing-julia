import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class julia extends PApplet {

/* julia.pde by Russell Bentley
* This is intended to a julia set viewer that will allow the user to both explore julia sets and export images
* Resuing GUI code developed for the juliagraphs project.
*/




GUI juliaGUI;
PGraphics juliaBuffer;
PImage juliaImage;

public void setup(){
	size(1024,1024);	
	ellipseMode(CENTER);
	background(255,255,255);
	fill(0);

	juliaGUI = constructGUI();
	juliaBuffer = createGraphics(1024,1024);

}
	
public void draw(){	
	background(0);
	float elapsedTime = constrain(1f/frameRate, 16f/1000f, 32f/1000f);
	
	//Must wrap the buffer draw commands in begin and end
	juliaBuffer.beginDraw();

	juliaBuffer.endDraw();
	//Now we use the buffer to make and image and display it
	juliaImage = juliaBuffer.get(0, 0, juliaBuffer.width, juliaBuffer.height);
	image(juliaImage, 0, 0);

	juliaGUI.update(elapsedTime);
	juliaGUI.draw();

}

/* GUI.pde
by Russell Bentley

Design is highly influenced by the work of Jared Counts,
In particular see
http://www.openprocessing.org/sketch/64701

This file contains the backend for the GUI, including:
-an interface for adding elements to the GUI
-an interface for creating slider handlers
-an interface for creating radio button handlers
-the GUI class, 
-a slideout menu element,
-a slider element,
-a radio button element,
-a radio button group element.

Note that any elements that appear on a meny must be made an element
of the menu, not the GUI

Construction of the particular GUI and the Handlers for button and slider events
belong in another file. 

Required things:
	-ellipseMode(CENTER) 
	-import java.util.* 
	-associated with Utilities.pde
*/

public interface GUIelement {
	public void draw();
	public void draw(float tranX, float tranY);
	public void update(float elapsedTime);
	public void mouseReleased();
}

public interface sliderHandler {
	public void update(float p);
}

public interface pushHandler {
	public void update();
}

public interface toggleHandler {
	public void update(boolean state);
}

class GUI {
	List<GUIelement> elementList;


	GUI() {
		elementList = new ArrayList<GUIelement>();
	}

	public void update(float elapsedTime) {
		for(GUIelement element : elementList)
			element.update(elapsedTime);
	}

	public void draw() {
		for(GUIelement element : elementList)
			element.draw();
	}

	public void add(GUIelement element) {
		elementList.add(element);
	}
}


class GUISlideMenu implements GUIelement{
	float w, h, x, y, tabw, tabh, trans, state; 
	int fillc;
	boolean mouseonMenu;
	boolean extended;
	int strokec;
	List<GUIelement> elementList;
	
	GUISlideMenu(float w0, float h0, int f0, int s0) {
		elementList = new ArrayList<GUIelement>();
		x = 0;
		y = 0;
		trans = -w;
		state = 1; 
		tabw = 20;
		tabh = 100;
		w = w0;
		h = h0;
		fillc = f0;
		strokec = s0;
	}

	public void draw(float tranX, float tranY) {
		float xoff = x + tranX + trans;
		float yoff = y + tranY;
		pushStyle();
			fill(fillc);
			stroke(strokec);
			rect(xoff, yoff, w,  h);
			rect(xoff + w , yoff, tabw, tabh);
		popStyle();

		for(GUIelement element : elementList) element.draw(trans,0);
	}

	public void draw() {
		draw(0,0);
	}
	
	public void update(float elapsedTime) {
		checkMouse();

		if(mouseonMenu && state < 1)
			state += max(elapsedTime * 8 * sin(state * PI), 0.01f);
		else if(!mouseonMenu && state > 0)
			state -= max(elapsedTime * 8 * sin(state * PI), 0.01f);

		state = constrain(state, 0, 1);
		trans = -w + state * w;

		if(trans == 0)
			for(GUIelement element : elementList) element.update(elapsedTime);

	}

	public void mouseReleased() {

	}

	public void add(GUIelement element) {
		elementList.add(element);
	}

	public void checkMouse() {
		if(mouseOnRect(x + trans, y, w, h) || mouseOnRect(x + trans + w, y, tabw, tabh))
			mouseonMenu = true;
		else mouseonMenu = false;
	}
}

class GUIpushbutton implements GUIelement {
	int fillc;
	int strokec;
	int selectc;
	float x, y, r;
	boolean mouseLock;
	pushHandler handler;

	GUIpushbutton(float x0, float y0, float r0, int f0, int st0, int sl0, pushHandler h0) {
		x = x0;
		y = y0;
		r = r0;
		fillc = f0;
		strokec = st0;
		selectc = sl0;
		handler = h0;
	}

	public void draw(float tranX, float tranY) {
		pushStyle();
			if(mouseLock) fill(selectc);
			else fill(fillc);
			stroke(strokec);
			ellipse(x + tranX,y + tranY,r,r);
		popStyle();
	}

	public void draw() {
		draw(0,0);
	}
	
	public void update(float elapsedTime) {
		if(mouseDist(x,y) <= r && mousePressed)
			mouseLock = true;

		if(mouseDist(x,y) <= r && mouseLock && !mousePressed) {
			handler.update();
			mouseLock = false;
		}
	}

	public void mouseReleased() {}	
}

class GUItogglebutton implements GUIelement {
	int fillc;
	int strokec;
	int selectc;
	float x, y, r;
	boolean mouseLock;
	boolean state;
	toggleHandler handler;

	GUItogglebutton(float x0, float y0, float r0, int f0, int st0, int sl0, toggleHandler h0) {
		x = x0;
		y = y0;
		r = r0;
		fillc = f0;
		strokec = st0;
		selectc = sl0;
		handler = h0;
		state = false;
	}

	public void draw(float tranX, float tranY) {
		pushStyle();
			if(state) fill(selectc);
			else fill(fillc);
			stroke(strokec);
			ellipse(x + tranX,y + tranY,r,r);
		popStyle();
	}

	public void draw() {
		draw(0,0);
	}
	
	public void update(float elapsedTime) {
		if(mouseDist(x,y) <= r && mousePressed)
			mouseLock = true;

		if(mouseDist(x,y) <= r && mouseLock && !mousePressed) {
			state = !state;
			handler.update(state);
			mouseLock = false;
		}
	}

	public void mouseReleased() {}	
}

class GUIradiogroup implements GUIelement {
	GUIradiogroup() {
		
	}

	public void draw(float tranX, float tranY) { }
	public void draw() { }
	
	public void update(float elapsedTime) {

	}

	public void mouseReleased() {

	}
}

class GUIslider implements GUIelement {
	float x, y, l, r, p;
	int fillc, strokec, selectc;
	sliderHandler handler;
	boolean mouseLock;

	GUIslider(float x0, float y0, float l0, float r0, int fc, int stc, int slc, sliderHandler h) {
		x = x0;
		y = y0;
		l = l0;
		r = r0;
		p = 0;
		fillc = fc;
		strokec = stc;
		handler = h;
		mouseLock = false;
		selectc = slc;
	}

	public void draw(float tranX, float tranY) {
		pushStyle();
			if(mouseLock) fill(selectc);
			else fill(fillc);
			stroke(strokec);
			line(x + tranX,y + tranY,x + l + tranX, y + tranY);
			ellipse(x + p + tranX,y + tranY,r,r);
		popStyle();
	}

	public void draw() {
		draw(0,0);
	}
	
	public void update(float elapsedTime) {
		if(mouseLock && mousePressed) {
			p = (mouseX - x);
			p = constrain(p, 0, l);
			handler.update(p/l);
		}
		else if( mouseLock && !mousePressed) {
			mouseLock = false;
		}
		else if(mousePressed && mouseDist(x + p,y) <= r) {
			mouseLock = true;
		}
	}

	public void mouseReleased() {}
}

class GUItext implements GUIelement {
	String message;
	float x, y;
	int fillc;
	int sizet;

	GUItext(String m, float x0, float y0, int fc, int s) {
		message = m;
		x = x0;
		y = y0;
		fillc = fc;
		sizet = s;
	}

	public void draw(float tranX, float tranY) {
		pushStyle();
		fill(fillc);
		textSize(sizet);
		text(message,x + tranX, y + tranY);
		popStyle();
	}

	public void draw() {
		draw(0,0);
	}
	
	public void update(float elapsedTime) {}
	public void mouseReleased() {}
}



public GUI constructGUI(){
	GUI juliaGUI = new GUI();
	GUISlideMenu menu = new GUISlideMenu(240,1024,color(128,128,128,150),color(135,67,186));
	juliaGUI.add(menu);

	return juliaGUI;
}
/*Utilities.pde
By Russell Bentley

This file contains a few groupings of useful functions. These include:
	-mouseDist(float x, float y)

*/

public float mouseDist(float x, float y) {
	float diffX = mouseX - x;
	float diffY = mouseY - y;
	return sqrt(diffX*diffX + diffY*diffY);
}

public boolean mouseOnRect(float a, float b, float c, float d) {
	float mx = mouseX;
	float my = mouseY;
	boolean result = false;

	if(mx >= a && mx <= a+c && my >= b && my <= b+d) {
		result = true;
	}	

	return result;
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "julia" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
