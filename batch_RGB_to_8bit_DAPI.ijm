// Set batch mode to true to speed up the macro by disabling the display of images during processing.
setBatchMode(true);
// Set the directory containing the images
inputFolder = getDirectory("Select input directory");

// Get a list of TIF files in the folder
list = getFileList(inputFolder);


// Loop through each TIF file
for (i = 0; i < list.length; i++) {
	if (endsWith(list[i], ".tif")) {
   
      // Open the image and convert to grayscale
      run("Bio-Formats Importer", "open=[" + inputFolder + list[i] + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
      run("Split Channels");
      // Get the titles of the split channels windows
      titles = getList("image.titles");
      close(titles[0]); // R
      close(titles[1]); // G
      selectWindow(titles[2]); // B

      
      run("8-bit");
    
      // Construct the output filename
      outputFilename = replace(list[i], ".tif", "_8bit.tif");
      outputPath = inputFolder + outputFilename;
    
      // Save the grayscale image with the new filename
      saveAs("Tiff", outputPath);
    
      // Close the original image, even needed in batch mode (memory)
      close("*");
	  }
}


setBatchMode(false);
