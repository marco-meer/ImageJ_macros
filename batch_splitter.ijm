// Splits multi-channel z-stacks into single-channel z-stacks
// Stored in subfolder 'single_channels'

// In batch mode no windows open and the macro runs in the background
setBatchMode(true);

// Define input and output directories. 
inputDir = getDirectory("Select input directory");
File.setDefaultDir(inputDir); // this is needed when the macro file is located elsewhere
outputDir = inputDir + File.separator + "single_channels" + File.separator ;
File.makeDirectory(outputDir);

// Get a list of all files in the input directory
list = getFileList(inputDir);


for (i = 0; i < list.length; i++) {
   if (endsWith(list[i], ".tif")) {
      filePath = inputDir + list[i];
      run("Bio-Formats Importer", "open=" +inputDir + list[i] + " autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
      // get some info about the image
	  getDimensions(width, height, channels, slices, frames);
	  if (channels > 1) run("Split Channels");
      nChannels = nImages();
      for (c = 1; c <= nChannels; c++) {
      selectImage(c);
      // Get the name of the current channel
      channelName = getTitle();
      saveAs("Tiff", outputDir + channelName );
      }  
      close("*"); // seems to flush memory
   }
}

setBatchMode(false);
