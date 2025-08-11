package provide sim_pkg 1.0
package require Tcl 8.0

namespace eval sim_pkg {
    variable top_module
    set top_module ""

    namespace export ctb
    namespace export set_top_module
}

proc sim_pkg::set_top_module {top_module} {
    set sim_pkg::top_module $top_module
}

proc sim_pkg::ctb {rel_top_dir} {
    vlib work
    vmap work work

    foreach lib $file_pkg::libs {
        vlib $lib
        vmap $lib $lib

        set sv_files [list]
        set vhdl_files [list]

        if { [dict exists $file_pkg::syn_files $lib] } {
            set files [dict get $file_pkg::syn_files $lib]
            foreach file $files {
                if { [file extension $file] == ".vhd" } {
                    lappend vhdl_files $rel_top_dir/$file
                } elseif { [file extension $file] == ".sv" } {
                    lappend sv_files $rel_top_dir/$file
                }
            }
        }
        if { [dict exists $file_pkg::verification_files $lib] } {
            set files [dict get $file_pkg::verification_files $lib]
            foreach file $files {
                if { [file extension $file] == ".vhd" } {
                    lappend vhdl_files $rel_top_dir/$file
                } elseif { [file extension $file] == ".sv" } {
                    lappend sv_files $rel_top_dir/$file
                }
            }
        }
        if { [dict exists $file_pkg::sim_files $lib] } {
            set files [dict get $file_pkg::sim_files $lib]
            foreach file $files {
                if { [file extension $file] == ".vhd" } {
                    lappend vhdl_files $rel_top_dir/$file
                } elseif { [file extension $file] == ".sv" } {
                    lappend sv_files $rel_top_dir/$file
                }
            }
        }

        if { [llength $vhdl_files] > 0 } {
            vcom -work $lib {*}$vhdl_files -2008
        }
        if { [llength $sv_files] > 0 } {
            vlog -work $lib {*}$sv_files -sv
        }
    }

    set lib_string "-L work"
    foreach lib $file_pkg::libs {
        append lib_string " -L $lib"
    }

    set command "vsim -sv_seed random $lib_string +access +r +w $sim_pkg::top_module"
    puts "Running: $command"
    eval $command

    do wave.do
    run -all
}
