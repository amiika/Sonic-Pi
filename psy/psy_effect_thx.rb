time = 10
wait_time = (time / 3)
synths = []
rand_note = -> { rrand(note(:A2), note(:A4)) }

with_fx :normaliser, amp: 0.5 do
  use_synth :dsaw
  30.times do
    # collect the synths in an array for controlling later
    synths << lambda {
      play(rand_note.call, detune: rrand(0,1),
           detune_slide: time,
           sustain: time,
           pan: rrand(0, 1)) }.call
  end
  
  sleep wait_time
  
  synths.each do |t|
    if (rrand(0.0, 1.0) > 0.5)
      # some go up
      t.control note: 70, note_slide: rrand(wait_time, (time - 2)), detune: 0.1
    else
      # others go down
      t.control note: 46, note_slide: rrand(wait_time, (time - 2)), detune: 0.1
    end
  end
end