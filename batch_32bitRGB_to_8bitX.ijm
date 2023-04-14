// This script converts 32bit RGB TIF images to 8bit single color images by splitting color channels, keeping selected color channel and reducing bit depth to 8bit.
// CLI alternative: https://libtiff.gitlab.io/libtiff/tools/tiff2bw.html



// Set batch mode to true to speed up the macro by disabling the display of images during processing.
setBatchMode(true);
// Set the directory containing the images
inputFolder = getDirectory("Select input directory");

// Get a list of TIF files in the folder
list = getFileList(inputFolder);

bit_depth = 8;
// Prompt the user to enter a letter (R, G, or B)
inputString = getString("Enter a color channel (R, G, or B):", "B");

// Convert the input to a number
colorChannel = -1; // initialize to an invalid value
if (inputString=="R") {
    colorChannel = 0;
} else if (inputString=="G") {
    colorChannel = 1;
} else if (inputString=="B") {
    colorChannel = 2;
} else {
    showMessage("Invalid input: " + inputString);
}

// Loop through each TIF file
for (i = 0; i < list.length; i++) {
	if (endsWith(list[i], ".tif")) {
   
      // Open the image and convert to grayscale
      run("Bio-Formats Importer", "open=[" + inputFolder + list[i] + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
      run("Split Channels");
      // Get the titles of the split channels windows
      titles = getList("image.titles");

      selectWindow(titles[colorChannel]);  

      run(bit_depth+"-bit");
    
      // Construct the output filename
      outputFilename = replace(list[i], ".tif", "_"+bit_depth+"bit.tif");
      outputPath = inputFolder + outputFilename;
    
      // Save the grayscale image with the new filename
      saveAs("Tiff", outputPath);
    
      // Close all images, even needed in batch mode (memory)
      close("*");
	  }
}


setBatchMode(false);
