# https://gist.github.com/emlyn/33f72346e8f6abb25dd34ad4e85ed4c9

# Next note higher or equal to base note n, that is in the chord c
define :next_note do |n, c|
  # Make sure n is a number
  n = note(n)
  # Get distances to each note in chord, add smallest to base note
  n + (c.map {|x| (note(x) - n) % 12}).min
end

ukulele = [:g, :c, :e, :a]
guitar_standard = [:e2, :a2, :d3, :g3, :b3, :e4]

# Return ring representing the chord chrd, as played on a guitar with given tuning
define :guitar do |tonic, name, tuning=guitar_standard|
  chrd = (chord tonic, name)
  # For each string, get the next higher note that is in the chord
  c = tuning.map {|n| next_note(n, chrd)}.ring
  # We want the lowest note to be the root of the chord
  root = note(chrd[0])
  first_root = c.take_while {|n| (n - root) % 12 != 0}.count
  # Drop up to half the lowest strings to make that the case if possible
  if first_root > 0 and first_root < tuning.count / 2
    c = (ring :r) * first_root + c.drop(first_root)
  end
  # Display chord fingering
  #puts c.zip(tuning).map {|n, s| if n == :r then 'x' else (n - note(s)) end}.join, c
  c
end

# Strum a chord with a certain delay between strings
define :strum do |c, d=0.1|
  in_thread do
    play_pattern_timed c.drop_while{|n| [nil,:r].include? n}, d
  end
end

use_debug false
use_bpm 120

live_loop :guit do
  #chords = ring((guitar :d, :m7), (guitar :g, '7'), (guitar :c, :M7), (guitar :f, :M7),
  #              (guitar :b, :m7), (guitar :e, '7'), (guitar :a, :m7))
  chords = ring((guitar :G, '6'),
                (guitar :Ab, :dim7),
                (guitar :A, :minor7),
                (guitar :D, '7'),
                (guitar :G, :M),
                (guitar :Bb, :dim),
                (guitar :A, '7'))
  with_fx :reverb do
    with_fx :lpf, cutoff: 115 do
      with_synth :pluck do
        tick
        "UD..D.".split(//).each do |s|
          if s == 'D' # Down stroke
            strum chords.look, 0.01
          elsif s == 'U' # Up stroke
            with_fx :level, amp: 0.5 do
              strum chords.look.reverse, 0.015
            end
          end
          sleep 0.25
        end
      end
    end
  end
end