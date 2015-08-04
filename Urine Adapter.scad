// Credit to Laird Popkin and his 3D Model "2 Liter Bottle Holder with Funnel and Cap". In accordance with his license, this is licensed under CC-BY-SA 4.0. 
//Other than the threaded bottle holder, this was designed by Lucas Gelfond.

//Adapter parameters

//What size to adapt to, OD.
adapterToOD = 21.5;
//What size to adapt to, ID.
adapterToID = 17;
//Flat adapter length - the length of the adapter before it begins to convert.
flatAdapterLen = 5;
//Conversion adapter length - the length of the adapter as it converts the bottle to a certain size. 
convertAdapterLen = 10;
//Flat adapter length after conversion.
flatAdapterLen2 =25;
//Overlap
overlap = 1;
// resolution
sfn = 30;

clearance=0.4; // tune to get the right 'fit' for your printer

// Bottle params
bottleID=25.07;
bottleOD=27.4;
bottlePitch=2.7;
bottleHeight=9;
bottleAngle=2;
threadLen=15;

// holder params
holderOD=bottleOD+5;

// Bottle Computations
thickness = bottleOD-bottleID;
threadHeight = bottlePitch/3;
echo("thread height ",threadHeight);
echo("thread depth ",(bottleOD-bottleID)/2);

module thread() {
    cube([threadLen,bottleOD,threadHeight]);
}

module bottleNeck() {
	difference() {
		union() {
			translate([0,0,overlap/-2]) cylinder(r=bottleOD/2+clearance,h=bottleHeight+overlap);
			}
		union() {
            //The top row of threads. Rotates and moves them all a set distance.
            for (i = [0:3]) {
                    rotate([0, bottleAngle, i*90]) translate([threadLen/-2, 0, bottleHeight/2+(i*bottlePitch/4)]) thread();
                }
            //The bottom row of threads. Rotates and moves them all a set distance.
             for (i = [0:3]) {
                   rotate([0, bottleAngle, i*90]) translate([threadLen/-2, 0, bottleHeight/2+(i*bottlePitch/4)-bottlePitch]) thread();
              }
        }
	}
	translate([0,0,-overlap/2]) cylinder(r=bottleID/2+clearance,h=bottleHeight+overlap);
}

module bottleHolder() {
	difference() {
		cylinder(r=holderOD/2,h=bottleHeight);
		bottleNeck();
		}
	}


module adaptation() {
    difference() {
        union() {
           translate([0,0,(bottleHeight-thickness)/-2]) {
            bottleHolder();
           }
           translate([0,0,bottleHeight/2]) {
              difference() {
                  cylinder(r=holderOD/2, h=flatAdapterLen, $fn=sfn, center=true); 
                  cylinder(r=bottleOD/2, h=flatAdapterLen+1, $fn=sfn, center=true); 
              }
           }
           translate([0,0,(bottleHeight+flatAdapterLen+convertAdapterLen)/2]) {
               cylinder(r1 = holderOD/2, r2 = adapterToOD/2, h=convertAdapterLen, center=true, $fn=sfn);
           }
       }
        translate([0,0,(bottleHeight+flatAdapterLen+convertAdapterLen)/2]) {
               cylinder(r1 = bottleOD/2, r2 = adapterToID/2, h=convertAdapterLen+1, center=true, $fn=sfn);
        }
    }
}

module extension() {
    difference() {
        union() {
            adaptation();
            // why does /in by 12 work?
            translate([0,0,bottleHeight/2+flatAdapterLen/2+convertAdapterLen+flatAdapterLen2/2]) {
                cylinder(r=adapterToOD/2, h=flatAdapterLen2, $fn=sfn, center=true);
            }
        }
        translate([0,0,bottleHeight/2+flatAdapterLen/2+convertAdapterLen+flatAdapterLen2/2]) cylinder(r=adapterToID/2, h=flatAdapterLen2+1, $fn=sfn, center=true);
    }
}
echo("z raise", (bottleHeight/2+flatAdapterLen+convertAdapterLen+flatAdapterLen2)/2);

extension();