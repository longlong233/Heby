for i in ObjectSpace.each_object(Class).select { |cls| cls < Object } do
  begin
    i.prepend(Module.new do
      def | other
        return [nil, self, other]
      end
    end)
  rescue
  end
end
Array.prepend(Module.new do
  def | other
    return self.push other
  end
  def [] other
    if other.is_a? Array
      len = other.length
      if len == 3
        return self[other[1]..other[2]]
      elsif len > 3
        return self[other[1]..other[2]] * other[3]
      else
        super(other)
      end
    elsif other.is_a? String
      if self[0] == nil
        return self[1..~self] * other
      else
        return self[0..~self - 1] * other
      end
    else
      super(other)
    end
  end
  def ~
    if self[0] == nil
      return self.length - 1
    else
      return self.length
    end
  end
end)
def say_single(a)
  if a.is_a? Array
    puts a[" | "]
  else
    puts a
  end
end
def say(*a)
  a.each{|i| say_single i}
end
def cyber(a)
  if a.is_a? Integer
    return a.chr(Encoding::UTF_8)
  else
    return a.map{|i| i && (cyber i)}.join
  end
end
def says(a)
  say cyber a
end