processing-julia
================

<h3> What is it? </h3>

This is (read: will be) a processing sketch that allows the user to explore an arbitrary julia set. I only plan on using floating point accuracy, so this will not be for "deep zooms." Instead, I envisioned this more as a tool for quickly finding, framing and saving useful pictures of these sets. The rendering is done using glsl (which I just started learning, very exciting stuff). 

<h3> Current State </h3>

The sketch as it stands is a viewer for the mandelbrot set. I have been manually adjusting the shader as to meet my needs. What is in place is simple system that allows the user to rotate, zoom, and translate their view. 

<h3> Planned Additions </h3>

I enjoy the goal of this project as a long term thing. I do not expect to to finish it using processing. However, processing provides a great platform for me to learn about using glsl, so I will continue on that track until I hit my limits. Short term goals include:

* Finding a more generalized way to pass in a color scheme to the shader. Probably in the form of a texture.
* Find out how to approach / what the limitations are on passing in a generalized polynomials to the shader.

Long term goals include:

* Enter the rational function symbolically.
* Provide the ability to render a high resolution export of the current view. 
