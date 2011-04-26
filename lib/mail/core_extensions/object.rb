class Object
  def blank?
    if respond_to?(:empty?)
      empty?
    else
     !self
    end
  end
end
