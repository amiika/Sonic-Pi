use_synth :saw

with_fx :krush do
  with_fx :reverb do
    with_fx :ixi_techno, phase: 10 do
      c = chord :c, :major
      d = chord :d, :major
      e = chord :e, :major
      print c
      play c, attack: 2, release: 5, decay: 2, sustain: 3, pitch: -10
      sleep 10
      play d, attack: 2, release: 5, decay: 2, sustain: 3, pitch: -10
      sleep 10
      play e, attack: 2, release: 5, decay: 2, sustain: 3, pitch: -10
    end
  end
end