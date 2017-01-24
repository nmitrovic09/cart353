class SecondInsect {
  // variables for images
  PImage processImg;
  PImage img;

  //matrix and values for the blur
  float v = 1.0 / 9.0;
  float[][] kernel = {{ v, v, v }, 
    { v, v, v }, 
    { v, v, v }};

  SecondInsect() {
    //load and resize initiial image
    img = loadImage("2.jpg");
    img.resize(340, 340);

    /*create an image to be processed 
     with an alpha channel*/
    processImg = createImage(img.width, img.height, ARGB);
    init();
  }

  //draw the image
  void display() {
    image(processImg, 0, 0);
  }

  //initial starting function
  void init() {

    processImg.loadPixels();
    // Begin our loop for every pixel
    for (int x = 0; x < img.width; x++ ) {
      for (int y = 0; y < img.height; y++ ) {

        //calculate the pixel location
        int loc = x + img.width*y;
        // RGBA for the source image
        float r = red(img.pixels[loc]);
        float g = green(img.pixels[loc]);
        float b = blue(img.pixels[loc]);
        float a = alpha(img.pixels[loc]);

        /*image to start
        opacity start at 125 */
        a = 125;
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

        // RGB pixels color in the source image
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

  void decreaseOpacity() {

    processImg.loadPixels();
    // Begin our loop for every pixel
    for (int x = 0; x < processImg.width; x++ ) {
      for (int y = 0; y < processImg.height; y++ ) {
        //calculate the pixel location
        int loc = x + processImg.width*y;

        // RGB pixels color in the source image
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

  void sat() {

    processImg.loadPixels();
    // Begin our loop for every pixel
    for (int x = 0; x < processImg.width; x++ ) {
      for (int y = 0; y < processImg.height; y++ ) {
        //calculate the pixel location
        int loc = x + processImg.width*y;

        // RGB pixels color in the source image
        float r = red(processImg.pixels[loc]);
        float g = green(processImg.pixels[loc]);
        float b = blue(processImg.pixels[loc]);
        float a = alpha(processImg.pixels[loc]);

        //randomize process the picture
        float change = random(0, 2);
        color c = color(b, r*change, g, a );
        processImg.pixels[loc] = c;
      }
    }
    processImg.updatePixels();
  }

  void blur() {

    processImg.loadPixels();
    //loop for every pixel in the proccessed image
    for (int x = 1; x < processImg.width-1; x++ ) {
      for (int y = 1; y < processImg.height-1; y++ ) {
        float sum = 0; // Kernel blur sum for pixel
        //loop the kernel x and y formula
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            // Calculate the adjacent pixel for this kernel point
            int loc = (y + ky)*processImg.width + (x + kx);
            //Image is grayscale, red/green/blue are identical
            //get red pixel as a value
            float val = red(processImg.pixels[loc]);
            //Multiply adjacent pixels based on the kernel values
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