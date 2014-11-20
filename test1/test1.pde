PGraphics buffer;
PShader test;
PVector center;
float scale, scalingFactor, angle;

// processing-java --sketch="${HOME}/projects/processing-julia/test1" --output="/tmp/vim-processing/test1" --force --run
void setup(){
	size(800,800,P2D);
	buffer = createGraphics(width,height,P2D);
	test = loadShader("testfrag.glsl");
       	        center = new PVector(0,0);
	scale = 1;
	scalingFactor = 0.1;
	angle = 0;
}

void draw(){
	test.set("resolution", float(width), float(height));
        test.set("center", center.x, center.y);
	test.set("scale", scale);
	test.set("angle", angle);
	background(0);
	buffer.beginDraw();
	buffer.shader(test);
	buffer.rect(0,0,width,height);
	buffer.endDraw();
	image(buffer,0,0);
}

void keyPressed(){
	if(key==CODED){
		if(keyCode==UP) center.add(0,scale*scalingFactor,0);
		if(keyCode==DOWN) center.add(0,-scale*scalingFactor,0);
		if(keyCode==LEFT) center.add(-scale*scalingFactor,0,0);
		if(keyCode==RIGHT) center.add(scale*scalingFactor,0,0);
	}
	if(key=='d') scale *= 0.75;
	if(key=='f') scale *= 1.25;
	if(key=='e') {
		angle += 0.1;
		center.rotate(-0.1);
	}
	if(key=='r') {
		angle -= 0.1;
		center.rotate(0.1);
	}
	if(key=='q') exit();
}
