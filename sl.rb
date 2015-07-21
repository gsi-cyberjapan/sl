require 'open-uri'
require 'json'

def process(entry, stack)
  case entry['type']
  when 'LayerGroup'
    stack.push(entry['title'])
    entry['entries'].each {|child|
      process(child, stack)
    }
    stack.pop
  when 'Layer'
    stack.push(entry['title'])
    print "#{stack.join('::')}\n"
    stack.pop
  end
end

[0, 1, 2, 3, 4, '_experimental'].each {|e|
  url = "http://gsi-cyberjapan.github.io/gsimaps/layers_txt/layers#{e}.txt"
  JSON.parse(open(url).read)['layers'].each {|entry|
    process(entry, [])
  }
}
