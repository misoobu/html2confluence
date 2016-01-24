require "./lib/html2confluence"
require "rubypython"
require "json"

USERNAME = ""
PASSWORD = ""
WIKI_SITE = ""

# input source
html = nil

open "./sample.html" do |file|
  html = file.read
end

# convert
parser = HTMLToConfluenceParser.new
parser.feed(html)
wiki_markup = parser.to_wiki_markup

# post for test
RubyPython.start

python_json = RubyPython.import("json")
PythonConfluenceAPI = RubyPython.import("PythonConfluenceAPI")
python_api = PythonConfluenceAPI.ConfluenceAPI.new(USERNAME, PASSWORD, WIKI_SITE)

python_result = python_api.create_new_content({
  "type":  "page",
  "title": "テスト投稿 (#{Time.now})",
  "space": { "key": "LOL" },
  "body":  {
    "storage": {
      "value": wiki_markup,
      "representation": "wiki"
    }
  }
})

json = python_json.dumps(python_result).rubify

RubyPython.stop

hash = JSON.parse(json)
p hash
