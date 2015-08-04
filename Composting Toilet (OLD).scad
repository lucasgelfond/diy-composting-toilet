//Buckets
    //The thickness of the buckets.
    bucketThick = 0.075;
    //The bottom diameter of the buckets. Buckets are a less extreme version of a cone, hence the top diameter variable as well.
    bucketBottomDiameter = 10.33;
    //The top diameter of the buckets. Buckets are a less extreme version of a cone, hence the bottom diameter variable as well.
    bucketTopDiameter = 11.91;
    //The height of the buckets.
    bucketHeight = 14.5;
    //The distance between the two buckets.
    distBuckets = 2.5;
    
//Coco Coir
    //The diameter of the hole for the coco coir bucket.
    cocoBucketDiam = 6;
    //The size of the coco coir.
    cocoCoirSize = 5;

//Wood board
    //The thickness of all wood boards.
    boardThick = 1/2;
    //The height of the wood boards and in turn, toilet as a whole.
    boardHeight = 18;
    //The width of the wood boards and in turn, toilet as a whole.
    boardWidth = 16;
    //The length of the wood boards and in turn, toilet as a whole.
    boardLength = 28;

//Toilet seat
    //The length of the toilet seat.
    toiletSeatLength = 12;
    //The width of the toilet seat.
    toiletSeatWidth = 10;
    //The thickness of the toilet seat.
    toiletSeatThick = 2;
    //The border of the toilet seat.
    toiletSeatBorder = 3.5;

//Screws
    //The size of the screw head.
    screwHeadSize = 0.35;
    //The size of the thread for the screw, diameter.
    screwThreadSize = 0.15;
    //The length of the thread.
    screwThreadLength = 1;
    //Amount of screws on the height side.
    screwsHeight = 11;
    //Amount of screws on the width side.
    screwsWidth = 17;
    //Amount of screws on the length side.
    screwsLength = 16;
//Fan
    //Size of the fan
    fanSize = 92/25.4;
    fanHoleSize = 5/25.4;
    fanBorder = 5/25.4;
    fanThick = 8/25.4;
    fanRaise = 3.5;
    overlap = 5/25.4;
    

//Technical Variables
    //Resolution for general cylinders.
    sfn = 35;
    //Resolution for screw cylinders/sphere. 
    screwSFN = 6;
    
    

//Hidden/computed variables
    corner = 1;
   //The translation to get pieces to the edges of the box. These are x, y, and z sides to get things from the center to the edge of the box. 
    xt = (boardWidth-boardThick)/2;
    yt = (boardLength-screwThreadLength+boardThick)/2;
    zt = (boardHeight+boardThick)/2;
    //General rotation for length, width and height.
    lr = [90, 0, 180];
    wr = [0, 90, 180];
    hr = [0, 180, 90];
    //Screw rotation for length, width and height.
    srl = [0,0,90];
    srw = [0,0,180];
    srh = [0, 180, 90];
    //Calculated values - screw distance (length, width, or height) side.
    sdls = (boardLength-boardThick)/(screwsLength);
    sdws = (boardWidth)/(screwsWidth + corner);
    sdhs = (boardHeight)/(screwsHeight + corner);
    //Total amount of screws.
    totalScrews = (screwsHeight+screwsWidth+screwsLength)*4;
    //Bucket diameter average
    bucketDiamAvg = (bucketTopDiameter+bucketBottomDiameter)/2;

module bucket() {
    //Orange color that looks like the Homer's bucket
    color([226/255, 99/255, 51/255]) {
        difference() {
        //Making the bucket like a cone, gradually decreasing in size - this is the bucket if it were solid. 
            cylinder(r1=bucketBottomDiameter/2, r2=bucketTopDiameter/2, h=bucketHeight+bucketThick, center=true, $fn = sfn);
        //Moving it up so that the bucket has a bottom - not cutting the bottom out.  Hollowing out the bucket, but leaving the thickness on all sides. 
            translate([0,0,bucketThick]) cylinder(r1=(bucketBottomDiameter-bucketThick*2)/2, r2=
(bucketTopDiameter-bucketThick*2)/2, h=bucketHeight+2*bucketThick, center=true, $fn = sfn);  
        }
    }
}

module woodPiece1() {
    //The side, width x height pieces.
    cube([boardThick, boardWidth, boardHeight], center=true);
}

module woodPiece2() {
    //The side, length x height pieces.
    cube([boardThick, boardLength, boardHeight], center=true);
}

