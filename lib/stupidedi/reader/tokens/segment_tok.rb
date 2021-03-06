# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    class SegmentTok
      include Inspect

      # @return [Symbol]
      attr_reader :id

      # @return [Array<CompositeElementTok, SimpleElementTok>]
      attr_reader :element_toks

      # @return [Position]
      attr_reader :position

      # @return [Position]
      attr_reader :remainder

      def initialize(id, element_toks, position, remainder)
        @id, @element_toks, @position, @remainder =
          id, element_toks, position, remainder
      end

      # @return [SegmentTok]
      def copy(changes = {})
        SegmentTok.new \
          changes.fetch(:id, @id),
          changes.fetch(:element_toks, @element_toks),
          changes.fetch(:position, @position),
          changes.fetch(:remainder, @remainder)
      end

      # :nocov:
      def pretty_print(q)
        q.pp(:segment.cons(@id.cons(@element_toks)))
      end
      # :nocov:

      def blank?
        @element_toks.all?(&:blank?)
      end

      def present?
        not blank?
      end

      def to_x12(separators)
        if blank?
          "#{id}#{separators.segment}"
        else
          es  = @element_toks.map{|x| x.to_x12(separators) }
          sep = separators.element || "*"
          eos = separators.segment || "~"
          id.cons(es).join(sep).gsub(/#{Regexp.escape(sep)}+$/, "") + eos.strip
        end
      end
    end

    class << SegmentTok
      # @group Constructors
      #########################################################################

      # @return [SegmentTok]
      def build(id, element_toks, position, remainder)
        new(id, element_toks, position, remainder)
      end

      # @endgroup
      #########################################################################
    end
  end
end
