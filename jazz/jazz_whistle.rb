use_bpm 115

T = 4.0

define :markovChain do |a, h|
  return h[a].sample
end

define :nextNote do |key, chain|
  set key, (markovChain (get[key]), chain)
  return get[key]
end

set :note, 1
set :soloNote, 1
set :whistleNote, 1

sc_root = :c
sc_type = :ionian
sc = scale(sc_root, sc_type)

#subs = [:major7, :minor7, :minor7, :major7, :dom7, :minor7, :m7b5]
subs = [:major7, :minor7, :minor7, :major7, :dom7, :minor7, :dim7]

H = {
  1 => [4,4,5,5,6,6,2,3,1,7],
  2 => [5,5,4,4,6,6,1,3,7],
  3 => [6,6,4,4,1,2,5],
  4 => [5,5,1,1,2,2,3,6,7],
  5 => [1,1,4,4,6,6,2,3],
  6 => [2,2,5,5,3,3,4,4,1],
  7 => [1,5]
}

live_loop :chords do
  sync :swing
  use_synth :piano
  note = nextNote :note, H   # choose next note in chain and update state
  if one_in(3)
    use_octave -1
  else
    use_octave 0
  end
  midiNote = degree(note, sc_root, sc_type)
  print note
  print midiNote
  print subs[note-1]
  
  #play chord_degree(note, sc_root, sc_type), release: 2, pan: rrand(-1,0, step: 0.25), pan_slide: 0.5, amp: 1, cutoff: 85
  play chord(midiNote,subs[note-1]), release: 2, pan: rrand(-1,0, step: 0.25), pan_slide: 0.5, amp: 1, cutoff: 85
  
  sleep [3.7, 4].choose
end

with_fx :reverb, room: 0.7, damp: 1, amp: 0.5 do
  live_loop :solo do
    sync :swing
    note = nextNote :soloNote, H
    
    midiNote = degree(note, sc_root, sc_type)
    c = chord_degree(note, sc_root, sc_type, 7)
    #c = chord(midiNote,subs[note-1], num_octaves: 2)
    
    use_synth :pluck
    play c[rrand_i(6,7)], release: rrand(1,2), attack: rrand(0,0.2)
    sleep [0.25,0.5].choose
    play c[rrand_i(1,3)], release: rrand(1,2), attack: rrand(0,0.2)
    sleep [0.25,0.5].choose
    play c[rrand_i(4,5)], release: rrand(1,2), attack: rrand(0,0.2)
    sleep [0.25,0.5].choose
    play c[1], release: rrand(1,2), attack: rrand(0,0.2)
    sleep [0.25,0.5].choose
    
    note = nextNote :soloNote, H
    
    c = chord_degree(note, sc_root, sc_type, 7)
    midiNote = degree(note, sc_root, sc_type)
    #c = chord(midiNote,subs[note-1], num_octaves: 2)
    
    play c[7], release: rrand(1,2), attack: rrand(0,0.2)
    sleep [0.25,0.5].choose
    play c[3], release: rrand(1,2), attack: rrand(0,0.2)
    sleep [0.25,0.5].choose
    play c[5], release: rrand(1,2), attack: rrand(0,0.2)
    sleep [0.25,0.5].choose
    play c[1], release: rrand(1,2), decay: 2, attack: rrand(0,0.2)
    sleep [0.25,0.5].choose
    
  end
end

with_fx :reverb, room: 0.7, damp: 1, amp: 0.5 do
  live_loop :whistle do
    sync :swing
    note = nextNote :whistleNote, H
    
    midiNote = degree(note, sc_root, sc_type)
    c = chord_degree(note, sc_root, sc_type, 7)
    #c = chord(midiNote,subs[note-1], num_octaves: 2)
    g = synth :beep, note: c[3],  release: rrand(2,3), attack: rrand(0,0.2), amp: 0.5, slide: 2, cutoff: 70
    #play c[rrand_i(6,7)]
    sleep [0.25,0.5].choose
    control g, note: c[7]
    sleep [0.5].choose
    #g = synth :beep, note: c[1],  release: rrand(1,2), attack: rrand(0,0.2), amp: 0.5, slide: 3, cutoff: 70
    sleep [0.25,0.5].choose
    #control g, note: c[5]
    sleep [2].choose
    
    note = nextNote :whistleNote, H
    
    c = chord_degree(note, sc_root, sc_type, 7)
    midiNote = degree(note, sc_root, sc_type)
    #c = chord(midiNote,subs[note-1], num_octaves: 2
    g = synth :beep, note: c[1],  release: rrand(2,3), attack: rrand(0,0.2), amp: 0.5, slide: 2, cutoff: 70
    sleep [0.5].choose
    control g, note: c[7]
    sleep [0.5].choose
    #g = synth :beep, note: c[5],  release: rrand(1,2), attack: rrand(0,0.2), amp: 0.5, slide: 3, cutoff: 70
    sleep [0.25,0.5].choose
    # control g, note: c[7]
    sleep [2].choose
    
  end
end

# Todo: Fix distortion
with_fx :reverb do
  live_loop :bass do
    sync :swing
    note = nextNote :note, H
    use_synth :fm
    use_octave -2
    play (chord_degree note, sc_root, sc_type)[0], amp: 0.2, pan: rrand(-1,0, step: 0.25)
    sleep 1
    play (chord_degree note, sc_root, sc_type, 5).choose, amp: 0.2, pan: rrand(-1,0, step: 0.25)
    sleep [0.7,1].choose
    play (chord_degree note, sc_root, sc_type)[(ring 1,2,3).choose], amp: 0.2, pan: rrand(-1,0, step: 0.25)
    sleep [0.7,1].choose
    note = nextNote :note, H
    play (chord_degree note, sc_root, sc_type)[0] + (ring -2,-1,1,2).choose, amp: 0.2, pan: rrand(-1,0, step: 0.25)
    sleep [0.7,1].choose
  end
end

live_loop :swing do
  sample :elec_filt_snare, amp: 0.05, beat_stretch: 0.3
  sample :drum_cymbal_soft, amp: 0.1
  sleep 1
  sample :drum_cymbal_soft, amp: 0.1
  sleep 0.7
  sample :drum_cymbal_soft, amp: 0.1
  sleep 0.3
end
