//Need to comment variables and clarify module comments.

bucketDiameter = 11;
stage1Height = 1.75;
stage2Height = 1.75;
stage1Reduction = 10;
stage2Reduction = 0.5;

cutoffAmount = 1/3;

sfn=100;
thickness = 0.125;
tubeLength = 1.5;
tubeThick = 0.0625;
overlap = 1;
cutoff=0;
largeNumber = 100;

distBetween = 3;

diverterHeight = stage1Height+stage2Height+tubeLength;
cutoffRecip = 1/cutoffAmount;

tubeOverlap = 1;

mode = 1;



module mainDiverter() {
    difference() {
        union() {
            //All of these cylinders start with a big radius at the top (r2) and small radius at the bottom (r1). The bottom radius of stage 1 and the top radius of stage 2 match up so that the piece can start with a relaxed angle and slowly get steeper.
            cylinder(r2=bucketDiameter/2, r1=stage1Reduction/2, h=stage1Height, $fn=sfn, center=true);
            //Moving the second cylinder down - same concept as the first cylinder, but with a steeper decline.
            translate([0,0,(stage1Height+stage2Height)/-2]) cylinder(r2=stage1Reduction/2, r1=stage2Reduction/2, h=stage2Height, $fn=sfn, center=true);
        }
        //Both of these are the exact same as the cylinders above, except they are what to take AWAY from the diverter. In this case, we're taking away everything except the thickness on each side. Everything moved up by thickness because there needs to be some material (thickness) on the bottom.
        translate([0,0,thickness]) cylinder(r2=(bucketDiameter-thickness*2)/2, r1=(stage1Reduction-thickness*2)/2, h=stage1Height, $fn=sfn, center=true);
        translate([0,0,(stage1Height+stage2Height-thickness*2)/-2]) cylinder(r2=(stage1Reduction-thickness*2)/2, r1=(stage2Reduction-thickness*2)/2, h=stage2Height, $fn=sfn, center=true);
    }
}

module partialDiverter() {
    difference() {
        //Taking the difference of the main diverter and a cube to cutoff a certain amount of the diverter (determined by the cutoffAmount variable)
        mainDiverter(center=true);
        //Moving the cube (the cube is the size of the entire diverter) over by a predetermined fraction of full diverter length (or in other words, the a fraction diameter of the bucket, bucketDiameter)
        translate([(bucketDiameter)/cutoffRecip, 0, (stage1Height+overlap-cutoff)/-2])  cube([bucketDiameter, bucketDiameter, diverterHeight*2], center=true);
    }
}

module coverGuard() {
    intersection() {
        //Takes the hull (fully solid version) of the partial diverter. This is used to make an "imprint" to determine the exact shape of the side cover. This "imprint" is the intersection module which determines what is intersecting between the partial diverter and a flat piece of material. This is how we fully cover the side accurately. 
            hull() partialDiverter();
        //Moves it to the place by going the bucket diameter (times the fraction, example 1/2 of the bucket diameter) but subtracts 1/2 because the diverter is in the center.
            translate([bucketDiameter*(cutoffAmount-0.5),0,0]) cube([thickness, bucketDiameter,bucketDiameter], center=true);
    }  
}

module tube() {
    //Perfectly shaping the top of the tube (to adapt to the contours of the diverter) by subtracting the shape of the diverter from the tube. 
    difference() {
        //Moving the tube to the edge of the diverter and slightly in to make sure all of the tube is inside the diverter. Moves it to the place by going the bucket diameter (times the fraction, example 1/2 of the bucket diameter) but subtracts 1/2 because the diverter is in the center. 
        translate([bucketDiameter*(cutoffAmount-0.5)-stage2Reduction/2,0,(stage1Height+stage2Height+tubeLength-tubeOverlap)/-2]) cylinder(r=stage2Reduction/2, h=tubeLength+tubeOverlap, $fn=sfn, center=true);
        //Subtracting the hull (filled in version of the diverter) from the tube so that it contours perfectly to the shape of the diverter. 
       hull() partialDiverter(); 
    }
}

module finalDiverter() {
    difference() {
        union() {
            //Connecting the partial diverter, coverguard, and not hollowed out tube.
            partialDiverter();
            coverGuard();
            tube();
        }
        //Hollowing out the tube and continuing it  through the diverter so that urine can flow. 
       translate([bucketDiameter*(cutoffAmount-0.5)-stage2Reduction/2,0,0]) cylinder(r=(stage2Reduction-tubeThick*2)/2, h=(diverterHeight+tubeLength)*2, center=true, $fn=sfn);
    }
}

module separation() {
    //Separating the diverter into two pieces by subtracting cubes from each side. 
    translate([0,0,bucketDiameter*(cutoffAmount-0.5)]) for(i = [1, -1]) {
        translate([(diverterHeight+distBetween)/2*i,distBetween/2*i,0]) rotate([0,90,90-90*i]) difference() {
            finalDiverter();
            translate([0,bucketDiameter/4*i,(diverterHeight+thickness*2)/-4]) cube([bucketDiameter, bucketDiameter/2, diverterHeight*2], center=true);
        }
    }
}

    
/*   translate([diverterHeight/2+distBetween,bucketDiameter/-4+thickness,0]) rotate([0,90,0]) difference() {
    fullDiverter();
    translate([0,bucketDiameter/-4,(diverterHeight+thickness*2)/-4]) cube([bucketDiameter, bucketDiameter/2, diverterHeight+thickness*2], center=true); */

module final() {
    scale([25.4, 25.4, 25.4])  {
        if(mode == 1) {
            separation();
        }
        else if(mode == 2) {
            translate([bucketDiameter*-(cutoffAmount-0.5),0,0]) finalDiverter();
        }
    }
}

final();

