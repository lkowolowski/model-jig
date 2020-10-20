/*
 * Jig to hold a model airplane while working on it.
 * ©Louis Kowolowski 2020
 */

module bar_screws (b_length, b_width, b_height, upper_slot_width, lower_slot_width, is_upper) {
	difference () {
		union () {
			color ("DarkGrey") {
				// whether we wnat to put the flange on the top or bottom half
				// of the bar (left and right are on the bottom, front and back
				// are on the top
				if ( is_upper == false ) {
					translate ([b_length, 0, 0]) {
						cube ([b_width/2, b_width, b_height/2]);
					}
				}
				else {
					translate ([b_length, 0, b_height/2]) {
						cube ([b_width/2, b_width, b_height/2]);
					}
				}
			}
		}
		union () {
			// first screw hole
			translate ([b_length+(b_width/4), b_width/4, 0]) screw (b_height, lower_slot_width, upper_slot_width);
			// second screw hole
			translate ([b_length+(b_width/4), b_width/4+b_width/2, 0]) screw (b_height, lower_slot_width, upper_slot_width);
		}
}
}
module screw (b_height, lower_slot_width, upper_slot_width) {
	color ("Red") {
		translate ([0, 0, b_height/2]) {
			cylinder(b_height/2+0.2, d=upper_slot_width, $fn=80);
		}
		translate ([0, 0, -0.1]) {
			cylinder(b_height/2+0.2, d=lower_slot_width, $fn=6);
		}
	}
}

module bar (b_length, b_width, b_height, upper_slot_width, lower_slot_width, is_upper, is_ext) {
	difference () {
		color ("DarkGrey") {
			cube ([b_length, b_width, b_height]);
			// guide rail
			translate ([b_width/4, b_width/4, b_height]) {
				cube([b_length-(b_width/2), guide_width, guide_height]);
			}
		}
		union () {
			// cutout for screw mount
			color ("Red" ) {
				// upper slot
				translate ([b_width/4, b_width/2-upper_slot_width/2, b_height/2]) {
					cube([b_length-(b_width/2), upper_slot_width, b_height+0.2]);
				}
				// lower slot
				translate ([b_width/4, b_width/2-lower_slot_width/2, -0.1]) {
					cube([b_length-(b_width/2), lower_slot_width, b_height+0.2]);
				}
			}
		}
	}
	if (is_ext == true) {
		translate ([-1*b_length-b_width/2, 0, 0]) bar_screws (b_length, b_width, b_height, upper_slot_width, lower_slot_width, false);
	}
	bar_screws (b_length, b_width, b_height, upper_slot_width, lower_slot_width, is_upper);
}

module base () {
	// left bar
	translate ([-1*(b_length+b_width/2), 0, 0]) bar (b_length, b_width, b_height, upper_slot_width, lower_slot_width, false, false);
	// right bar
	translate ([b_length+(b_width/2), b_width, 0]) rotate ([0, 0, 180]) bar (b_length, b_width, b_height, upper_slot_width, lower_slot_width, false, false);
	// rear bar
	translate ([-1*(b_width/2), b_length+b_width, 0]) rotate ([0, 0, 270]) bar (b_length, b_width, b_height, upper_slot_width, lower_slot_width, true, false);
	// extension bar
	translate ([b_width/2, -1*(b_length-b_width), 0]) rotate ([0, 0, 90]) bar (b_length-b_width, b_width, b_height, upper_slot_width, lower_slot_width, true, true);
	// front bar
	translate ([b_width/2, -2*b_length+b_width/2, 0]) rotate ([0, 0, 90]) bar (b_length, b_width, b_height, upper_slot_width, lower_slot_width, true, false);
}

/* Vertical adjustable section
 */
