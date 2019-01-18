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
        return if self.sequential_id
        options = self.class.sequence_options
        scope = self.class.class_exec(self, &options[:lmd])
        lock_candidates = scope.values
        lock_key = Digest::MD5.hexdigest(lock_candidates.join).unpack('L').join

        self.class.connection.execute("SELECT pg_advisory_xact_lock('#{self.class.table_name}'::regclass::integer, #{lock_key})", "sequence_on") if postgresql?
        last_sequential_id = if self.persisted?
                        self.class
                          .unscoped
                          .where(scope).
                          maximum(options[:column]).
                          where("NOT id = ?", self.id)
                      else
                        self.class
                          .unscoped
                          .where(scope).
                          maximum(options[:column])
                      end

        self.sequential_id = if last_sequential_id
                               (last_sequential_id || 0) + 1
                             else
                               options[:start_at]
                             end
      end
    end

    module ClassMethods

      def sequenced_on(lmd, options = {})
        include InstanceMethods
        mattr_accessor :sequence_options, instance_accessor: false
        before_save :generate_sequence_id
        self.sequence_options = DEFAULT_OPTIONS.merge(options).merge(lmd: lmd)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
