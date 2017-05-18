require 'sequence_on/sequenced_on'

ActiveRecord::Base.send(:include, SequenceOn::SequencedOn)
