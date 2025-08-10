package provide scripts_sim 1.0
package require Tcl 8.0

namespace eval scripts_sim {
    namespace export add_sim print_sim_libs

    variable sim_files
    set sim_files [dict create]
}

proc scripts_sim::add_sim {library files} {
    if {[dict exists $scripts_sim::sim_files $library]} {
        dict lappend scripts_sim::sim_files $library $files
    } else {
        dict set scripts_sim::sim_files $library $files
    }
    scripts_sim::print_sim_libs
}

proc scripts_sim::print_sim_libs {} {
    dict for {lib files} $scripts_sim::sim_files {
        puts "Lib: $lib"
        foreach file $files {
            puts "File: $file"
        }
    }
}
