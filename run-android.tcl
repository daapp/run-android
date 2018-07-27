#! /bin/sh
# \
exec wish "$0" ${1+"$@"}

set emulator "$env(HOME)/Library/Android/sdk/emulator/emulator"

proc quit {} {
    exit 0
}

proc emulator {args} {
    return [exec $::emulator {*}$args]
}

proc listAVDS {} {
    package require Tk
    set avds [string trim [emulator -list-avds]]
    listbox .avds
    pack .avds -fill both -expand true

    .avds insert end {*}$avds

    bind . <Escape> quit
    bind .avds <Double-Button-1> [list apply {{args} {
        set avd [.avds get [.avds curselection]]
        emulator -avd $avd &
    }}]

    wm title . "Run Android emulator ..."
    tk appname "Run Android"
}

proc runAVD {avd} {
    emulator @$avd
}

proc main {args} {
    if {[llength $args] == 0} {
        listAVDS
    } elseif {[llength $args] == 1} {
        runAVD [lindex $args 0]
    } else {
        package require Tk
        tk_messageBox -type ok -icon error -message "Usage: $::argv0 ?AVD?"
        exit 1
    }
}

main {*}$argv
