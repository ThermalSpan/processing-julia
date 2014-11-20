

public GUI constructGUI(){
	GUI juliaGUI = new GUI();
	GUISlideMenu menu = new GUISlideMenu(240,1024,color(128,128,128,150),color(135,67,186));
	juliaGUI.add(menu);
	color fillcolor = color(90,90,90);   
	color selectcolor = color(200,200,200);
	color textcolor = color(0);


        menu.add(new GUItext("tf", 50, 340, textcolor, 16));
	menu.add(new GUItext("am", 50, 390, textcolor, 16));
	menu.add(new GUItext("sf", 50, 440, textcolor, 16));

        menu.add(new GUIslider(20, 350, 200, 20,fillcolor, selectcolor, selectcolor, new translateFactorSH()));
	menu.add(new GUIslider(20, 400, 200, 20,fillcolor, selectcolor, selectcolor, new angleModSH()));
	menu.add(new GUIslider(20, 450, 200, 20,fillcolor, selectcolor, selectcolor, new scalingFactorSH()));
	
	menu.add(new GUIpushbutton(120.0, 325.0, 20.0, fillcolor, color(0,0,0), selectcolor, new savePH()));



	return juliaGUI;
}

public class savePH implements pushHandler {
	public void update() {
		String title = "is" + year() + month() + day() + hour() + minute() + second();
		title = "screenshots/date" + title + ".jpg";
		juliaBuffer.save(title);
	}
}

public class translateFactorSH implements sliderHandler {
  public void update(float ratio){
    translateFactor = ratio;
  }

}

public class angleModSH implements sliderHandler {
	public void update(float ratio){
		angleMod = ratio;
	}

}

public class scalingFactorSH implements sliderHandler {
	public void update(float ratio){
		scalingFactor = ratio;
	}

}

