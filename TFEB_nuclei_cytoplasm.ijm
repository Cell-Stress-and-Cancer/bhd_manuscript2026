//script to maeasure TFEB in UOK cells 

directory = getDirectory("Choose a input directory");
output=getDirectory("Select/Create Output Directory");

setBatchMode(true);
   
filelist = getFileList(directory) 

for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".tif")) { 
    	open(directory + File.separator + filelist[i]);

// prep
roiManager("reset");
makeRectangle(374, 346, 1340, 1388);
run("Crop");

name = getTitle();
run("Split Channels");

//close LC3 window 
selectWindow("C2-" + name);
close();

//Segment nuclei
selectWindow("C1-" + name);
run("Duplicate...", " ");
run("8-bit");
run("Gaussian Blur...", "sigma=3");
run("Auto Threshold", "method=Huang white");
run("Fill Holes");
//run("Watershed");

run("Set Measurements...", "area mean standard min median display redirect=C3-" + name +"");
rename("nuclei_"+ name);
run("Analyze Particles...", "size=100-Infinity clear summarize add");
nuclei=getTitle();
run("Duplicate...", " ");

//remove small blobs that are not nuclei before expanding 
roiManager("Combine");
run("Clear Outside");
nucleiExpand = getTitle();

//measure in nuclei 

//expand nuclei 
selectWindow(nucleiExpand);
run("BinaryDilateNoMerge8 ", "iterations=15 white");

// create cytoplasm-ish 
imageCalculator("Subtract create", nucleiExpand,nuclei);
run("Erode");
run("Erode");
rename("cytoplasm_"+ name);
run("Set Measurements...", "area mean standard min median display redirect=C3-" + name +"");
roiManager("reset");
run("Analyze Particles...", "size=0-Infinity clear summarize add composite");

//selectWindow("C3-" + name);

run("Close All");

}
} // end of loop per folder 

//save summary window 
selectWindow("Summary");
saveAs("Results", output + "TFEB_measurements.csv");
