# RFC 6532 extensions rely on RFC 3629 UTF-8 chars
rule 'lib/mail/parsers/rfc5234_abnf_core_rules.rl' => 'lib/mail/parsers/rfc3629_utf8.rl'

# All RFC 5322 parsers depend on ABNF core rules
rule %r|rfc5322_.+\.rl\z| => 'lib/mail/parsers/rfc5234_abnf_core_rules.rl'

# RFC 5322 parser depends on its submodules
file 'lib/mail/parsers/rfc5322.rl' => FileList['lib/mail/parsers/rfc5322_*.rl']

rule %r|_parser\.rl\z| => 'lib/mail/parsers/rfc5322.rl'

# Ruby parsers depend on Ragel parser definitions
# (remove -L to include line numbers for debugging)
rule %r|_parser\.rb\z| => '%X.rl' do |t|
  sh "ragel -s -R -L -F1 -o #{t.name} #{t.source}"
  sh "bundle exec rufo --simple-exit #{t.name}"
end

# Dot files for Ragel parsers
rule %r|_parser\.dot\z| => '%X.rl' do |t|
  sh "ragel -s -V -o #{t.name} #{t.source}"
end

rule %r|_parser\.svg\z| => '%X.dot' do |t|
  sh "dot -v -Tsvg -Goverlap=scale -o #{t.name} #{t.source}"
end

desc "Generate Ruby parsers from Ragel definitions"
namespace :ragel do
  ragel_parsers = FileList['lib/mail/parsers/*_parser.rl']
  task :generate => ragel_parsers.ext('.rb')
  task :svg => ragel_parsers.ext('.svg')
end

task :ragel => 'ragel:generate'
