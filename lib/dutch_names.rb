module Dutchify
  DUTCH_NAMES = {
      'created_at' => 'aangemaakt op', 'created_on' => 'aangemaakt op',
      'updated_at' => 'aangepast op', 'updated_on' => 'aangepast op'
  }

  # Ensure all column.human_name gives dutch variant and introduce
  # model.human_name for error_messages_for method.
  module DutchNames
    # +name+ dutch name for object type
    # +column_names+ hash with column name translations to dutch
    def dutch_names(name, column_names = {})
      column_names = DUTCH_NAMES.merge(column_names).stringify_keys
    
      self.instance_variable_set '@dutch_name', name
      def self.human_name; @dutch_name; end

      self.instance_variable_set '@dutch_names', column_names
      def self.human_attribute_name(attr); @dutch_names[attr.to_s] || attr.to_s.humanize; end
    
      columns.each do |c|
        t = column_names[c.name]
        next unless t

        c.instance_variable_set "@dutch_name", t
        def c.human_name; @dutch_name; end
      end
    end
  end
end

ActiveRecord::Base.extend(Dutchify::DutchNames)
