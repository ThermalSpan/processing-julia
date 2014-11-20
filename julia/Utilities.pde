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

public class PComplex extends PVector{
	public PComplex(float x, float y){
		super(x,y);
	}

	public PComplex cmult(PComplex B){
		float nx = this.x*B.x - this.y*B.y;
		float ny = this.x*B.y + this.y*B.x;
		return new PComplex(nx,ny);
	}

	public PComplex cpow(int e){
		float nx = this.x;
		float ny = this.y;
		for(int i=1; i<e; i++){
			nx = this.x*nx - this.y*ny;
			ny = this.x*ny + this.y*nx;
		}
		return new PComplex(nx, ny);
	}

}

