live_loop :foo do
  with_fx :echo, mix: 0.3 do
    sample :elec_tick if spread(2,7).tick
    
    pattern1 = (knit :a3, 1, :d3, 1, :g3, 1)
    pattern2 = (knit :a3, 1, :d3, 1, :g3, 1, :a0, 1)
    pattern3 = (knit :a3, 1, :d3, 1, :g3, 1, :a5, 1)
    
    structure = (knit pattern1, 128, pattern2, 32, pattern3, 32).tick(:structure)
    
    play (scale structure.tick(:notes), :major_pentatonic).choose, release: 0.2, amp: rrand(0.2, 0.3)
  end
  
  if spread(1,32).tick(:bass)
    synth :dark_ambience, note: [:a5, :d4, :g5, nil].choose, sustain: 4, release: 5
  end
  
  sleep 0.25
end

live_loop :kick do
  sample :bd_haus, cutoff: line(60,100).tick(:bd)
  sleep 1
end