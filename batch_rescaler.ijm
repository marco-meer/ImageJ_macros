// Rescales single-channel z-stacks
// Stored in subfolder 'rescaled'

setBatchMode(true);


inputDir = getDirectory("Select input directory");
File.setDefaultDir(inputDir); // this is needed when the macro file is located elsewhere
outputDir = inputDir + File.separator + "rescaled" + File.separator ;
File.makeDirectory(outputDir);


list = getFileList(inputDir);



// set expected voxel size:
x_value = getNumber("Enter Pixel width (microns)", 1); y_value = x_value;
z_value = getNumber("Enter Voxel depth (microns)", 1);



for (i = 0; i < list.length; i++) {
   if (endsWith(list[i], ".tif")) {
      filePath = inputDir + list[i];
      run("Bio-Formats Importer", "open=" +inputDir + list[i] + " autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
      run("Scale...", "x="+ x_value + " y=" + y_value + " z=" + z_value + " interpolation=None");
      saveAs("Tiff", outputDir + list[i]);
      close("*"); // seems to flush memory    
   }
}

setBatchMode(false);
