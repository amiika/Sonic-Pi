# https://www.youtube.com/watch?v=Dtsb8KS41_k&t=550s
# https://en.wikipedia.org/wiki/Per_N%C3%B8rg%C3%A5rd
use_synth :saw
use_bpm 300
rjump = (-10..10)
jumps = Array.new(10) { choose(rjump) }
print jumps
pattern = jumps.inject([60]) { |acc,j|
  first = acc.map{|n| n + j}
  print first
  second = acc.zip(first).flatten
  print second
  second
}

play_pattern pattern
