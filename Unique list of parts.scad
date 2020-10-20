/*
 * Jig to hold a model airplane while working on it.
 *
 * Vertical sections slide horizonally. Horizontal dimensions are scalable
 * by adding one or more extension bars.
 *
 * Wing supports clamp magnetically. Be sure to glue some felt on the 
 * insides of the wing supports to protect the model
 *
 * ©Louis Kowolowski 2020
 */

/*
 * Include globals and modules
 */
include <Globals.scad>;
include <Modules.scad>;

// render all together
rotate ([0, 0, 270]) bar (b_length, b_width, b_height, upper_slot_width, lower_slot_width, true, false);

translate ([70, -30, 0]) rotate ([0, 0, 270]) bar (b_length-b_width, b_width, b_height, upper_slot_width, lower_slot_width, true, true);

translate ([130, -50, 0]) vertical_jig ();

translate ([0, -290, -30]) lower_rear_supports ();
translate ([0, -370, -60]) upper_rear_supports ();

translate ([150, -170, -30]) lower_side_supports ();
translate ([150, -270, -60]) upper_side_supports ();

translate ([250, -270, -30]) front_supports ();
