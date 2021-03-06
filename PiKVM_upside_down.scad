include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/pcb.scad>

include <NopSCADlib/vitamins/pillars.scad>
use <NopSCADlib/utils/layout.scad>
$fn=32;
//
// reference:
//
// PCI Express Card Electromechanical Specification
// Revision 1.1, March 28, 2005, pp 71-80
//
aeps = 0.001;
mth  =   0.86; sv01 = 112.75; sv02 = 2.54; sv03 = 21.59;
sv04 =  11.43; sv05 =  19; sv06 = 5.08; sv07 =  4.42; //18.42
sv08 =  89.90; sv09 =  10.16; sv10 = 4.56; sv11 =  4.11;
sv12 = 120.02; 
mtt  = 2 * mth;

module ribs() {
    brd = sv05 / 10;
    for (x=[3, 7]) {
    translate([x * brd, sv01 - sv08 - sv09, mth / 2])
    rotate([270, 0, 0])
        difference() {
            union() {
                linear_extrude(height=sv08 - brd)
                scale([1, (.5 * brd) / (1 * brd)])
                circle(r=1 * brd);
                rotate([0, 90, 0])
                scale([1, 1, (2 * brd) / (1 * brd)])
                sphere(r = (1 * brd) / 2);
                translate([0, 0, sv08 - brd])
                rotate([0, 90, 0])
                scale([1, 1, (2 * brd) / (1 * brd)])
                sphere(r = (1 * brd) / 2);
            }
            translate([-brd * 2,-brd * 3, -brd] / 2)
            cube([brd * 2, brd, sv08 + brd] * (1 + aeps));
        }
    }
}

module triangle(tri) {
    linear_extrude(height=tri[2]){
        polygon(points=[[0,0],[tri[0],0],[tri[0],tri[1]]]);
    }
}

module pc_bracket() {
    
    

    // bracket
    translate([-mth, -sv05, -sv01])
    rotate([90, 0, 90])
    difference() {
        // connector opening
        union() {
       
       translate([0, sv12, 0])
       mirror([0, 1, 0])
       union() {      
            // top tab
            translate([21.5, sv01, aeps])
            mirror([1,0,0])
            rotate([270, 0, 0])
            difference() {
                translate([2.54, 0, 0])
                linear_extrude(height=mth) {
                    translate([17.55, 9.93]) circle(r=1.5);
                    translate([1.5, 9.93]) circle(r=1.5);
                    polygon(points=[[0, 0], [0, 0], [19.05, 0], [19.05, 0], [19.05, 9.93], [17.55, 11.43], [1.5, 11.43], [0, 9.93]], paths=[[0,1,2,3,4,5,6,7]]);
                }
                translate([sv05, sv06, -mth / 2]) {
                    cylinder(d=sv07, h=mtt);
                    translate([0, -sv07 / 2,0]) 
                    cube([sv07, sv07, mtt]);
                }
            }
            // tab to bracket offset
            translate([sv02+16.5, sv01 - sv10 + mth, 0])
            mirror([1,0,0])
            linear_extrude(height=mth)
            polygon(points=[[0, 0], [0, 0], [16.4443, 0], [19.05, 2.60571], [19.05, 4.56], [19.05, 4.56], [0, 4.56], [0, 4.56]], paths=[[0,1,2,3,4,5,6,7]]);
            // tab fillet
            translate([sv02-2.5, sv01 - 1.25, 0])
            mirror([0, 1, 1])
            rotate([0, 90, 0])
            linear_extrude(height=sv03 - sv02)
            polygon(points=[[0, 0], [1.25, 0], [1.25, 1.25]], paths=[[0, 1 ,2]]);
            // bracket
            linear_extrude(height=mth) {
                polygon(points=[[0, 4], [4, 0], [14.42, 0], [19, 4], [sv05, 109.054], [sv05, 109.054], [2.5, 109.054], [0, 106.554]], paths=[[0,1,2,3,4,5,6,7]]);
            }
            //end tab
            bty = sv12 - sv01;
            translate([sv11, -bty + aeps, 0])
            linear_extrude(height=mth) {
                translate([1.5, 1.5]) circle(r=1.5);
                translate([8.7, 1.5]) circle(r=1.5);
                polygon(points=[[0, 1.5], [1.5, 0], [8.7, 0], [10.2, 1.5], [10.2, 7.27], [10.2, 7.27], [0, 7.27], [0, 7.27]], paths=[[0,1,2,3,4,5,6,7]]);
            }            
            // ribs
            ribs();
        }
            
            
            // board mount
            translate([sv05, sv01, -aeps])
            rotate([0, -90, 180])
            linear_extrude(height=mth+0.5)
            square([pcb_length(RPI4) + mtt  + 35, pcb_width(RPI3) + 6 + pcb_width(B101) + sv10]);
            
            //inside angle bracket
            translate([mtt + mth, sv01, mth])
            rotate([90, 0, 0])
            triangle([sv05 - mtt, (sv05 * 2) - 3, mtt]);
            //middle angle bracket
            translate([0, pcb_width(RPI3)+pcb_width(B101) - 17, mth])
            rotate([90, 0, 0])
            triangle([sv05, (sv05 * 2) - 3, mtt]);
            //outside angle bracket
            translate([0, sv01 - pcb_width(RPI3) - 6 - pcb_width(B101) - 4.5 + mtt - .06, mth])
            rotate([90, 0, 0])
            triangle([sv05, (sv05 * 2) - 3, mtt]);
        }
    }
}

