module SequencedOn
  extend ActiveSupport::Concern

  class_methods do

    def sequence_on(l, opts={})
      @@seq_on = l
      @@seq_on_opts = opts
    end
  end

  included do
    before_create :generate_sequence_id, prepend: true

    private

    def postgresql?
      defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) &&
        self.class.connection.instance_of?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
    end

    def generate_sequence_id
      if postgresql?
        self.class.connection.execute("LOCK TABLE #{self.class.table_name} IN EXCLUSIVE MODE")
      end
      last_record = self.class.class_exec(self, &@@seq_on).
        order("sequential_id DESC").
        first
      self.sequential_id = if last_record
                             last_record.sequential_id + 1
                           else
                             opts[:starts_at] || 1
                           end
    end
  end
end
