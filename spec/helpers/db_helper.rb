module Mongoid::Document
  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
end

def clear_db
  all_models = Mongoid::Document.send(:descendants)
  all_models.each do |klass|
    klass.delete_all
  end
end
