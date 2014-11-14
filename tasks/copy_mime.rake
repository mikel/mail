desc "Copy data from mime_types gem"
task :copy_mime do
  require 'mime/types'

  caches = {}
  types = MIME::Types.send(:__types__)
  [:@extension_index, :@type_variants].each do |t|
    h = caches[t] = {}
    types.instance_variable_get(t).
      each do |k, vs|
        v = vs.first
        h[k] = [v.to_s, v.binary?]
      end
  end

  File.open("lib/mail/mime_type_cache.rb", 'wb') do |f|
    f.puts 'class Mail::MimeType'
    caches.each do |t, h|
      f.puts "  #{t} = {"
      h.map do |k, v|
        s, binary = v
        f.puts "    #{k.inspect} => #{'Binary.' if binary}new(#{s.inspect}),"
      end
      f.puts "  }"
    end
    f.puts 'end'
  end
end