module woodPiece3() {
    //The top/bottom, length x width pieces.
    cube([boardWidth, boardLength, boardThick], center=true);
}
module woodPiece4() {
    //The top, length x width pieces, with cutouts.
    difference() {
        //The top piece used as a base.
        translate([0,0,boardHeight/2]) woodPiece3();
    //Cutting a hole for the toilet bucket. Moving it to the same position as the bucket, but higher.
        translate([0,(distBuckets+bucketTopDiameter)/-2,boardHeight/2]) cylinder(r1=bucketBottomDiameter/2, r2=bucketTopDiameter/2, h=bucketHeight+bucketThick, center=true, $fn = sfn);
    //Cutting a hole for the coco coir bucket. Moving it to the same position as the bucket, but higher.
        translate([0,(distBuckets+bucketTopDiameter)/2,boardHeight/2]) cylinder(r=cocoBucketDiam/2, h=bucketHeight+bucketThick, center=true, $fn = sfn);
    }
}

module woodScrew() {
    //The screws used around the boxes.
    color("Black", 1) {
        rotate([90,0,0]) {
            difference() {
                //Starting off with a sphere, to make the screw head.
                translate([0,0,(screwThreadLength/2)]) sphere($fn=screwSFN, r=screwHeadSize/2, center=true);
                //Cutting off half of the sphere - posititioned to to cut off the bottom half. 
                translate([0,0,(screwThreadLength/2-screwHeadSize/4)]) cube([screwHeadSize, screwHeadSize, screwHeadSize/2], center=true);
            }
            //The threads for the screws. 
            translate([0,0,0]) cylinder(r=screwThreadSize/2, h=screwThreadLength, $fn=screwSFN, center=true);
        }
    }
}
module woodScrewsCorner(screwRot, numScrews, screwDist) {
    //If there are an even amount of screws:
    if (numScrews % 2 == 0) {
        //Run this script for half as many screws as we have because for every time this runs, we get two screws (plus 2 already in the middle, hence the -2).
        for(i = [1:(numScrews-2)/2], n=[1, -1]) {
                //The 
                rotate(screwRot) {
                    //The middle screws - *n  makes them go to the opposite side (making the coordinates positive or negative).
                    translate([0,0, screwDist/2*n]) woodScrew();
                    //The screws outside of the two middles. The distance is * n so that screws go on either side, and * i for each new set of two screws (playing in with the for loop). Plus 0.5 because we don't want screws where the two middle ones are. 
                    translate([0,0, screwDist*n*(i+0.5)])  woodScrew();
            }
        }
    }
    
    //Or, if there are an odd amount of screws:
    else if(numScrews % 2 > 0) {
        //Run this half as many as there are screws, -1 for the screw in the middle.
        for(i = [1:(numScrews-1)/2], n = [1, -1]) {
            rotate(screwRot) {
                //Middle screw.
                  woodScrew();
                //The screws outside of the middle. The distance is * n so that screws go on either side, and * i for each new set of two screws (playing in with the for loop).
                  translate([0,0, screwDist*i*n]) woodScrew();
            }
        }
    }
}



module woodScrews(t1, t2, t3, wr, screwRot, numScrews, screwDist) {
    //Positioning the screw arrangements.
    translate([t1, t2, t3]) {
        rotate(wr) {
            woodScrewsCorner(screwRot, numScrews, screwDist);
        }
    }
}

module woodEnclosure() {
    //Coloring the wood
    color([102/255, 51/255, 0/255]) {
        //A  full assembly of the box
        translate([0, (boardLength-boardThick)/2, 0]) {
            rotate([0,0,90]) {
                woodPiece1();
            }
        }
        translate([0, (boardLength-boardThick)/-2, 0]) {
            rotate([0,0,90]) {
                woodPiece1();
            }
        }
      translate([(boardWidth-boardThick)/2,0,0]) {
            rotate([0,0,0]) {
                woodPiece2();
            }
        }
      translate([(boardWidth-boardThick)/-2,0,0]) {
            rotate([0,0,0]) {
                woodPiece2();
            }
        }
      translate([0,0,(boardHeight+boardThick)/-2]) {
          woodPiece3();
      }
      translate([0,0,boardThick/2]) {
        woodPiece4();
      }
   }
}
module toiletSeat() {
    //Making the toilet seat from scratch.
    color("White", 1) {
        difference() {
            //Scaling and stretching a cylinder.
            scale([toiletSeatLength/toiletSeatWidth, 1,1]) {
                cylinder(r=toiletSeatWidth/2, center=true, $fn=sfn);
            }
            //Cutting out the middle of the toilet.
            translate([toiletSeatBorder/2, 0, 0]) {
                scale([toiletSeatLength/(toiletSeatWidth-toiletSeatBorder), 1,1.5]) {
                    cylinder(r=(toiletSeatWidth-toiletSeatBorder)/2, center=true, $fn=sfn);
                }
            }
        }
        //Adding the cover. 
        translate([(toiletSeatLength-toiletSeatThick/2)/-2, 0, (toiletSeatLength-toiletSeatThick/2)/2]) {
            rotate([0, 90, 0]) {
                scale([toiletSeatLength/toiletSeatWidth, 1,1]) {
                    cylinder(r=toiletSeatWidth/2, center=true, $fn=sfn);
                }
            }
        }   
    }
}

