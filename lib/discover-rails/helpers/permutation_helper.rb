module DiscoverRails
  class PermutationHelper
    def self.callback_pairs
      ActiveRecord::Callbacks::CALLBACKS.map do |pair|
        pair.to_s.split('_').map(&:to_sym) + [pair]
      end
    end

    def self.callback_kinds
      CALLBACK_KINDS
    end

    def self.callback_names
      CALLBACK_NAMES
    end
  end
end

