require 'roo'
require 'csv'
class Article < ActiveRecord::Base
attr_accessible :title, :content
validates :title, presence: true,

                            length: { minimum: 5 }

        validates :content, presence: true,

                            length: { minimum: 10 }

        validates :status, presence: true

  self.per_page = 10


scope :status_active, -> {where(status: 'active')}
default_scope {where(status: 'active')}

has_many :comments, dependent: :destroy

def self.to_csv
	CSV.generate do |csv|
	csv << column_names
	all.each do |articles|
	csv << articles.attributes.values_at(*column_names)
	end
    	end
end

def self.to_xlsx (options = {}, id)
	CSV.generate(options) do |csv|
	csv << column_names
	csv << find_by_id(id).attributes.values_at(*column_names)
	#.each do |articles|
	#csv << articles.attributes.values_at(*column_names)
	#end
    end
end

def self.import(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    product = find_by_id(row["id"]) || new
    product.attributes = row.to_hash.slice(*accessible_attributes)
    product.save!
  end
end

def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when ".csv" then Roo::Spreadsheet.open(file.path, extension: :csv) 
  when ".xls" then Roo::Spreadsheet.open(file.path, extension: :xls)
  when ".xlsx" then Roo::Spreadsheet.open(file.path, extension: :xlsx)
  else raise "Unknown file type: #{file.original_filename}"
  end
end








end
