//FIX CUTOFF AMOUNT NOT PARAMETRIC YET
//NEED TO COMMENT OUT ALL FUNCTIONS

//The diameter of the bucket being used.
bucketDiameter = 11;

//The height of the first stage (the top stage) of the urine diverter.
stage1Height = 1.75;

//The height of the second stage (the bottom stage) of the urine diverter.
stage2Height = 1.75;

//What diameter Stage 1 reduces to.
stage1Reduction = 10;
//What diameter stage 2 reduces to.
stage2Reduction = 0.5;

//How much length-wise of the diverter is kept. Typical value between 1/2 and 1/3.
cutoffAmount = 1/3;


//Detail of all circular and spherical objects. Essentially amount of sides. Value between 30 and 100 is standard.
sfn=100;

//The overall thickness of the diverter.
thickness = 0.125;

//The length of the tube protruding from the end of the bottom tube.
tubeLength = 0.75;

//The amount that cut holes will overlap. Value between 0.1 and 1.5 or so should be fine.
overlap = 1;

// - ? Will patch this later
cutoff=0;

//Amount to cutoff when I simply need to pierce everything. 
largeNumber = 100;

//The distance between the two halves of the diverter when printing.
distBetween = 2.5;

//The overlap of the tube with the diverter. With a value of 0, there is no solid bridge between the tube at the end and the bottom of the diverter.
tubeOverlap = 1;

//Mode 1 is the two pieces of the diverter separated, and mode 2 is the two pieces together in assembled form. 
mode = 1;

//The reciprocal of the cutoff variable/amount of the diverter that is kept. 
cutoffRecip = 1/cutoffAmount;

//Computed variables
diverterHeight = stage1Height+stage2Height+tubeLength;

module mainDiverter() {
    difference() {
        union() {
            //Adding the two main cylinders together - adding stage 1 and stage 2 together (NOTE - test diameter stuff later!). R2s/D2s are different because these need to slope down to get to the adapted diameter (variables stage1Reduction and stage2Reduction) above. 
            cylinder(r2=bucketDiameter/2, r1=stage1Reduction/2, h=stage1Height, $fn=sfn, center=true);
            translate([0,0,(stage1Height+stage2Height)/-2]) {
                cylinder(r2=stage1Reduction/2, r1=stage2Reduction/2, h=stage2Height, $fn=sfn, center=true);
            }
        }
        //Hollowing the top and bottom stages by removing cylinders the same size, except minus the thickness to leave nothing but  the thickness.
        translate([0,0,thickness/2]) {
             cylinder(r2=(bucketDiameter-thickness*2)/2, r1=(stage1Reduction-thickness*2)/2, h=stage1Height, $fn=sfn, center=true);
        }
        translate([0,0,(stage1Height+stage2Height-thickness)/-2]) {
                cylinder(r2=(stage1Reduction-thickness*2)/2, r1=(stage2Reduction-thickness*2)/2, h=stage2Height, $fn=sfn, center=true);
        }
    }
}

module partialDiverter() {
    difference() {
        mainDiverter();
        //Cutting the main diverter in half/into a fraction that is whatever the cutoff amount is.
        //CLARIFY what the translate statement does
        translate([(bucketDiameter+stage2Reduction)/cutoffRecip, 0, (stage1Height+overlap-cutoff)/-2]) {
            //A cube that is exactly the size of the main diverter. Translated to determine how much is actually cutoff. Clarify cutoff variable inside. 
            cube([bucketDiameter, bucketDiameter, stage1Height+stage2Height+tubeLength+overlap-cutoff], center=true);
        }
    }
}



module coverGuard() {
    intersection() {
        //Taking a whole version (no holes) of the main diverter.
        hull() translate([bucketDiameter/cutoffRecip, 0,0]) partialDiverter();
        translate([bucketDiameter/(1/cutoffAmount)/2+thickness,0,(stage1Height/2+thickness+cutoff/2)/-1]) {
            cube([thickness, bucketDiameter, (stage1Height+stage2Height-cutoff/2+thickness*2)], center=true);
        }
    }  
}

module tube() {
    difference() {
        translate([(bucketDiameter/(-1/cutoffAmount))/2-thickness,0,(stage1Height/2+stage2Height/2+tubeLength)/-1+tubeOverlap]) cylinder(r=stage2Reduction/2, h=tubeLength+tubeOverlap*2, $fn=sfn, center=true);
       hull() partialDiverter(); 
    }
}

module fullDiverter() {
    difference() {
        union() {
            partialDiverter();
            translate([bucketDiameter/(-1/cutoffAmount),0,0]) coverGuard();
            tube();
        }
       translate([(bucketDiameter/(-1/cutoffAmount))/2-thickness,0,(stage1Height/2+stage2Height/2+tubeLength)/-1+overlap]) cylinder(r=(stage2Reduction-thickness*2)/2, h=largeNumber, center=true, $fn=sfn);
    }
}

module separation() {
    translate([0,bucketDiameter/4-thickness,0]) rotate([0,90,0]) difference() {
        fullDiverter();
        translate([0,bucketDiameter/4,(diverterHeight+thickness*2)/-4]) cube([bucketDiameter, bucketDiameter/2, diverterHeight+thickness*2], center=true);
    }
    translate([diverterHeight/2+distBetween,bucketDiameter/-4+thickness,0]) rotate([0,90,0]) difference() {
    fullDiverter();
    translate([0,bucketDiameter/-4,(diverterHeight+thickness*2)/-4]) cube([bucketDiameter, bucketDiameter/2, diverterHeight+thickness*2], center=true);
}
}
    
module final() {
    //All variables are in imperial and OpenSCAD runs in metric. This is scaling the WHOLE MODEL up by x25.4 to convert everything easily from imperial to metric.
    scale([25.4, 25.4, 25.4])  {
        if(mode == 1) {
            separation();
        }
        else if(mode == 2) {
            fullDiverter();
        }
    }
}
final();

