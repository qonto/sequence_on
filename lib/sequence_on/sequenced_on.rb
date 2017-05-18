require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/class/attribute_accessors'

module SequenceOn

  module SequencedOn

    DEFAULT_OPTIONS = {
      column: :sequential_id,
      start_at: 1
    }.freeze

    module InstanceMethods

      private

      def postgresql?
        defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) &&
          self.class.connection.instance_of?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
      end

      def generate_sequence_id
        options = self.class.sequence_options
        self.class.connection.execute("LOCK TABLE #{self.class.table_name} IN EXCLUSIVE MODE") if postgresql?
        last_record = self.class.class_exec(self, &options[:lmd]).
          order("#{options[:column]} DESC").
          first
        self.sequential_id = if last_record
                               last_record.send(options[:column]) + 1
                             else
                               options[:start_at]
                             end
      end
    end

    module ClassMethods

      def sequenced_on(lmd, options = {})
        include InstanceMethods
        mattr_accessor :sequence_options, instance_accessor: false
        before_create :generate_sequence_id, prepend: true
        self.sequence_options = DEFAULT_OPTIONS.merge(options).merge(lmd: lmd)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
