unless defined?(ActiveSupport)
  module ActiveSupport
    module ShimInsertedByMail; end

    Multibyte = Mail::Multibyte
  end
end
