
require "bundler/setup"

$:.unshift "lib"

def local?
  ENV["LOCAL"]
end

def print(content)
  STDOUT.print content
  STDOUT.flush
end

task :login do

  # Ignore login if we are in local-mode (testing)
  next if local?

  require "mechanize"
  $agent = Mechanize.new do |agent|
    agent.user_agent_alias = 'Linux Firefox'
  end

  if ENV["EDIT_URL"].nil? or ENV["EDIT_URL"].empty?
    $stderr.puts "We need the EDIT_URL. It can be something like https://talkerapp.com/accounts/XXXX/plugins/YYYY/edit"
    exit 1
  end

  class <<$agent
    def get_edit_form
      get ENV["EDIT_URL"]
    end
  end

  loop do
    # Login into Talkerapp
    login_page = $agent.get("http://talkerapp.com/login")
    print "User: "
    user = STDIN.readline.strip
    print "Password: "

    require "io/console"
    password = STDIN.noecho { STDIN.readline.chomp }
    puts

    after_login =
      login_page.form_with(:action => '/session') do |form|
        form.email = user
        form.password = password
      end.click_button

    if after_login.title =~ /^rooms/i
      puts "Logged in!"
      break
    else
      puts "Invalid login"
    end
  end
end

def generate_and_upload

  # Generate the plugin source
  snippets = 
    Dir["snippets/*.{js,coffee}"].map do |filename|
      content = File.read filename
      content = CoffeeScript.compile(content) if filename =~ /coffee$/i

      puts "Added #{filename}"
      "function(event) { #{content} }"
    end

  full_js = File.read("template.js").gsub("$snippets", "[" + snippets.join(",") + "]")
  File.write("generated.js", full_js)

  # Upload it

  print "Getting the edit form ... "
  form = $agent.get_edit_form.forms.first
  puts "Done"

  print "Uploading it ... "
  form["plugin[source]"] = full_js
  form.submit
  puts " Done"
end

task :guard => :login do
  require "coffee-script"
  require "rb-inotify"
  require "json"

  # Generate a version with the current content

  generate_and_upload

  # Watch for changes

  notifier = INotify::Notifier.new

  Dir["snippets/*.{js,coffee}"].each do |filename|
    notifier.watch(filename, :modify, :delete_self) {|event| generate_and_upload }
  end

  notifier.watch("snippets", :moved_to, :create, :delete) {|event| generate_and_upload }

  notifier.run
end

task :default => :guard
