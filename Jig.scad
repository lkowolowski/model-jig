/*
 * Jig to hold a model airplane while working on it.
 *
 * Vertical sections slide horizonally. Horizontal dimensions are scalable
 * by adding one or more extension bars.
 *
 * Wing supports clamp magnetically. Be sure to glue some felt on the 
 * insides of the wing supports to protect the model
 *
 * All units are in mm
 *
 * ©Louis Kowolowski 2020
 */

/* Include globals and modules
 */
include <Globals.scad>;
include <Modules.scad>;

// render all together
base ();
vertical_mounts ();
