module ConfigHound
  class Parser
    class DuplicateKeyError < ConfigHound::Error
      attr_reader :duplicates

      def initialize(duplicates)
        @duplicates = duplicates
        super(duplicates)
      end
    end
  end
end
