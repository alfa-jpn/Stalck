module MessageSearchers
  class Type < Inum::Base
    define :USER
    define :MESSAGE

    # Create searcher query.
    # @param [String] keyword keyword.
    # @return [String] query
    def create_query(keyword)
      case self
        when USER
          "from:@#{keyword}"
        when MESSAGE
          "*#{keyword}*"
      end
    end
  end
end