module vertical_jig (placement) {
	difference () {
		color ("DarkGrey") {
			cube([b_width, b_width, b_height]);
		}
		union () {
			color ("DarkGrey") {
				translate ([b_width/2-guide_width/2, -0.1, 0]) {
					cube([guide_width, b_width+0.2, guide_height]);
				}
				translate ([b_width/2, b_width/4, 0]) {
					cylinder(b_height+0.1, d=upper_slot_width, $fn=80);
				}
				translate ([b_width/2, b_width/4+b_width/2, 0]) {
					cylinder(b_height+0.1, d=upper_slot_width, $fn=80);
				}
			}
		}
	}
	translate ([0, b_width/2-b_height/2, b_height]) {
		vertical_bar (placement);
	}
}

module vertical_bar (placement) {
	difference () {
		// cross bar
		color ("DarkGrey") {
			translate ([0, b_width/9, 0]) {
				cube([b_width, b_height/4, b_length]);
			}
		}
		color ("Red") {
			translate ([b_width/2, b_width/9-0.1, b_height]) {
				cube([upper_slot_width, b_height+0.2, b_length-b_width/2]);
			}
		}
	}
	// side bar
	translate ([0, -1*b_width/2+b_width/3, 0]) {
		color ("DarkGrey") cube([b_height/4, b_width/2, b_length]);
	}
	if (placement != undef) {
		if (placement == "side") {
			// upper support
			translate ([0, -19, 0]) {
				upper_side_supports ();
			}
			translate ([0, -19, 0]) {
				lower_side_supports ();
			}
			// lower support
			translate ([0, -19, 100]) {
				upper_side_supports ();
			}
			translate ([0, -19, 100]) {
				lower_side_supports ();
			}
		} 
		if (placement == "rear") {
			// lower support
			translate ([0, -19, 0]) {
				lower_rear_supports ();
			}
			translate ([0, -19, 0]) {
				upper_rear_supports ();
			}
		}
		if (placement == "front") {
			// lower support
			translate ([0, -19, 0]) {
				front_supports ();
			}
		}
	}
}

module vertical_mounts () {
	// left vertical jig
	translate ([-1*b_length+b_width, 0, b_height]) rotate ([0, 0, 90]) vertical_jig ("side");
	// right vertical jig
	translate ([b_length-b_width, b_width, b_height]) rotate ([0, 0, 270]) vertical_jig ("side");
	// rear vertical jig
	translate ([-1*(b_width/2), b_length, b_height]) vertical_jig ("rear");
	// front vertical jig
	translate ([b_width/2, -2*b_length+2*b_width, b_height]) rotate ([0, 0, 180]) vertical_jig ("front");
}

module lower_side_supports () {
	union () {
		support_block ();
		// flange to hold model
		translate ([b_height/4, -1*b_width, b_width-b_width/4]) {
			color ("DarkGrey") cube([b_width-b_height/4, b_width*1.5, b_width/10]);
		}
	}
}
module upper_side_supports () {
	difference () {
		// top flange to hold model
		translate ([b_height/4, -1*b_width, 1.5*b_width]) {
			color ("DarkGrey") cube([b_width-b_height/4, b_width*1.5, b_width/10]);
		}
		union () {
			// magnet 1 (left)
			translate ([15, 15, 1.5*b_width-(b_width/10)+magnet_height+0.1]) {
				color ("Red") cylinder(magnet_height, d=magnet_diameter, $fn=80);
			}
			// magnet 2 (right)
			translate ([b_width-10, 15, 1.5*b_width-(b_width/10)+magnet_height+0.1]) {
				color ("Red") cylinder(magnet_height, d=magnet_diameter, $fn=80);
			}
		}
	}
}
module support_block () {
	difference () {
		// block at the back to hold magnet
		translate ([b_height/4, 0, b_width-b_width/4]) {
			color ("DarkGrey") cube([b_width-b_height/4, b_width/2, b_width/3]);
		}
		union () {
			// magnet 1 (left)
			translate ([15, 15, b_width+magnet_height]) {
				color ("Red") cylinder(magnet_height, d=magnet_diameter, $fn=80);
			}
			// magnet 2 (right)
			translate ([b_width-10, 15, b_width+magnet_height]) {
				color ("Red") cylinder(magnet_height, d=magnet_diameter, $fn=80);
			}
		}
	}
	// rod for wing-nut
	translate ([b_width/2+upper_slot_width/2, b_width/2+0.1, b_width]) {
		rotate ([270, 0, 0]) {
			color ("Red") cylinder(2*b_height, d=upper_slot_width, $fn=80);
		}
	}
}

