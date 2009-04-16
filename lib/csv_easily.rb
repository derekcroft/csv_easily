module CsvEasily
  class << ActiveRecord::Base
    cattr_accessor :csv_directory, :csv_easily_block
    self.csv_directory ||= "#{RAILS_ROOT}/db"
    self.csv_easily_block ||= lambda {}

    def csv_file_name
      "#{self.csv_directory}/#{self.table_name}.csv"
    end

    def from_csv_easily
      self.transaction do
        self.destroy_all
        FasterCSV.foreach(self.csv_file_name, :headers => :first_row) do |row|
          self.create(row.to_hash) { |f| self.csv_easily_block.call(f, row) }
        end
      end
    end
  end
end
