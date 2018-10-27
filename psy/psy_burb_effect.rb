#https://gist.github.com/xavriley/d842d4ad56fe5c1dc225

live_loop :dr do
  sample :bd_haus
  sleep 0.5
end

live_loop :noisy do
  with_fx :bitcrusher do
    density 2 do
      with_fx :slicer, probability: 0.5, phase: 0.25 do
        mysound = synth :fm,
          divisor: 1,
          divisor_slide: 1,
          depth: 2,
          depth_slide: 1,
          release: 0.0,
          sustain: 5,
          note: (scale :c2, :phrygian).choose
        
        control(mysound, divisor: 1.6666, depth: 15)
        sleep 1
        control(mysound, divisor: 1, depth: 2)
        sleep 1
        control(mysound, divisor: 1.6666, depth: 15)
        sleep 1
        control(mysound, divisor: 1, depth: 2)
        sleep 1
      end
    end
  end
end