module rpipillar(x, y, z) {
        translate([x,y,z])
        rotate([90,0,0])
        pillar(["RPI_Pillar", "RPI_Pillar", 2.3, 2,5.5/cos(30),5.5/cos(30),6, 6,  grey20,   grey20,  -6, 0]);
}
module rpipillarhole(x, y, z) {
        translate([x,y+2,z])
        rotate([90,0,0])
        pillar(["RPI_PillarH", "RPI_PillarH", 0.1, 5,2.7,2.7,6, 6,  grey20,   grey20,  -2, 0]);
}
module bbpillar(tri) {
        rotate([90,0,0])
        pillar(["BB_Pillar", "BB_Pillar", 1.5, 2,5.5/cos(30),5.5/cos(30),6, 6,  grey20,   grey20,  -6, 0]);
}


difference() {
    union(){
        pc_bracket();
        
        
        rpipillar(pcb_length(RPI4)-3,0,-96); //-8
        rpipillar(pcb_length(RPI4)-3,0,-pcb_width(RPI4)+9);
        rpipillar(+24,0,-pcb_width(RPI4)+9);
        rpipillar(+24,0,-96);
        
        
        
        rpipillar(+3.8,0,-5.8);
        rpipillar(pcb_length(B101)-2.6,0,-5.8);
        rpipillar(pcb_length(B101)-2.6,0,-pcb_width(B101)+0.6);
        rpipillar(+3.8,0,-pcb_width(B101)+0.6);


        translate([pcb_length(B101)+4.5,0,-5.8])
        bbpillar();
        translate([pcb_length(B101)+4.5,0,-pcb_width(B101)+0.6])
        bbpillar();
        translate([pcb_length(B101)+4.5+28.5,0,-5.8])
        bbpillar();
        translate([pcb_length(B101)+4.5+28.5,0,-pcb_width(B101)+0.6])
        bbpillar();
        translate([pcb_length(B101)+4.5+28.5+34,0,-pcb_width(B101)+0.6])
        bbpillar();
        translate([pcb_length(B101)+4.5+28.5+34,0,-5.8])
        bbpillar();
        translate([pcb_length(B101)+4.5+2.5+34,0,-pcb_width(B101)+0.6])
        bbpillar();
        translate([pcb_length(B101)+4.5+2.5+34,0,-5.8])
        bbpillar();
        
        translate([pcb_length(B101)+4.5+28.5+34,0,-47])
        bbpillar();
        translate([pcb_length(B101)+4.5+2.5+34,0,-47])
        bbpillar();
        
        translate([pcb_length(B101)+4.5+28.5+34,0,-70])
        bbpillar();
        translate([pcb_length(B101)+4.5+2.5+34,0,-70])
        bbpillar();
        
        translate([pcb_length(B101)+4.5+28.5+34,0,-97])
        bbpillar();
        translate([pcb_length(B101)+4.5+2.5+34,0,-97])
        bbpillar();
        
    }
    translate([(pcb_length(RPI4) / 2) + .52, -1.5, -71.5]) {
        rotate([90, 180, 0])
        pcb(RPI4);
        //pcb_cutouts(RPI4);
        //pcb_components(RPI4, true);
       
       
        //rj45 cutout
        scale([1.02,1.03,1.02])
        translate([-40,-1.5,-17.5])
        rotate([90, 180, 0])
        rj45(cutout = false);
        
        //usb cutout
        scale([1.08,1.08,1.08])
        translate([-40,-1.5,17.6])
        rotate([90, 180, 0])
        usb_Ax2(cutout = false);
        
        //usb cutout
        scale([1.08,1.08,1.18])
        translate([-40,-1.5,0.5])
        rotate([90, 180, 0])
        usb_Ax2(cutout = false);
        
    }
    
    translate([(pcb_length(B101) / 2) + .52, -1.5, -20]) {
        rotate([90, 180, 0])
        pcb(B101);
        //pcb_cutouts(B101);
        //#pcb_components(B101, false);
        
        
        
        //hdmi in
        scale([1.1,1.2,1.1])
        translate([-25,-0.8,0])
        rotate([90, 180, 0])
        hdmi(hdmi_full);

    }
    
    translate([28,-2,-98.5])
    color([0,1,0])
    cube([50,10,55]);
    
    translate([6,-2,-90])
    color([0,1,0])
    cube([30,10,38]);
    
    translate([2.5,-2,-30])
    color([0,0,1])
    cube([80,10,20]);
    
    translate([95,-2,-92])
    color([0,0,1])
    cube([15,10,85]);
    
    rpipillarhole(pcb_length(RPI4)-3,0,-96);
    rpipillarhole(pcb_length(RPI4)-3,0,-pcb_width(RPI4)+9);
    rpipillarhole(+24,0,-pcb_width(RPI4)+9);
    rpipillarhole(+24,0,-96);
        
    rpipillarhole(+3.8,0,-5.8);
    rpipillarhole(pcb_length(B101)-2.6,0,-5.8);
    rpipillarhole(pcb_length(B101)-2.6,0,-pcb_width(B101)+0.6);
    rpipillarhole(+3.8,0,-pcb_width(B101)+0.6);
    
}



