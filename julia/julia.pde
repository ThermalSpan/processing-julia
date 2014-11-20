/* julia.pde by Russell Bentley
* This is intended to a julia set viewer that will allow the user to both explore julia sets and export images
* Resuing GUI code developed for the juliagraphs project.
*/
GUI juliaGUI;

PGraphics juliaBuffer;
PShader test;
PVector center;
float scale, scalingFactor, angle, angleMod, translateFactor;
boolean updateBuffer;

// processing-java --sketch="${HOME}/projects/processing-julia/test1" --output="/tmp/vim-processing/test1" --force --run
void setup(){
	size(800,800,P2D);

	if (frame != null) {
	    frame.setResizable(true);
	}

	juliaBuffer = createGraphics(width,height,P2D);
	test = loadShader("julia.glsl");
       	        center = new PVector(0,0);
	scale = 1;
	scalingFactor = 0.1;
	angle = 0;
	angleMod = 0.1;
        translateFactor = 0.1;

	updateBuffer = true;

	juliaGUI = constructGUI();
}

void draw(){
	float elapsedTime = constrain(1f/frameRate, 16f/1000f, 32f/1000f);

	test.set("resolution", float(width), float(height));
        test.set("center", center.x, center.y);
	test.set("scale", scale);
	test.set("angle", angle);
	background(0);
	if(updateBuffer){
		juliaBuffer = createGraphics(width,height,P2D);

		juliaBuffer.beginDraw();
		juliaBuffer.shader(test);
		juliaBuffer.rect(0,0,width,height);
		juliaBuffer.endDraw();
		updateBuffer = false;
	}
	image(juliaBuffer,0,0);


	juliaGUI.update(elapsedTime);
	juliaGUI.draw();
}

void keyPressed(){
	updateBuffer = true;
	if(key==CODED){
		if(keyCode==UP) center.add(0,translateFactor*scale,0);
		if(keyCode==DOWN) center.add(0,-translateFactor*scale,0);
		if(keyCode==LEFT) center.add(-translateFactor*scale,0,0);
		if(keyCode==RIGHT) center.add(translateFactor*scale,0,0);
	}
	if(key=='d') scale *= scalingFactor;
	if(key=='f') scale /= scalingFactor;
	if(key=='e') {
		angle += angleMod;
		center.rotate(-angleMod);
	}
	if(key=='r') {
		angle -= angleMod;
		center.rotate(angleMod);
	}
	if(key=='q') exit();
}
