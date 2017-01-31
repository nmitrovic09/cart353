class Insect {
  //variables for images
  PImage processImg;
  PImage img;

  //matrix and values for the blur
  float v = 1.0 / 9.0;
  float[][] kernel = {{ v, v, v }, 
    { v, v, v }, 
    { v, v, v }};

  //constructor
  Insect() {
    //set the images by loading and resize to fit window
    img = loadImage("1.jpeg");
    img.resize(340, 340);

    /*create an image to be processed 
     with an alpha channel*/
    processImg = createImage(img.width, img.height, ARGB);
    init();;
  }

  //display the processed image from top left corner
  void display() {
    image(processImg, 0, 0);
  }

  //inital image at setup
  void init() {

    processImg.loadPixels();
    // Begin loop for every pixel
    for (int x = 0; x < processImg.width; x++ ) {
      for (int y = 0; y < processImg.height; y++ ) {

        //calculate the pixels location on the window
        int loc = x + img.width*y;
        //RGBA pixels in the source image
        float r = red(img.pixels[loc]);
        float g = green(img.pixels[loc]);
        float b = blue(img.pixels[loc]);
        float a = alpha(img.pixels[loc]);

        /* image to start
        opacity start at 125 */
        a = 125;
        color c = color(r, g, b, a);
        processImg.pixels[loc] = c;
      }
    }
    processImg.updatePixels();
  }

  void decreaseOpacity() {

    processImg.loadPixels();
    // Begin loop for every pixel
    for (int x = 0; x < processImg.width; x++ ) {
      for (int y = 0; y < processImg.height; y++ ) {

        //calculate the pixel location
        int loc = x + processImg.width*y;

        //RGBA color pixels in the source image
        float r = red(processImg.pixels[loc]);
        float g = green(processImg.pixels[loc]);
        float b = blue(processImg.pixels[loc]);
        float a = alpha(processImg.pixels[loc]);

        /*process the image by decreasing
        the alpha channel */
        a -= 1;
        color c = color(r, g, b, a);
        processImg.pixels[loc] = c;
      }
    }
    processImg.updatePixels();
  }

  void increaseOpacity() {

    processImg.loadPixels();
    // Begin our loop for every pixel
    for (int x = 0; x < processImg.width; x++ ) {
      for (int y = 0; y < processImg.height; y++ ) {
        //calculate the pixel location
        int loc = x + processImg.width*y;

        //RGB color pixels in the source image
        float r = red(processImg.pixels[loc]);
        float g = green(processImg.pixels[loc]);
        float b = blue(processImg.pixels[loc]);
        float a = alpha(processImg.pixels[loc]);

        /*process the image by increasing
        the alpha channel */
        a += random(3);
        color c = color(r, g, b, a);
        processImg.pixels[loc] = c;
      }
    }
    processImg.updatePixels();
  }

  //saturation image processing
  void sat() {

    processImg.loadPixels();
    // Begin our loop for every pixel
    for (int x = 0; x < processImg.width; x++ ) {
      for (int y = 0; y < processImg.height; y++ ) {
        //calculate the pixel location
        int loc = x + processImg.width*y;

        //RGB pixels color in the source image
        float r = red(processImg.pixels[loc]);
        float g = green(processImg.pixels[loc]);
        float b = blue(processImg.pixels[loc]);
        float a = alpha(processImg.pixels[loc]);

        //randomize process of the picture
        float change = random(1, 2);
        color c = color(g, b*change, r, a );
        processImg.pixels[loc] = c;
      }
    }
    processImg.updatePixels();
  }

  //blur image processing
  void blur() {

    processImg.loadPixels();
    //loop for every pixel in the proccessed image
    for (int x = 1; x < processImg.width-1; x++ ) {
      for (int y = 1; y < processImg.height-1; y++ ) {
        
        // set sum for blur pixels
        float sum = 0; 
        
        //loop the kernel x and y (adjacent points)
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            
            // Calculate the adjacent pixel for this kernel point(location)
            int loc = (y + ky)*processImg.width + (x + kx);
            //get red pixel as a value
            float val = red(processImg.pixels[loc]);
            //Multiply adjacent pixels based on the kernel matrix values
            sum += kernel[ky+1][kx+1] * val;
          }
        }
        //get the location for the alpha channel
        int loc = (y)*processImg.width + (x);
        /*For this pixel in the new image,
        process the image with the new sum
        and reset the alpha*/
        processImg.pixels[y*processImg.width + x] = color(sum, alpha(processImg.pixels[loc]));
      }
    }
    processImg.updatePixels();
  }
}