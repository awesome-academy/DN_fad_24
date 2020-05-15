class ExportUser
  require "csv"

  def initialize objects, attributes
    @attributes = attributes
    @objects = objects
  end

  def perform
    CSV.generate do |csv|
      csv << attributes
      objects.each do |object|
        csv << attributes.map{|attr| object.public_send(attr)}
      end
    end
  end

  private
  attr_reader :attributes, :objects
end
