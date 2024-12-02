onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CLOCK_50 -radix binary /testbench/CLOCK_50
add wave -noupdate -label KEY -radix binary /testbench/KEY
add wave -noupdate -label SW -radix binary /testbench/SW
add wave -noupdate -divider Input

add wave -noupdate -label state -radix binary /testbench/U1/state
add wave -noupdate -label playerHandVal -radix unsigned /testbench/U1/playerHandVal
add wave -noupdate -label dealerHandVal -radix unsigned /testbench/U1/dealerHandVal
add wave -noupdate -label balance -radix unsigned /testbench/U1/balance
add wave -noupdate -label betAmount -radix unsigned /testbench/U1/betAmount
add wave -noupdate -divider OnBoard

add wave -noupdate -label dealStart -radix binary /testbench/U1/dealStart
add wave -noupdate -label shufflstep -radix unsigned /testbench/U1/shuffler/step

add wave -noupdate -label cardAdr -radix unsigned /testbench/U1/cardAdr
add wave -noupdate -label cardGetOut -radix unsigned /testbench/U1/cardGetOut


add wave -noupdate -label refresh -radix unsigned /testbench/U1/refresh






TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 120
configure wave -valuecolwidth 60
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {120 ns}
