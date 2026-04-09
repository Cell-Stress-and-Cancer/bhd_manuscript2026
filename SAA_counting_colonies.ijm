// ImageJ Macro for processing images sequentially
// - Opens JPEG files from a folder
// - Counts spots using Find Maxima
// - Saves processed image to subfolder

run("Clear Results");

// Get the directory containing the images
dir = getDirectory("Choose a Directory containing JPEG Images");
// Create output directory

// Get all files in the directory
fileList = getFileList(dir);

// Process each JPEG file
for (i = 0; i < fileList.length; i++) {
    // Check if file is a JPEG
    if (endsWith(fileList[i], ".png") || endsWith(fileList[i], ".jpeg") || endsWith(fileList[i], ".JPG") || endsWith(fileList[i], ".JPEG")) {
        // Open the image
        open(dir + fileList[i]);
        imageName = File.nameWithoutExtension;
        
        
        //run("Gaussian Blur...", "sigma=6");

        // Run Find Maxima to count spots
        run("Find Maxima...", "prominence=15 light output=Count");
        
        //run("Find Maxima...", "prominence=10 exclude light output=[Point Selection]"); // for testing
        
        // Add to new results table
        setResult("Filename", i, imageName);
        
        // Close the image
        close();
    }
}
updateResults();

showMessage("Processing Complete", "All images have been processed.");