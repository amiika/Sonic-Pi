# https://web.archive.org/web/20071010092358/http://www.pernoergaard.dk/eng/strukturer/uendelig/ukonstruktion03.html

def norgard(i)
  arr = []
  (0..i).each do |a|
    bin = a.to_s(2).chars
    val = 0
    bin.each do |b|
      if b == "0" then
        val = -val
      else
        val += 1
      end
    end
    arr.push(val)
  end
  arr
end

n = norgard(100)

100.times do |i|
  play (scale :G, :chromatic)[n[i]]
  sleep 0.5
end