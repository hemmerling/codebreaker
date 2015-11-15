#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

    package require Tk
    switch $tcl_platform(platform) {
	windows {
            option add *Button.padY 0
	}
	default {
            option add *Scrollbar.width 10
            option add *Scrollbar.highlightThickness 0
            option add *Scrollbar.elementBorderWidth 2
            option add *Scrollbar.borderWidth 2
	}
    }
    
}

#############################################################################
# Visual Tcl v1.60 Project
#


#################################
# VTCL LIBRARY PROCEDURES
#

if {![info exists vTcl(sourcing)]} {
#############################################################################
## Library Procedure:  Window

proc ::Window {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global vTcl
    foreach {cmd name newname} [lrange $args 0 2] {}
    set rest    [lrange $args 3 end]
    if {$name == "" || $cmd == ""} { return }
    if {$newname == ""} { set newname $name }
    if {$name == "."} { wm withdraw $name; return }
    set exists [winfo exists $newname]
    switch $cmd {
        show {
            if {$exists} {
                wm deiconify $newname
            } elseif {[info procs vTclWindow$name] != ""} {
                eval "vTclWindow$name $newname $rest"
            }
            if {[winfo exists $newname] && [wm state $newname] == "normal"} {
                vTcl:FireEvent $newname <<Show>>
            }
        }
        hide    {
            if {$exists} {
                wm withdraw $newname
                vTcl:FireEvent $newname <<Hide>>
                return}
        }
        iconify { if $exists {wm iconify $newname; return} }
        destroy { if $exists {destroy $newname; return} }
    }
}
#############################################################################
## Library Procedure:  vTcl:DefineAlias

proc ::vTcl:DefineAlias {target alias widgetProc top_or_alias cmdalias} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global widget
    set widget($alias) $target
    set widget(rev,$target) $alias
    if {$cmdalias} {
        interp alias {} $alias {} $widgetProc $target
    }
    if {$top_or_alias != ""} {
        set widget($top_or_alias,$alias) $target
        if {$cmdalias} {
            interp alias {} $top_or_alias.$alias {} $widgetProc $target
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:DoCmdOption

proc ::vTcl:DoCmdOption {target cmd} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## menus are considered toplevel windows
    set parent $target
    while {[winfo class $parent] == "Menu"} {
        set parent [winfo parent $parent]
    }

    regsub -all {\%widget} $cmd $target cmd
    regsub -all {\%top} $cmd [winfo toplevel $parent] cmd

    uplevel #0 [list eval $cmd]
}
#############################################################################
## Library Procedure:  vTcl:FireEvent

proc ::vTcl:FireEvent {target event {params {}}} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## The window may have disappeared
    if {![winfo exists $target]} return
    ## Process each binding tag, looking for the event
    foreach bindtag [bindtags $target] {
        set tag_events [bind $bindtag]
        set stop_processing 0
        foreach tag_event $tag_events {
            if {$tag_event == $event} {
                set bind_code [bind $bindtag $tag_event]
                foreach rep "\{%W $target\} $params" {
                    regsub -all [lindex $rep 0] $bind_code [lindex $rep 1] bind_code
                }
                set result [catch {uplevel #0 $bind_code} errortext]
                if {$result == 3} {
                    ## break exception, stop processing
                    set stop_processing 1
                } elseif {$result != 0} {
                    bgerror $errortext
                }
                break
            }
        }
        if {$stop_processing} {break}
    }
}
#############################################################################
## Library Procedure:  vTcl:Toplevel:WidgetProc

proc ::vTcl:Toplevel:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }
    set command [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- [string tolower $command] {
        "setvar" {
            foreach {varname value} $args {}
            if {$value == ""} {
                return [set ::${w}::${varname}]
            } else {
                return [set ::${w}::${varname} $value]
            }
        }
        "hide" - "show" {
            Window [string tolower $command] $w
        }
        "showmodal" {
            ## modal dialog ends when window is destroyed
            Window show $w; raise $w
            grab $w; tkwait window $w; grab release $w
        }
        "startmodal" {
            ## ends when endmodal called
            Window show $w; raise $w
            set ::${w}::_modal 1
            grab $w; tkwait variable ::${w}::_modal; grab release $w
        }
        "endmodal" {
            ## ends modal dialog started with startmodal, argument is var name
            set ::${w}::_modal 0
            Window hide $w
        }
        default {
            uplevel $w $command $args
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:WidgetProc

proc ::vTcl:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }

    set command [lindex $args 0]
    set args [lrange $args 1 end]
    uplevel $w $command $args
}
#############################################################################
## Library Procedure:  vTcl:toplevel

proc ::vTcl:toplevel {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {set _modal 0}
}
}


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .top43
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 1
    }
    namespace eval ::widgets::$base.lab44 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.lab45 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.lab46 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.ent47 {
        array set save {-background 1 -textvariable 1}
    }
    namespace eval ::widgets::$base.lis48 {
        array set save {-background 1 -listvariable 1}
    }
    namespace eval ::widgets::$base.but49 {
        array set save {-command 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$base.but50 {
        array set save {-command 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$base.but51 {
        array set save {-command 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$base.but52 {
        array set save {-command 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$base.m55 {
        array set save {-activeborderwidth 1 -borderwidth 1 -tearoff 1}
        namespace eval subOptions {
            array set save {-label 1 -menu 1}
        }
    }
    set site_3_0 $base.m55
    namespace eval ::widgets::$site_3_0.men56 {
        array set save {-activeborderwidth 1 -borderwidth 1 -tearoff 1}
        namespace eval subOptions {
            array set save {-command 1 -label 1 -menu 1}
        }
    }
    set site_3_0 $base.m55
    namespace eval ::widgets::$site_3_0.men58 {
        array set save {-activeborderwidth 1 -borderwidth 1 -tearoff 1}
        namespace eval subOptions {
            array set save {-command 1 -label 1}
        }
    }
    set base .top44
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 1
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
        }
        set compounds {
        }
        set projectType single
    }
}
}

#################################
# USER DEFINED PROCEDURES
#
#############################################################################
## Procedure:  main

proc ::main {argc argv} {}

#############################################################################
## Initialization Procedure:  init

proc ::init {argc argv} {}

init $argc $argv

#################################
# VTCL GENERATED GUI PROCEDURES
#

proc vTclWindow. {base} {
    if {$base == ""} {
        set base .
    }
    ###################
    # CREATING WIDGETS
    ###################
    wm focusmodel $top passive
    wm geometry $top 200x200+78+78; update
    wm maxsize $top 1024 745
    wm minsize $top 124 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm withdraw $top
    wm title $top "vtcl-1.6.1a1-win32-i386"
    bindtags $top "$top Vtcl-1.6.1a1-win32-i386 all"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top43 {base} {
    if {$base == ""} {
        set base .top43
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $top -class Toplevel \
        -menu "$top.m55" 
    wm focusmodel $top passive
    wm geometry $top 444x403+273+180; update
    wm maxsize $top 1024 725
    wm minsize $top 124 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "New Toplevel 1"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    label $top.lab44 \
        -text CodeBreaker 
    vTcl:DefineAlias "$top.lab44" "Label1" vTcl:WidgetProc "Toplevel1" 1
    label $top.lab45 \
        -text {Enter Your 4-digit Guess here:} 
    vTcl:DefineAlias "$top.lab45" "Label2" vTcl:WidgetProc "Toplevel1" 1
    label $top.lab46 \
        -text Result: 
    vTcl:DefineAlias "$top.lab46" "Label3" vTcl:WidgetProc "Toplevel1" 1
    entry $top.ent47 \
        -background white -textvariable "$top\::ent47" 
    vTcl:DefineAlias "$top.ent47" "Entry1" vTcl:WidgetProc "Toplevel1" 1
    listbox $top.lis48 \
        -background white -listvariable "$top\::lis48" 
    vTcl:DefineAlias "$top.lis48" "Listbox1" vTcl:WidgetProc "Toplevel1" 1
    button $top.but49 \
        -command button1Cmd_command -pady 0 -text Guess 
    vTcl:DefineAlias "$top.but49" "Button1" vTcl:WidgetProc "Toplevel1" 1
    button $top.but49.but53 \
        -pady 0 -text button 
    vTcl:DefineAlias "$top.but49.but53" "Button5" vTcl:WidgetProc "Toplevel1" 1
    button $top.but50 \
        -command button2Cmd_command -pady 0 -text {New Game} 
    vTcl:DefineAlias "$top.but50" "Button2" vTcl:WidgetProc "Toplevel1" 1
    button $top.but50.but54 \
        -pady 0 -text button 
    vTcl:DefineAlias "$top.but50.but54" "Button6" vTcl:WidgetProc "Toplevel1" 1
    button $top.but51 \
        -command button3Cmd_command -pady 0 -text About 
    vTcl:DefineAlias "$top.but51" "Button3" vTcl:WidgetProc "Toplevel1" 1
    button $top.but52 \
        -command button4Cmd_command -pady 0 -text Exit 
    vTcl:DefineAlias "$top.but52" "Button4" vTcl:WidgetProc "Toplevel1" 1
    menu $top.m55 \
        -activeborderwidth 1 -borderwidth 1 -tearoff 1 
    $top.m55 add cascade \
        -menu "$top.m55.men56" -label File 
    set site_3_0 $top.m55
    menu $site_3_0.men56 \
        -activeborderwidth 1 -borderwidth 1 -tearoff 0 
    $site_3_0.men56 add command \
        -command exitCmd -label Exit 
    $site_3_0.men56 add command \
        -command vtcl_codebreaker::aboutCmd -label About 
    $top.m55 add cascade \
        -menu "$top.m55.men58" -label Play 
    set site_3_0 $top.m55
    menu $site_3_0.men58 \
        -activeborderwidth 1 -borderwidth 1 -tearoff 0 
    $site_3_0.men58 add command \
        -command newGameCmd -label New_Game 
    $site_3_0.men58 add command \
        -command newSelfdefinedGame \
        -label {New Game with user defined Secret Number} 
    $site_3_0.men58 add command \
        -command hintCmd -label Hint 
    $site_3_0.men58 add command \
        -command guessCmd -label Guess 
    ###################
    # SETTING GEOMETRY
    ###################
    place $top.lab44 \
        -in $top -x 100 -y 10 -width 218 -height 44 -anchor nw \
        -bordermode ignore 
    place $top.lab45 \
        -in $top -x 35 -y 80 -width 163 -height 24 -anchor nw \
        -bordermode ignore 
    place $top.lab46 \
        -in $top -x 30 -y 145 -width 168 -height 34 -anchor nw \
        -bordermode ignore 
    place $top.ent47 \
        -in $top -x 40 -y 115 -width 156 -height 19 -anchor nw \
        -bordermode ignore 
    place $top.lis48 \
        -in $top -x 25 -y 185 -width 181 -height 131 -anchor nw \
        -bordermode ignore 
    place $top.but49 \
        -in $top -x 255 -y 110 -width 99 -height 41 -anchor nw \
        -bordermode ignore 
    place $top.but49.but53 \
        -in $top.but49 -x 10 -y 35 -anchor nw -bordermode ignore 
    place $top.but50 \
        -in $top -x 255 -y 165 -width 99 -height 36 -anchor nw \
        -bordermode ignore 
    place $top.but50.but54 \
        -in $top.but50 -x 15 -y 85 -anchor nw -bordermode ignore 
    place $top.but51 \
        -in $top -x 255 -y 220 -width 99 -height 36 -anchor nw \
        -bordermode ignore 
    place $top.but52 \
        -in $top -x 255 -y 270 -width 99 -height 41 -anchor nw \
        -bordermode ignore 

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top44 {base} {
    if {$base == ""} {
        set base .top44
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $top -class Toplevel
    wm withdraw $top
    wm focusmodel $top passive
    wm geometry $top 609x422+220+159; update
    wm maxsize $top 1024 745
    wm minsize $top 124 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm title $top "New Toplevel 2"
    vTcl:DefineAlias "$top" "Toplevel2" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

#############################################################################
## Binding tag:  _TopLevel

bind "_TopLevel" <<Create>> {
    if {![info exists _topcount]} {set _topcount 0}; incr _topcount
}
bind "_TopLevel" <<DeleteWindow>> {
    if {[set ::%W::_modal]} {
                vTcl:Toplevel:WidgetProc %W endmodal
            } else {
                destroy %W; if {$_topcount == 0} {exit}
            }
}
bind "_TopLevel" <Destroy> {
    if {[winfo toplevel %W] == "%W"} {incr _topcount -1}
}

Window show .
Window show .top43
Window show .top44

main $argc $argv
