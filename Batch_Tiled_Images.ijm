//The macro takes a directory containing TIFF images as input and prompts the user 
//to enter the number of tiles per row/column for each image. 
//The macro then loops through each image in the directory, opens it, 
//and creates a specified number of tiled images from the original, with each tile saved as a new file. 

// Set batch mode to true to speed up the macro by disabling the display of images during processing.
setBatchMode(true);

// Prompt user to choose number of tiles
n = getNumber("Enter number of tiles per row/column:", 4);
n_total = n*n;

// Define input and output directories. 
inputFolder = getDirectory("Select input directory");
File.setDefaultDir(inputFolder); // this is needed when the macro file is located elsewhere
outputFolder = inputFolder + File.separator + "Tiled"+n_total + File.separator ;
File.makeDirectory(outputFolder);


// Get a list of all files in the folder
list = getFileList(inputFolder);

// Loop through each file
for (i = 0; i < list.length; i++) {

  // Check if the file is a TIF file
  if (endsWith(list[i], ".tif")) {

    // Open the TIF file
    open(inputFolder + list[i]);

    // Get image properties
    id = getImageID(); 
    title = getTitle(); 
    getLocationAndSize(locX, locY, sizeW, sizeH); 
    width = getWidth(); 
    height = getHeight(); 
    tileWidth = width / n; 
    tileHeight = height / n; 

    // Loop through each tile
    for (y = 0; y < n; y++) { 
      offsetY = y * height / n; 
      for (x = 0; x < n; x++) { 
        offsetX = x * width / n; 

        // Select the image, set location, duplicate, and crop
        selectImage(id); 
        call("ij.gui.ImageWindow.setNextLocation", locX + offsetX, locY + offsetY); 
        tileTitle = title + " [" + x + "," + y + "]"; 
        run("Duplicate...", "title=" + tileTitle); 
        makeRectangle(offsetX, offsetY, tileWidth, tileHeight); 
        run("Crop"); 
        saveAs("Tiff", outputFolder + list[i] + "_tile_" + x + "_" + y + ".tif"); // Save the current tile as a new TIF file
      } 
    } 

    // Close the original image
    selectImage(id); 
    close("*"); 

  } // end if statement for TIF files

} // end for loop for files in folder


setBatchMode(false);