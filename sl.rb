# coding: utf-8
require 'open-uri'
require 'json'
require 'time'
require 'net/http'
require 'action_view'

I18n.enforce_available_locales = false
$av = ActionView::Base.new

def name(entry, stack)
  return unless entry['url'].include?('/{z}/{x}/{y}')
  print "#{stack.join('::')}\n"
end

def mokuroku_urls(entry, stack)
  r = entry['url'].split('/{z}/{x}/{y}')
  return if r.size == 1
  print "#{r[0]}/mokuroku.csv.gz\n"
end

def mokuroku_paths(entry, stack)
  r = entry['url'].split('/{z}/{x}/{y}')
  return if r.size == 1
  print "#{r[0].sub('http://cyberjapandata.gsi.go.jp', '')}/mokuroku.csv.gz\n"
end

def mokuroku_info(entry, stack)
  r = entry['url'].split('/{z}/{x}/{y}')
  return if r.size == 1
  server = r[0].split('/')[2]
  path = r[0].split(server)[1] + '/mokuroku.csv.gz'
  proxy_host, proxy_port =
    (ENV['http_proxy'] || '').sub(/http:\/\//, '').split(':')
  Net::HTTP.Proxy(proxy_host, proxy_port).start(server) {|http|
    resp = http.head(path)
    s = [
      resp.code == '200' ? '○' : '☓',
      path.sub('/xyz/', '').sub('/mokuroku.csv.gz', '')
    ]
    if resp.code == '200'
      s << [
        Time.parse(resp['last-modified']).localtime.to_s.sub(' +0900', ''),
        $av.number_to_human_size(resp['content-length'])
      ]
    else
      s << ['-', '-']
    end
    s << stack.join('/')
    print s.join(','), "\n"
  }
end

def min_zoom(entry, stack)
  return unless entry['url'].include?('{z}/{x}/{y}')
  mz = entry['minZoom']
  print [mz, entry['url']].join(' '), "\n"
end

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
    $methods.each {|method|
      send(method, entry, stack)
    }
    stack.pop
  end
end

$methods = ARGV.map{|v| v.start_with?('--') ? v[2..-1].to_sym : nil}.compact
$methods = [
  :mokuroku_info
] if $methods.size == 0

[0, 1, 2, 3, 4, '_experimental'].each {|e|
  url = "http://gsi-cyberjapan.github.io/gsimaps/layers_txt/layers#{e}.txt"
  JSON.parse(open(url).read)['layers'].each {|entry|
    process(entry, [])
  }
}
