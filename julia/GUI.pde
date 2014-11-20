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
	ArrayList<GUIelement> elementList;


	GUI() {
		elementList = new ArrayList<GUIelement>();
	}

	void update(float elapsedTime) {
		for(GUIelement element : elementList)
			element.update(elapsedTime);
	}

	void draw() {
		for(GUIelement element : elementList)
			element.draw();
	}

	void add(GUIelement element) {
		elementList.add(element);
	}
}


class GUISlideMenu implements GUIelement{
	float w, h, x, y, tabw, tabh, trans, state; 
	color fillc;
	boolean mouseonMenu;
	boolean extended;
	color strokec;
	ArrayList<GUIelement> elementList;
	
	GUISlideMenu(float w0, float h0, color f0, color s0) {
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
			state += max(elapsedTime * 8 * sin(state * PI), 0.01);
		else if(!mouseonMenu && state > 0)
			state -= max(elapsedTime * 8 * sin(state * PI), 0.01);

		state = constrain(state, 0, 1);
		trans = -w + state * w;

		if(trans == 0)
			for(GUIelement element : elementList) element.update(elapsedTime);

	}

	public void mouseReleased() {

	}

	void add(GUIelement element) {
		elementList.add(element);
	}

	public void checkMouse() {
		if(mouseOnRect(x + trans, y, w, h) || mouseOnRect(x + trans + w, y, tabw, tabh))
			mouseonMenu = true;
		else mouseonMenu = false;
	}
}

class GUIpushbutton implements GUIelement {
	color fillc;
	color strokec;
	color selectc;
	float x, y, r;
	boolean mouseLock;
	pushHandler handler;

	GUIpushbutton(float x0, float y0, float r0, color f0, color st0, color sl0, pushHandler h0) {
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
	color fillc;
	color strokec;
	color selectc;
	float x, y, r;
	boolean mouseLock;
	boolean state;
	toggleHandler handler;

	GUItogglebutton(float x0, float y0, float r0, color f0, color st0, color sl0, toggleHandler h0) {
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
	color fillc, strokec, selectc;
	sliderHandler handler;
	boolean mouseLock;

	GUIslider(float x0, float y0, float l0, float r0, color fc, color stc, color slc, sliderHandler h) {
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
	color fillc;
	int sizet;

	GUItext(String m, float x0, float y0, color fc, int s) {
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

