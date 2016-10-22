module MessageSearchers
  class Type < Inum::Base
    define :ALL
    define :USER
    define :MESSAGE

    # Create searcher query.
    # @param [String] keyword keyword.
    # @return [String] query
    def create_query(keyword)
      keyword.split(' ').map { |word|
        case self
          when USER
            "from:@#{word}"
          when MESSAGE
            "*#{word}*"
        end
      }.join(' ')
    end
  end
end
