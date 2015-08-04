//Buckets
    //The thickness of the buckets.
    bucketThick = 0.075;
    //The bottom diameter of the buckets. 
    bucketBottomDiameter = 10.5;
    //The top diameter of the buckets. 
    bucketTopDiameter = 11.5;
    //The height of the buckets.
    bucketHeight = 14.5;
    
//Wood board
    //The thickness of all wood boards.
    boardThick = 1/2;
    //The height of the wood boards and in turn, the toilet as a whole.
    boardHeight = 20;
    //The width of the wood boards and in turn, the toilet as a whole.
    boardWidth = 20;
    //The length of the wood boards and in turn, the toilet as a whole.
    boardLength = 20;
  
//Toilet seat
    //The length of the toilet seat.
    toiletSeatLength = 18.76;
    //The width of the toilet seat.
    toiletSeatWidth = 14;
    //The thickness of the toilet seat.
    toiletSeatThick = 2+5/16;
    //The border of the toilet seat.
    toiletSeatBorder = 6;
    //The amount to move the seat forward
    seatForward = 1.5;
    
//Fan
    //Size of the fan
    fanSize = 92/25.4;
    fanHoleSize = 0.125;
    fanBorder = 0.25;
    fanThick = 0.33;
    distFromEdgeFan = 1.75;

 //Hinge
    hingePieceWidth = 0.75;
    hingePieceLength = 1.5;
    hingePieceThick = 0.0625;
    hingeHole = 0.125;
    hingeHoleDistLength = 7/16;
    hingeHoleDistWidth = 0.1;
    
    hinges = 3;
    
//Hidden/technical variables
    corner = 1;
    overlap = 0.2;
    sfn = 35; 
    
//Modules
hingeDist = 8;

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
        translate([seatForward,0, boardHeight/2]) cylinder(r1=bucketBottomDiameter/2, r2=bucketTopDiameter/2, h=bucketHeight+bucketThick, center=true, $fn = sfn);
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

module urineDiversion() {
    //Importing my old urine diverter. 
    color([0/255, 109/255, 186/255]) {
        translate([boardThick/2+seatForward,0 ,(bucketHeight)/2]) {
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

module hingePiece() {
    difference() {
        cube([hingePieceLength, hingePieceWidth, hingePieceThick], center=true);
        for(i = [1,-1], n=[-1:1]) {
            translate([(hingeHole/2+hingeHoleDistLength)*n,(hingeHole/2+hingeHoleDistWidth)*i,0]) cylinder(r=hingeHole/2, h=hingePieceThick*2, center=true, $fn=sfn);
        }
    }
}
module hinge() {
    color("Grey", 1) {
        difference() {
            union() {
                translate([0, (hingePieceWidth+hingePieceThick*2)/2,0])  hingePiece();
                rotate([0,90,0]) cylinder(r=hingePieceThick, h=hingePieceLength, center=true, $fn=sfn);
                rotate([90,0,0]) translate([0, (hingePieceWidth+hingePieceThick*2)/-2,0]) hingePiece();
            }
        }  
    }
}

module hinges() {
    if (hinges % 2 == 0) {
        for(i = [1:(hinges-2)/2], n=[1, -1]) {
                //The 
            translate([boardWidth/2, boardLength/-2, (hingePieceLength+hingeDist/2)/2*n]) rotate([0,90,0]) hinge();
            translate([boardWidth/2, boardLength/-2, (hingeHole+hingeDist+hingePieceLength*2)/2*(i+0.5)*n])  rotate([0,90,0]) hinge();
            }
        }
    
    else if(hinges % 2 > 0) {
        for(i = [1:(hinges-1)/2], n = [1, -1]) {
            translate([boardWidth/2, boardLength/-2, 0])  rotate([0,90,0]) hinge();
            translate([boardWidth/2, boardLength/-2, hingePieceLength/2*n+(hingePieceLength+hingeDist)/2*i*n])  rotate([0,90,0]) hinge();
        }
    }
}




module final() {
    woodEnclosure();
    translate([seatForward,0,(boardHeight-bucketHeight-bucketThick)/-2]) bucket();
    translate([seatForward,0,(boardHeight+toiletSeatThick)/2]) toiletSeat();
    hinges();
    translate([(boardWidth-fanSize-distFromEdgeFan)/-2, (boardLength-fanSize-distFromEdgeFan)/-2, (boardHeight)/2+fanThick*2]) caseFan();
    urineDiversion();
    
}


final();
    