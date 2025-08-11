package provide file_pkg 1.0
package require Tcl 8.0

namespace eval file_pkg {
    namespace export add_sim add_syn add_verification_files source_file_lists add_libs print_file_summary

    variable sim_files
    set sim_files [dict create]

    variable verification_files
    set verification_files [dict create]

    variable syn_files
    set syn_files [dict create]

    variable libs
    set libs [list]
}

proc file_pkg::add_sim {library files} {
    if {[dict exists $file_pkg::sim_files $library]} {
        dict lappend file_pkg::sim_files $library $files
    } else {
        dict set file_pkg::sim_files $library $files
    }
}

proc file_pkg::add_syn {library files} {
    if {[dict exists $file_pkg::syn_files $library]} {
        dict lappend file_pkg::syn_files $library $files
    } else {
        dict set file_pkg::syn_files $library $files
    }
}

proc file_pkg::add_verification_files {library files} {
    if {[dict exists $file_pkg::verification_files $library]} {
        dict lappend file_pkg::verification_files $library $files
    } else {
        dict set file_pkg::verification_files $library $files
    }
}

proc file_pkg::add_libs {libs} {
    lappend file_pkg::libs $libs
}

proc file_pkg::source_file_lists {rel_top_dir} {
    foreach lib $file_pkg::libs {
        set file_list "$rel_top_dir/ip/$lib/tcl/${lib}_file_list.tcl"
        if { [file exists $file_list] == 1 } {
            source $file_list
        }
    }
}

proc file_pkg::print_file_summary {} {
    puts "Synthesis Files:"
    dict for {lib files} $file_pkg::syn_files {
        puts "    Lib: $lib"
        foreach file $files {
            puts "        File: $file"
        }
    }

    puts "Simulation Files:"
    dict for {lib files} $file_pkg::sim_files {
        puts "    Lib: $lib"
        foreach file $files {
            puts "        File: $file"
        }
    }

    puts "Verification Files:"
    dict for {lib files} $file_pkg::verification_files {
        puts "    Lib: $lib"
        foreach file $files {
            puts "        File: $file"
        }
    }
}
