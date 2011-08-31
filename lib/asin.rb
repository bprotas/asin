module ASIN
  autoload :Client,         'asin/client'
  autoload :SimpleItem,     'asin/simple_item'
  autoload :SimpleCart,     'asin/simple_cart'
  autoload :SimpleNode,     'asin/simple_node'
  autoload :Version,        'asin/version'
  autoload :Configuration,  'asin/configuration'
end

# We need these methods, but don't want to require Rails/ActiveSupport
# Code based on ActiveSupport's Inflector class:
# http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html
if !String.instance_methods.include? :camelize then
  class String
    def camelize
        self.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end
  end
end

if !String.instance_methods.include? :underscore then
  class String
    def underscore
      word = this.to_s.dup
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end