module cocoCoir() {
    color([228/255,  143/255, 63/255]) {
        translate([0,(distBuckets+bucketTopDiameter)/2,(boardHeight-cocoCoirSize*3+boardThick)/-2]) {
            rotate([45,0,0]) {
                //Weird cone coco coirs.
                cylinder($fn=9, center=true, r1=cocoCoirSize/2, r2=0, h=cocoCoirSize*2.5);
            }   
            rotate([225, 0,90]) {
                cylinder($fn=9, center=true, r1=cocoCoirSize/2, r2=0, h=cocoCoirSize*2.5);
            }
        }
    }
}

module urineDiversion() {
    //Importing my old urine diverter. 
    color([0/255, 109/255, 186/255]) {
        translate([boardThick/2,(distBuckets+bucketTopDiameter)/-2,(boardHeight)/2]) {
            scale([1/25.4, 1/25.4, 1/25.4]) {
                rotate([0,0,180]) {
                    import("/Users/lucasgelfond/Desktop/Composting Toilet/Urine Diversion.stl");
                }
             }
        }
    }
}
module caseFan() {
    color("Black", 1) {
        difference() {
            minkowski() {
                cube([fanSize, fanSize, fanThick], center=true);
                cylinder(r=fanHoleSize/2, h= fanThick, $fn=sfn, center=true);
            }
            minkowski() {
                cube([fanSize-fanBorder*2, fanSize-fanBorder*2, fanThick+overlap], center=true);
                cylinder(r=fanHoleSize/2, h= fanThick, $fn=sfn, center=true);
            }
            for(i = [1, -1], n=[1,-1]) {
                translate([(fanSize-fanBorder/3)/2*i, (fanSize-fanBorder/3)/2*n, 0]) cylinder(r=fanHoleSize/2, h=fanThick+overlap*2, $fn=sfn, center=true);
            }
        }
         cylinder(r=(fanSize-fanBorder)/2, h=fanThick*2, $fn=sfn, center=true);
    }
}

module poopBucket() {
    difference() {
        bucket();
        translate([0,(bucketDiamAvg-fanThick-overlap)/2,fanRaise]) cube([fanSize, fanThick+ bucketBottomDiameter, fanSize], center=true);
    }
    translate([0,(bucketDiamAvg+fanThick*2-overlap)/2,fanRaise]) rotate([90,0,0]) caseFan();
}

module step1() {
    color([102/255, 51/255, 0/255]) {
        translate([boardHeight/1.5, -boardWidth]) rotate([0,90,0]) woodPiece1();
        translate([-boardHeight/1.5, -boardWidth]) rotate([0,90,0]) woodPiece1();
        translate([boardHeight/1.5,boardLength/1.5,0]) rotate([0,90,0]) woodPiece2();
        translate([boardHeight/-1.5,boardLength/1.5,0]) rotate([0,90,0]) woodPiece2();
        translate([boardHeight*-2.5,-boardWidth,0]) rotate([0,0,90]) woodPiece3();
        translate([boardHeight*-2.5,boardWidth,boardHeight/-2]) rotate([0,0,90]) woodPiece4();
    }
    translate([boardWidth*2,boardLength/-2,bucketHeight/2]) bucket();
    translate([boardWidth*2,boardLength/2,bucketHeight/2]) bucket();
    translate([boardHeight*-2.5,0,0]) toiletSeat();
    translate([boardWidth*-2,(distBuckets+bucketTopDiameter)/2,(boardHeight)/-2]) urineDiversion();
}

module compostingToilet() {
    //Full assembly of the toilet.
    woodEnclosure();
    translate([0,(distBuckets+bucketTopDiameter)/2,(boardHeight-bucketHeight+bucketThick+boardThick)/-2]) bucket();
    translate([0,(distBuckets+bucketTopDiameter)/-2,(boardHeight-bucketHeight+bucketThick+boardThick)/-2]) rotate([0,0,180]) poopBucket();
    translate([0, (distBuckets+bucketTopDiameter)/-2, (boardHeight+toiletSeatThick)/2 ]) toiletSeat();
    for (i = [0, -180], x = [1, -1], y = [1, -1], z = [1, -1]) {
        woodScrews(0, yt/y, zt/z, wr, srw+[0,0,i], screwsWidth, sdws);
        woodScrews(xt/x, 0, zt/z, lr, srl+[i,0,0], screwsLength, sdls);
        woodScrews(xt/x, yt/y, 0, hr, srh+[i,0,0], screwsHeight, sdhs);
    }
    urineDiversion();
    cocoCoir();
}



compostingToilet();
echo("Total screws: ", totalScrews); 
