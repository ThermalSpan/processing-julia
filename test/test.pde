PMatrix2D t,s,r;
float xoff;
float yoff;
PVector a[][];


public void setup(){
	size(500,500);
	background(0);
	ellipseMode(CENTER);
	fill(1);

	t = new PMatrix2D(1,0,0,0,1,0);
	s = new PMatrix2D(1,0,0,0,1,0);
	r = new PMatrix2D(1,0,0,0,1,0);

	xoff = 100.0;
	yoff = 100.0;

	a = new PVector[20][20];
	for(int x=0; x<20; x++)
		for(int y=0; y<20; y++)
			a[x][y] = new PVector((float)(7*x+xoff),(float)(7*y+yoff));
}

public void draw(){
	background(0);
	fill(255,255,255);
	

	for(int x=0; x<20; x++)
		for(int y=0; y<20; y++){
			PVector loc = new PVector(0,0);
			
			t.mult(a[x][y],loc);

			ellipse(loc.x,loc.y,5,5);
		}

}

public void keyPressed(){
	if(key==CODED){
		if(keyCode==UP) t.translate(0,-1);
		if(keyCode==DOWN) t.translate(0,1);
		if(keyCode==LEFT) t.translate(-1,0);
		if(keyCode==RIGHT) t.translate(1,0);
	}
	if(key=='q') exit();
}