module lower_rear_supports () {
	support_block ();
	// flange to hold model
	translate ([b_height/4, -1*b_width/2, b_width-b_width/4]) {
		color ("DarkGrey") cube([b_width-b_height/4, b_width, b_width/10]);
	}
	// left tail
	translate ([-1*b_width-8, -1*b_width, b_width-b_width/4]) {
		rotate ([0, 0, 20]) {
			color ("DarkGrey") cube([b_width*1.5, b_width/2, b_width/10]);
		}
	}
	translate ([-1*b_width-17, -1*b_width-27, b_width-b_width/4]) {
		color ("DarkGrey") cube([b_width-b_width/4, b_width, b_width/10]);
	}
	// right tail
	translate ([b_width-10, -1*b_width+b_width/2, b_width-b_width/4]) {
		rotate ([0, 0, -20]) {
			color ("DarkGrey") cube([b_width*1.5, b_width/2, b_width/10]);
		}
	}
	translate ([1.5*b_width+7, -1*b_width-27, b_width-b_width/4]) {
		color ("DarkGrey") cube([b_width-b_width/4, b_width, b_width/10]);
	}
}
module upper_rear_supports () {
	// rear top tail jig
	translate ([0, 0, b_width/2]) {
		difference () {
			union () {
				// flange to hold model
				translate ([b_height/4, -1*b_width/2, b_width-b_width/4]) {
					color ("DarkGrey") cube([b_width-b_height/4, b_width, b_width/10]);
				}
				// left tail
				translate ([-1*b_width-8, -1*b_width, b_width-b_width/4]) {
					rotate ([0, 0, 20]) {
						color ("DarkGrey") cube([b_width*1.5, b_width/2, b_width/10]);
					}
				}
				translate ([-1*b_width-17, -1*b_width-27, b_width-b_width/4]) {
					color ("DarkGrey") cube([b_width-b_width/4, b_width, b_width/10]);
				}
				// right tail
				translate ([b_width-10, -1*b_width+b_width/2, b_width-b_width/4]) {
					rotate ([0, 0, -20]) {
						color ("DarkGrey") cube([b_width*1.5, b_width/2, b_width/10]);
					}
				}
				translate ([1.5*b_width+7, -1*b_width-27, b_width-b_width/4]) {
					color ("DarkGrey") cube([b_width-b_width/4, b_width, b_width/10]);
				}
			}
			union () {
				// magnet 1 (left)
				translate ([15, 15, b_width-b_width/4-0.1]) {
					color ("Red") cylinder(magnet_height, d=magnet_diameter, $fn=80);
				}
				// magnet 2 (right)
				translate ([b_width-10, 15, b_width-b_width/4-0.1]) {
					color ("Red") cylinder(magnet_height, d=magnet_diameter, $fn=80);
				}
			}
		}
	}
}
module front_supports () {
	union () {
		support_block ();
		// flange to hold model
		translate ([b_height/4, -1*b_width, b_width-b_width/4]) {
			color ("DarkGrey") cube([b_width-b_height/4, b_width*1.5, b_width/10]);
		}
	}
	// v-slot for nose
	// left side
	translate ([b_width/2+2, -1*b_width, 42]) {
		rotate ([0, 225, 0]) {
			color ("DarkGrey") cube ([b_width, b_width, b_height/4]);
		}
	}
	// right side
	translate ([b_width/2+2, -1*b_width, 38]) {
		rotate ([0, -45, 0]) {
			color ("DarkGrey") cube ([b_width, b_width, b_height/4]);
		}
	}
}
