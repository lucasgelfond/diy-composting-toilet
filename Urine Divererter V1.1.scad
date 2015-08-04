//FIX CUTOFF AMOUNT NOT PARAMETRIC YET
//NEED TO COMMENT OUT ALL FUNCTIONS

bucketDiameter = 11;
stage1Height = 1.75;
stage2Height = 1.75;
stage1Reduction = 10;
stage2Reduction = 0.5;

cutoffAmount = 1/3;

sfn=100;
thickness = 0.125;
tubeLength = 0.75;
overlap = 1;
cutoff=0;
largeNumber = 100;

distBetween = 2.5;

diverterHeight = stage1Height+stage2Height+tubeLength;

tubeOverlap = 1;

mode = 1;

module mainDiverter() {
    difference() {
        union() {
            cylinder(r2=bucketDiameter/2, r1=stage1Reduction/2, h=stage1Height, $fn=sfn, center=true);
            translate([0,0,(stage1Height+stage2Height)/-2]) {
                cylinder(r2=stage1Reduction/2, r1=stage2Reduction/2, h=stage2Height, $fn=sfn, center=true);
            }
        }
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
        translate([(bucketDiameter+stage2Reduction)/(1/cutoffAmount), 0, (stage1Height+overlap-cutoff)/-2]) {
            cube([bucketDiameter, bucketDiameter, stage1Height+stage2Height+tubeLength+overlap-cutoff], center=true);
        }
    }
}



module coverGuard() {
    intersection() {
        hull() translate([bucketDiameter/(1/cutoffAmount), 0,0]) partialDiverter();
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

