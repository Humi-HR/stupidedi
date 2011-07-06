module Stupidedi
  module Values

    #
    # @see X12-5.pdf 3.2.1 Basic Interchange Service Request
    # @see X222.pdf B.1.1.4.1 Interchange Control Structures
    #
    class InterchangeVal < AbstractVal
      include SegmentValGroup

      # @return [InterchangeDef]
      attr_reader :definition

      # @return [Array<SegmentVal, FunctionalGroupVal>]
      attr_reader :children

      delegate :position, :to => "@children.head"

      def initialize(definition, children)
        @definition, @children =
          definition, children
      end

      def size
        @children.sum(&:size)
      end

      # @return [InterchangeVal]
      def copy(changes = {})
        InterchangeVal.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children)
      end

      # (see AbstractVal#interchange?)
      # @return true
      def interchange?
        true
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @children.select{|x| x.is_a?(SegmentVal) }
      end

      # @return [Module]
      def segment_dict
        @definition.segment_dict
      end

      # Note these will not contain the element and segment terminator, because
      # those are not values stored as part of the interchange. Those values are
      # stored in the state machine and can be retrieved by calling #separators
      # on StateMachine
      #
      # @return [Reader::Separators]
      def separators
        @definition.separators(segment_vals.head)
      end

      # @return [void]
      def pretty_print(q)
        id = @definition.try do |d|
          ansi.bold("[#{d.id.to_s}]")
        end

        q.text(ansi.envelope("InterchangeVal#{id}"))
        q.group(2, "(", ")") do
          q.breakable ""
          @children.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @return [String]
      def inspect
        ansi.envelope("Interchange") << "(#{@children.map(&:inspect).join(', ')})"
      end

      # @return [Boolean]
      def ==(other)
        eql?(other) or
         (other.definition == @definition and
          other.children   == @children)
      end
    end

  end
end