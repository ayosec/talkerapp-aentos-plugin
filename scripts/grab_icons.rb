
require "nokogiri"
require "net/http"
require "css_parser"
require "json"

CSS = CssParser::Parser.new
CSS.load_uri! "http://www.emoji-cheat-sheet.com/style.css"

j(Nokogiri::HTML.
    parse(Net::HTTP.get(URI.parse("http://www.emoji-cheat-sheet.com/"))).
    search(".emoji").to_a.each_with_object({}) do |node, hash|
      id = node.attr("id")
      styles = CSS.find_by_selector("#" + id).detect {|i| i =~ /^background-position:/ }
      if styles
        hash[node.parent.at(".name").inner_text] = styles.split(":").last.strip
      end
    end)
