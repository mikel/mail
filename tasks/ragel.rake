load 'lib/mail/parsers.rb'

require 'erb'
rl_template_path = 'lib/mail/parsers/template.rl.erb'
PARSER_TEMPLATE = ERB.new(File.read(rl_template_path))

def generate_rb_ragel_file(parser_name)
  PARSER_TEMPLATE.result(binding)
end


# Ragel action definitions depend on action and field declarations
file 'lib/mail/parsers/rb_actions.rl' => 'lib/mail/parsers.rb' do
  actions = Mail::Parsers::ACTIONS.each_with_index.map do |action, idx|
    "action #{action} { actions.push(#{idx}, p) }"
  end

  actions_rl = "%%{\nmachine rb_actions;\n#{actions * "\n"}\n}%%"

  File.write 'lib/mail/parsers/rb_actions.rl', actions_rl
end

# All RFC 5322 parsers depend on ABNF core rules
rule /rfc5322_.+\.rl\z/ => 'lib/mail/parsers/rfc5234_abnf_core_rules.rl'

# RFC 5322 parser depends on its submodules
file 'lib/mail/parsers/rfc5322.rl' => FileList['lib/mail/parsers/rfc5322_*.rl']

# Ragel parser template depends on Ragel actions and RFC 5322 machine
file rl_template_path => %w[ lib/mail/parsers/rb_actions.rl lib/mail/parsers/rfc5322.rl ]

# Ragel parsers depend on the ERb template
rule /_machine\.rl\z/ => rl_template_path do |t|
  parser_name = File.basename(t.name, '_machine.rl')
  File.write t.name, generate_rb_ragel_file(parser_name)
end

# Ruby parsers depend on Ragel parsers
rule /_machine\.rb\z/ => '.rl' do |t|
  sh "ragel -s -R -F1 -o #{t.name} #{t.source}"
end

# Dot files for Ragel parsers
rule /_machine\.dot\z/ => '.rl' do |t|
  sh "ragel -s -V -o #{t.name} #{t.source}"
end

rule /_machine\.svg\z/ => '.dot' do |t|
  sh "dot -v -Tsvg -Goverlap=scale -o #{t.name} #{t.source}"
end

ruby_parser_paths = Mail::Parsers::FIELD_PARSERS.map do |p|
  "lib/mail/parsers/#{p}_machine.rb"
end

svg_paths = Mail::Parsers::FIELD_PARSERS.map do |p|
  "lib/mail/parsers/#{p}_machine.svg"
end

desc "Generate Ruby parsers from Ragel definitions"
namespace :ragel do
  task :generate => ruby_parser_paths
  task :svg => svg_paths
end

task :ragel => 'ragel:generate'
